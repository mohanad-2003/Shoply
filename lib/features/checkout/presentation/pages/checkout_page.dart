import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/l10n_lookup.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/custom_bottom_sheet.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../cart/domain/entities/promo_code_entity.dart';
import '../../../cart/presentation/widgets/price_summary_card.dart';
import '../cubit/checkout_cubit.dart';
import '../widgets/address_card.dart';
import '../widgets/order_item_row.dart';
import '../widgets/order_success_sheet.dart';
import '../widgets/payment_method_tile.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key, this.promo});

  /// Discount carried over from the cart, if one was applied.
  final PromoCodeEntity? promo;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CheckoutCubit>()..load(promo),
      child: const _CheckoutView(),
    );
  }
}

class _CheckoutView extends StatelessWidget {
  const _CheckoutView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBarWidget(title: l10n.checkoutTitle),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == CheckoutStatus.success) {
            _showSuccess(context, state.orderNumber ?? '');
          }
        },
        builder: (context, state) {
          return switch (state.status) {
            CheckoutStatus.loading => const Center(
                child: CircularProgressIndicator(),
              ),
            CheckoutStatus.error => ErrorStateWidget(
                message: state.failureKey != null
                    ? tr(context, state.failureKey!)
                    : l10n.somethingWentWrong,
                onRetry: () =>
                    context.read<CheckoutCubit>().load(null),
              ),
            _ => _CheckoutBody(state: state),
          };
        },
      ),
    );
  }

  void _showSuccess(BuildContext context, String orderNumber) {
    AppBottomSheet.show(
      context,
      isScrollControlled: true,
      child: OrderSuccessSheet(
        orderNumber: orderNumber,
        onContinue: () {
          Navigator.of(context).pop(); // close the sheet
          context.goNamed(RouteNames.nHome);
        },
      ),
    );
  }
}

class _CheckoutBody extends StatelessWidget {
  const _CheckoutBody({required this.state});

  final CheckoutState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<CheckoutCubit>();
    final address = state.selectedAddress;
    final isPlacing = state.status == CheckoutStatus.placing;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              AppSpacing.screenV,
              AppSpacing.screenH,
              AppSpacing.vLg,
            ),
            children: [
              // ── Shipping address ──────────────────────────────────
              SectionHeader(
                title: l10n.shippingAddress,
                actionLabel: state.addresses.length > 1 ? l10n.change : null,
                onAction: state.addresses.length > 1
                    ? () => _pickAddress(context, cubit)
                    : null,
              ),
              SizedBox(height: AppSpacing.vMd),
              if (address != null) AddressCard(address: address),

              SizedBox(height: AppSpacing.vXl),

              // ── Payment method ────────────────────────────────────
              SectionHeader(title: l10n.paymentMethod),
              SizedBox(height: AppSpacing.vMd),
              ...state.paymentMethods.map(
                (method) => Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.vSm),
                  child: PaymentMethodTile(
                    method: method,
                    selected: method.id == state.selectedPaymentId,
                    onTap: () => cubit.selectPayment(method.id),
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.vLg),

              // ── Order summary ─────────────────────────────────────
              SectionHeader(title: l10n.orderSummary),
              SizedBox(height: AppSpacing.vMd),
              Container(
                padding: EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: AppRadius.rLg,
                  border: Border.all(color: context.colors.outlineVariant),
                ),
                child: Column(
                  children: [
                    ...state.items.map(
                      (item) => Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.vMd),
                        child: OrderItemRow(item: item),
                      ),
                    ),
                    const Divider(),
                    SizedBox(height: AppSpacing.vSm),
                    if (state.summary != null)
                      PriceSummaryCard(summary: state.summary!),
                  ],
                ),
              ),

              SizedBox(height: AppSpacing.vLg),
              const _DeliveryEstimate(),
            ],
          ),
        ),
        _CheckoutBar(
          total: state.summary?.total ?? 0,
          isPlacing: isPlacing,
          onPlaceOrder: cubit.placeOrder,
        ),
      ],
    );
  }

  void _pickAddress(BuildContext context, CheckoutCubit cubit) {
    AppBottomSheet.show(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.shippingAddress,
            style: context.textTheme.titleLarge,
          ),
          SizedBox(height: AppSpacing.vLg),
          ...state.addresses.map(
            (a) => Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.vSm),
              child: AddressCard(
                address: a,
                selected: a.id == state.selectedAddressId,
                onTap: () {
                  cubit.selectAddress(a.id);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryEstimate extends StatelessWidget {
  const _DeliveryEstimate();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Icon(Icons.local_shipping_outlined, size: 20.r, color: colors.primary),
        SizedBox(width: AppSpacing.sm),
        Text(
          '${context.l10n.estimatedDelivery}: ',
          style: context.textTheme.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
        Text(
          context.l10n.deliveryWindow,
          style: context.textTheme.titleSmall,
        ),
      ],
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({
    required this.total,
    required this.isPlacing,
    required this.onPlaceOrder,
  });

  final double total;
  final bool isPlacing;
  final VoidCallback onPlaceOrder;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: EdgeInsets.all(AppSpacing.screenH),
      decoration: BoxDecoration(
        color: context.colors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.total,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                Text(
                  total.toPrice(),
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(width: AppSpacing.lg),
            Expanded(
              child: AppButton(
                label: l10n.placeOrder,
                icon: Icons.lock_outline_rounded,
                isLoading: isPlacing,
                onPressed: onPlaceOrder,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
