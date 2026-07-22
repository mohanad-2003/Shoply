import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../cubit/catalog_cubit.dart';
import '../widgets/product_grid.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CatalogCubit>(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  Timer? _debounce;

  static const _suggestions = [
    'Nike',
    'Dress',
    'Sneakers',
    'Jacket',
    'Bag',
    'Sunglasses',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      final q = value.trim();
      if (q.isEmpty) {
        context.read<CatalogCubit>().reset();
      } else {
        context.read<CatalogCubit>().search(q);
      }
    });
  }

  void _submitTerm(String term) {
    _controller.text = term;
    _focus.unfocus();
    context.read<CatalogCubit>().search(term);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: _SearchField(
          controller: _controller,
          focusNode: _focus,
          hint: l10n.searchHint,
          onChanged: _onChanged,
          onClear: () {
            _controller.clear();
            context.read<CatalogCubit>().reset();
            _focus.requestFocus();
          },
        ),
      ),
      body: SafeArea(
        top: false,
        child: BlocBuilder<CatalogCubit, CatalogState>(
          builder: (context, state) {
            return switch (state.status) {
              CatalogStatus.initial => _Suggestions(
                  terms: _suggestions,
                  onTap: _submitTerm,
                ),
              CatalogStatus.loading => const Center(
                  child: CircularProgressIndicator(),
                ),
              CatalogStatus.empty => EmptyStateWidget(
                  title: l10n.noResultsTitle,
                  message: l10n.noResultsBody(state.query),
                  icon: Icons.search_off_rounded,
                ),
              _ => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.screenH,
                        AppSpacing.vMd,
                        AppSpacing.screenH,
                        0,
                      ),
                      child: Text(
                        l10n.resultsCount(state.products.length),
                        style: context.textTheme.labelLarge?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ProductGrid(
                        products: state.products,
                        onProductTap: (p) => _open(context, p),
                        onFavoriteToggle: (p) =>
                            context.read<CatalogCubit>().toggleFavorite(p.id),
                        onAddToCart: (p) {
                          context.read<CatalogCubit>().addToCart(p);
                          AppSnackbar.success(context, l10n.addedToCart);
                        },
                      ),
                    ),
                  ],
                ),
            };
          },
        ),
      ),
    );
  }

  void _open(BuildContext context, ProductEntity p) => context.pushNamed(
        RouteNames.nProduct,
        pathParameters: {'id': p.id},
      );
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: AppSpacing.md),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textInputAction: TextInputAction.search,
        onChanged: onChanged,
        style: context.textTheme.bodyLarge,
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          filled: true,
          fillColor: context.colors.surfaceContainerHighest,
          prefixIcon: Icon(Icons.search_rounded, size: 22.r),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, _) => value.text.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    icon: Icon(Icons.close_rounded, size: 20.r),
                    onPressed: onClear,
                  ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
          border: OutlineInputBorder(
            borderRadius: AppRadius.rMd,
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _Suggestions extends StatelessWidget {
  const _Suggestions({required this.terms, required this.onTap});

  final List<String> terms;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: EdgeInsets.all(AppSpacing.screenH),
      children: [
        Text(l10n.popularSearches, style: context.textTheme.titleMedium),
        SizedBox(height: AppSpacing.vLg),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final term in terms)
              ActionChip(
                label: Text(term),
                avatar: Icon(Icons.trending_up_rounded, size: 16.r),
                onPressed: () => onTap(term),
              ),
          ],
        ),
      ],
    );
  }
}
