import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../core/localization/l10n_lookup.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/rating_stars.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../bloc/product_detail_bloc.dart';
import '../widgets/product_actions_bar.dart';
import '../widgets/product_gallery.dart';
import '../widgets/rating_summary.dart';
import '../widgets/related_products_list.dart';
import '../widgets/variant_selector.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ProductDetailBloc>()..add(ProductDetailRequested(productId)),
      child: _ProductDetailView(productId: productId),
    );
  }
}

class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView({required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: BlocConsumer<ProductDetailBloc, ProductDetailState>(
        listenWhen: (prev, curr) =>
            prev.addedToCartTick != curr.addedToCartTick,
        listener: (context, state) {
          if (state.addedToCartTick > 0) {
            AppSnackbar.success(context, l10n.addedToCart);
          }
        },
        builder: (context, state) {
          return switch (state.status) {
            ProductDetailStatus.loading ||
            ProductDetailStatus.initial =>
              const Center(child: CircularProgressIndicator()),
            ProductDetailStatus.error => SafeArea(
                child: Column(
                  children: [
                    _MiniBar(title: l10n.productDetails),
                    Expanded(
                      child: ErrorStateWidget(
                        message: state.failureKey != null
                            ? tr(context, state.failureKey!)
                            : l10n.somethingWentWrong,
                        onRetry: () => context
                            .read<ProductDetailBloc>()
                            .add(ProductDetailRequested(productId)),
                      ),
                    ),
                  ],
                ),
              ),
            ProductDetailStatus.loaded =>
              _LoadedView(state: state, productId: productId),
          };
        },
      ),
    );
  }
}

class _MiniBar extends StatelessWidget {
  const _MiniBar({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
          Text(title, style: context.textTheme.titleLarge),
        ],
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  const _LoadedView({required this.state, required this.productId});

  final ProductDetailState state;
  final String productId;

  void _openRelated(BuildContext context, ProductEntity p) {
    context.pushReplacementNamed(
      RouteNames.nProduct,
      pathParameters: {'id': p.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    final detail = state.detail!;
    final product = detail.product;
    final l10n = context.l10n;
    final bloc = context.read<ProductDetailBloc>();

    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 360.h,
                backgroundColor: context.colors.surface,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => context.pop(),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      product.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: product.isFavorite ? AppColors.accent : null,
                    ),
                    onPressed: () =>
                        bloc.add(const ProductFavoriteToggled()),
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined),
                    onPressed: () => context.pushNamed(RouteNames.nCart),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: EdgeInsets.only(top: 56.h),
                    child: ProductGallery(images: detail.gallery),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.screenH),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.brand,
                          style: context.textTheme.labelMedium?.copyWith(
                              color: context.colors.primary)),
                      SizedBox(height: 4.h),
                      Text(product.name,
                          style: context.textTheme.headlineMedium),
                      SizedBox(height: AppSpacing.vSm),
                      Row(
                        children: [
                          RatingStars(rating: product.rating, size: 16.r),
                          SizedBox(width: 8.w),
                          Text(
                            '${product.rating} (${product.reviewCount})',
                            style: context.textTheme.bodySmall,
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: detail.inStock
                                  ? AppColors.success.withValues(alpha: 0.15)
                                  : AppColors.error.withValues(alpha: 0.15),
                              borderRadius: AppRadius.rSm,
                            ),
                            child: Text(
                              detail.inStock ? l10n.inStock : l10n.outOfStock,
                              style: context.textTheme.labelSmall?.copyWith(
                                color: detail.inStock
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.vMd),
                      Row(
                        children: [
                          Text(product.price.toPrice(),
                              style: context.textTheme.headlineMedium
                                  ?.copyWith(color: context.colors.primary)),
                          if (product.hasDiscount) ...[
                            SizedBox(width: AppSpacing.md),
                            Text(
                              product.originalPrice!.toPrice(),
                              style: context.textTheme.titleMedium?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: context.colors.outline,
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: AppSpacing.vXl),
                      VariantSelector(
                        label: l10n.selectColor,
                        options: detail.variant.colors,
                        selected: state.selectedColor,
                        onSelected: (c) =>
                            bloc.add(ProductColorSelected(c)),
                      ),
                      SizedBox(height: AppSpacing.vXl),
                      VariantSelector(
                        label: l10n.selectSize,
                        options: detail.variant.sizes,
                        selected: state.selectedSize,
                        onSelected: (s) => bloc.add(ProductSizeSelected(s)),
                      ),
                      SizedBox(height: AppSpacing.vXxl),
                      Text(l10n.description,
                          style: context.textTheme.titleLarge),
                      SizedBox(height: AppSpacing.vMd),
                      Text(detail.description,
                          style: context.textTheme.bodyMedium),
                      SizedBox(height: AppSpacing.vXxl),
                      Text(l10n.reviews,
                          style: context.textTheme.titleLarge),
                      SizedBox(height: AppSpacing.vMd),
                      RatingSummary(
                        rating: product.rating,
                        reviewCount: product.reviewCount,
                        reviews: detail.reviews,
                      ),
                      if (state.related.isNotEmpty) ...[
                        SizedBox(height: AppSpacing.vXxl),
                        Text(l10n.relatedProducts,
                            style: context.textTheme.titleLarge),
                        SizedBox(height: AppSpacing.vMd),
                      ],
                    ],
                  ),
                ),
              ),
              if (state.related.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
                    child: RelatedProductsList(
                      products: state.related,
                      onTap: (p) => _openRelated(context, p),
                    ),
                  ),
                ),
              SliverToBoxAdapter(child: SizedBox(height: AppSpacing.vXxl)),
            ],
          ),
        ),
        ProductActionsBar(
          quantity: state.quantity,
          unitPrice: product.price,
          inStock: detail.inStock,
          onQuantityChanged: (q) => bloc.add(ProductQuantityChanged(q)),
          onAddToCart: () => bloc.add(const ProductAddToCartRequested()),
        ),
      ],
    );
  }
}
