import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/l10n_lookup.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/onboarding_page_entity.dart';

class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({super.key, required this.page});

  final OnboardingPageEntity page;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenH,
        vertical: AppSpacing.vLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 0.32.sh,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: AppSpacing.vXxl),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.seed.withValues(alpha: 0.14),
                    context.colors.surfaceContainerHighest,
                  ],
                ),
                borderRadius: AppRadius.rXxl,
              ),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.vXl,
                ),
                child: Image.asset(
                  page.imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Icon(
                    Icons.image_outlined,
                    size: 80.r,
                    color: context.colors.primary,
                  ),
                ),
              ),
            ),
          ),
          Text(
            tr(context, page.titleKey),
            style: context.textTheme.headlineMedium,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSpacing.vMd),
          Text(
            tr(context, page.bodyKey),
            style: context.textTheme.bodyMedium,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSpacing.vXxl),
        ],
      ),
    );
  }
}
