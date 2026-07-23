import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/core/di/injection.dart';
import 'package:ui_kit/core/extensions/context_extensions.dart';
import 'package:ui_kit/core/localization/l10n_lookup.dart';
import 'package:ui_kit/core/routing/route_names.dart';
import 'package:ui_kit/core/widgets/app_bar_widget.dart';
import 'package:ui_kit/core/widgets/custom_snackbar.dart';
import 'package:ui_kit/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:ui_kit/features/home/domain/entities/product_entity.dart';

import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../widgets/product_grid.dart';

/// Navigation payload for [CatalogPage], passed as go_router `extra`.
class CatalogArgs {
  const CatalogArgs({required this.title, this.categoryId});

  final String title;
  final String? categoryId;
}

/// Product listing for a category tap or a section "See All".
class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key, required this.title, this.categoryId});

  final String title;
  final String? categoryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CatalogCubit>()..load(categoryId: categoryId),
      child: _CatalogView(title: title),
    );
  }
}

class _CatalogView extends StatelessWidget {
  const _CatalogView({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBarWidget(title: title),
      body: SafeArea(
        top: false,
        child: BlocBuilder<CatalogCubit, CatalogState>(
          builder: (context, state) {
            return switch (state.status) {
              CatalogStatus.loading || CatalogStatus.initial => const Center(
                child: CircularProgressIndicator(),
              ),
              CatalogStatus.error => ErrorStateWidget(
                message: state.failureKey != null
                    ? tr(context, state.failureKey!)
                    : l10n.somethingWentWrong,
                onRetry: () => context.read<CatalogCubit>().load(),
              ),
              CatalogStatus.empty => EmptyStateWidget(
                title: l10n.noProductsTitle,
                message: l10n.noProductsBody,
                icon: Icons.inventory_2_outlined,
              ),
              CatalogStatus.loaded => ProductGrid(
                products: state.products,
                onProductTap: (p) => _open(context, p),
                onFavoriteToggle: (p) =>
                    context.read<CatalogCubit>().toggleFavorite(p.id),
                onAddToCart: (p) {
                  context.read<CatalogCubit>().addToCart(p);
                  AppSnackbar.success(context, l10n.addedToCart);
                },
              ),
            };
          },
        ),
      ),
    );
  }

  void _open(BuildContext context, ProductEntity p) =>
      context.pushNamed(RouteNames.nProduct, pathParameters: {'id': p.id});
}
