import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/l10n_lookup.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../bloc/wishlist_bloc.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WishlistBloc>()..add(const WishlistStarted()),
      child: const _WishlistView(),
    );
  }
}

class _WishlistView extends StatelessWidget {
  const _WishlistView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBarWidget(title: l10n.wishlist, showBack: false),
      body: SafeArea(
        child: BlocBuilder<WishlistBloc, WishlistState>(
          builder: (context, state) {
            return switch (state.status) {
              WishlistStatus.loading => const Center(
                  child: CircularProgressIndicator(),
                ),
              WishlistStatus.error => ErrorStateWidget(
                  message: state.failureKey != null
                      ? tr(context, state.failureKey!)
                      : l10n.somethingWentWrong,
                  onRetry: () => context
                      .read<WishlistBloc>()
                      .add(const WishlistStarted()),
                ),
              WishlistStatus.empty => EmptyStateWidget(
                  icon: Icons.favorite_border_rounded,
                  title: l10n.emptyWishlistTitle,
                  message: l10n.emptyWishlistBody,
                  actionLabel: l10n.browseProducts,
                  onAction: () => context.goNamed(RouteNames.nHome),
                ),
              WishlistStatus.loaded => _WishlistGrid(products: state.products),
            };
          },
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }
}

class _WishlistGrid extends StatelessWidget {
  const _WishlistGrid({required this.products});

  final List<ProductEntity> products;

  @override
  Widget build(BuildContext context) {
    void openProduct(ProductEntity p) => context.pushNamed(
          RouteNames.nProduct,
          pathParameters: {'id': p.id},
        );

    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenH,
        vertical: AppSpacing.vLg,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.vLg,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.62,
      ),
      itemCount: products.length,
      itemBuilder: (_, i) {
        final p = products[i];
        return ProductCard(
          imagePath: p.imagePath,
          title: p.name,
          price: p.price,
          originalPrice: p.originalPrice,
          rating: p.rating,
          isFavorite: true,
          onTap: () => openProduct(p),
          onFavoriteToggle: () =>
              context.read<WishlistBloc>().add(WishlistItemRemoved(p.id)),
        );
      },
    );
  }
}
