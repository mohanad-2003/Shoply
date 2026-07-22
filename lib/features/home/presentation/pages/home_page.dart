import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/l10n_lookup.dart';
import '../../../../core/localization/locale_cubit.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/shimmer_widgets.dart';
import '../../../../core/widgets/staggered_reveal.dart';
import '../../../../core/routing/route_names.dart';
import '../../../catalog/presentation/pages/catalog_page.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/home_bloc.dart';
import '../widgets/category_list.dart';
import '../widgets/hero_banner_carousel.dart';
import '../widgets/product_section.dart';
import '../widgets/search_bar_entry.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(const HomeStarted()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(const HomeRefreshed());
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: _TopBar()),
                  if (state.status == HomeStatus.error)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: ErrorStateWidget(
                        message: state.failureKey != null
                            ? tr(context, state.failureKey!)
                            : l10n.somethingWentWrong,
                        onRetry: () =>
                            context.read<HomeBloc>().add(const HomeStarted()),
                      ),
                    )
                  else if (state.status == HomeStatus.loaded &&
                      state.data != null)
                    SliverToBoxAdapter(child: _HomeContent(state: state))
                  else
                    const SliverToBoxAdapter(child: _HomeLoading()),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.vMd,
        AppSpacing.screenH,
        AppSpacing.vSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.goodMorning, style: context.textTheme.bodySmall),
                    Text(l10n.appName, style: context.textTheme.titleLarge),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => context.read<ThemeCubit>().toggle(),
                icon: Icon(
                  context.isDark
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                ),
              ),
              IconButton(
                onPressed: () => context.read<LocaleCubit>().toggle(),
                icon: const Icon(Icons.translate_rounded),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.vMd),
          const SearchBarEntry(),
          SizedBox(height: AppSpacing.vLg),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final data = state.data!;
    final l10n = context.l10n;

    void toggleFav(ProductEntity p) =>
        context.read<HomeBloc>().add(HomeFavoriteToggled(p.id));
    void openProduct(ProductEntity p) =>
        context.pushNamed(RouteNames.nProduct, pathParameters: {'id': p.id});
    void addToCart(ProductEntity p) {
      context.read<HomeBloc>().add(HomeAddToCartRequested(p));
      AppSnackbar.success(context, l10n.addedToCart);
    }

    void openCatalog(String title, {String? categoryId}) => context.pushNamed(
      RouteNames.nCatalog,
      extra: CatalogArgs(title: title, categoryId: categoryId),
    );

    // Sequential entrance: each block reveals slightly after the previous.
    var step = 0;
    Widget reveal(Widget child) => StaggeredReveal(
      delay: Duration(milliseconds: 80 * step++),
      child: child,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        reveal(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
            child: HeroBannerCarousel(banners: data.banners),
          ),
        ),
        SizedBox(height: AppSpacing.vXl),
        reveal(
          Padding(
            padding: EdgeInsets.only(left: AppSpacing.screenH),
            child: CategoryList(
              categories: data.categories,
              onTap: (c) => openCatalog(c.name, categoryId: c.id),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.vXl),
        reveal(
          ProductSection(
            title: l10n.flashSale,
            products: data.flashSale,
            onSeeAll: () => openCatalog(l10n.flashSale),
            onProductTap: openProduct,
            onFavoriteToggle: toggleFav,
            onAddToCart: addToCart,
          ),
        ),
        reveal(
          ProductSection(
            title: l10n.featured,
            products: data.featured,
            onSeeAll: () => openCatalog(l10n.featured),
            onProductTap: openProduct,
            onFavoriteToggle: toggleFav,
            onAddToCart: addToCart,
          ),
        ),
        reveal(
          ProductSection(
            title: l10n.newArrivals,
            products: data.newArrivals,
            onSeeAll: () => openCatalog(l10n.newArrivals),
            onProductTap: openProduct,
            onFavoriteToggle: toggleFav,
            onAddToCart: addToCart,
          ),
        ),
        reveal(
          ProductSection(
            title: l10n.bestSellers,
            products: data.bestSellers,
            onSeeAll: () => openCatalog(l10n.bestSellers),
            onProductTap: openProduct,
            onFavoriteToggle: toggleFav,
            onAddToCart: addToCart,
          ),
        ),
        SizedBox(height: AppSpacing.vXxl),
      ],
    );
  }
}

class _HomeLoading extends StatelessWidget {
  const _HomeLoading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppShimmer(
            child: ShimmerBox(width: double.infinity, height: 160.h),
          ),
          SizedBox(height: AppSpacing.vXl),
          const HorizontalListShimmer(height: 96),
          SizedBox(height: AppSpacing.vXl),
          const HorizontalListShimmer(height: 220),
          SizedBox(height: AppSpacing.vXl),
          const HorizontalListShimmer(height: 220),
        ],
      ),
    );
  }
}
