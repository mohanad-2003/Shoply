import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/core/di/injection.dart';
import 'package:ui_kit/core/extensions/context_extensions.dart';
import 'package:ui_kit/core/routing/route_names.dart';
import 'package:ui_kit/core/theme/app_radius.dart';
import 'package:ui_kit/core/theme/app_spacing.dart';
import 'package:ui_kit/core/widgets/app_button.dart';
import 'package:ui_kit/core/widgets/language_option_tile.dart';
import 'package:ui_kit/features/language_select/presentation/cubit/language_select_cubit.dart';

class LanguageSelectPage extends StatelessWidget {
  const LanguageSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LanguageSelectCubit>(),
      child: const _LanguageSelectView(),
    );
  }
}

class _LanguageSelectView extends StatelessWidget {
  const _LanguageSelectView();

  Future<void> _continue(BuildContext context) async {
    await context.read<LanguageSelectCubit>().confirm();
    if (context.mounted) context.goNamed(RouteNames.nOnboarding);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<LanguageSelectCubit, Locale>(
          builder: (context, locale) {
            final cubit = context.read<LanguageSelectCubit>();
            final isArabic = locale.languageCode == 'ar';
            return LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenH,
                  vertical: AppSpacing.vXl,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        constraints.maxHeight - AppSpacing.vXl - AppSpacing.vXl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 72.w,
                        height: 72.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: context.colors.primary.withValues(alpha: 0.12),
                          borderRadius: AppRadius.rXl,
                        ),
                        child: Icon(
                          Icons.language_rounded,
                          size: 36.r,
                          color: context.colors.primary,
                        ),
                      ),
                      SizedBox(height: AppSpacing.vXxl),
                      Text(
                        l10n.selectLanguage,
                        style: context.textTheme.displayLarge,
                      ),
                      SizedBox(height: AppSpacing.vMd),
                      Text(
                        l10n.selectLanguageSubtitle,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: AppSpacing.vXxxl),
                      LanguageOptionTile(
                        title: 'English',
                        subtitle: 'English',
                        glyph: '🇬🇧',
                        selected: !isArabic,
                        onTap: () => cubit.select(const Locale('en')),
                      ),
                      SizedBox(height: AppSpacing.vLg),
                      LanguageOptionTile(
                        title: 'العربية',
                        subtitle: 'Arabic',
                        glyph: '🇸🇦',
                        selected: isArabic,
                        onTap: () => cubit.select(const Locale('ar')),
                      ),
                      SizedBox(height: AppSpacing.vXxxl),
                      AppButton(
                        label: l10n.continueLabel,
                        onPressed: () => _continue(context),
                      ),
                      SizedBox(height: AppSpacing.vMd),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
