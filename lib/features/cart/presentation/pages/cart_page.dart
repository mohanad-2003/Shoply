import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../core/localization/l10n_lookup.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../bloc/cart_bloc.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/free_shipping_progress.dart';
import '../widgets/price_summary_card.dart';
import '../widgets/promo_code_input.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CartBloc>()..add(const CartStarted()),
      child: const _CartView(),
    );
  }
}

class _CartView extends StatelessWidget {
  const _CartView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBarWidget(title: l10n.myCart),
      body: SafeArea(
        top: false,
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            return switch (state.status) {
              CartStatus.loading => const Center(
                  child: CircularProgressIndicator(),
                ),
              CartStatus.error => ErrorStateWidget(
                  message: state.failureKey != null
                      ? tr(context, state.failureKey!)
                      : l10n.somethingWentWrong,
                  onRetry: () =>
                      context.read<CartBloc>().add(const CartStarted()),
                ),
              CartStatus.empty => EmptyStateWidget(
                  title: l10n.emptyCartTitle,
                  message: l10n.emptyCartBody,
                  icon: Icons.shopping_bag_outlined,
                  actionLabel: l10n.startShopping,
                  onAction: () => context.goNamed(RouteNames.nHome),
                ),
              CartStatus.loaded => _LoadedCart(state: state),
            };
          },
        ),
      ),
    );
  }
}

class _LoadedCart extends StatelessWidget {
  const _LoadedCart({required this.state});

  final CartState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<CartBloc>();
    final summary = state.summary;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(AppSpacing.screenH),
            children: [
              if (summary != null) ...[
                FreeShippingProgress(subtotal: summary.subtotal),
                SizedBox(height: AppSpacing.vLg),
                Text(
                  l10n.cartItemsCount(summary.itemCount),
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: AppSpacing.vMd),
              ],
              ...state.items.map((item) => Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.vMd),
                    child: CartItemTile(
                      item: item,
                      onQuantityChanged: (q) =>
                          bloc.add(CartQuantityChanged(item.id, q)),
                      onRemoved: () {
                        bloc.add(CartItemRemoved(item.id));
                        AppSnackbar.show(context, message: l10n.itemRemoved);
                      },
                    ),
                  )),
              SizedBox(height: AppSpacing.vMd),
              PromoCodeInput(
                applied: state.promo,
                isApplying: state.applyingPromo,
                hasError: state.promoError,
                onApply: (code) => bloc.add(CartPromoApplied(code)),
                onRemove: () => bloc.add(const CartPromoRemoved()),
              ),
              SizedBox(height: AppSpacing.vXl),
              if (summary != null) PriceSummaryCard(summary: summary),
            ],
          ),
        ),
        _CheckoutBar(
          total: summary?.total ?? 0,
          itemCount: summary?.itemCount ?? 0,
          onCheckout: () => context.pushNamed(
            RouteNames.nCheckout,
            extra: state.promo,
          ),
        ),
      ],
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({
    required this.total,
    required this.itemCount,
    required this.onCheckout,
  });

  final double total;
  final int itemCount;
  final VoidCallback onCheckout;

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
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
                    label: l10n.checkout,
                    icon: Icons.lock_outline_rounded,
                    onPressed: onCheckout,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.vSm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 14.r,
                  color: context.colors.onSurfaceVariant,
                ),
                SizedBox(width: AppSpacing.xs),
                Text(
                  l10n.secureCheckout,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
