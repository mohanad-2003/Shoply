import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/l10n_lookup.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/onboarding_page_entity.dart';

class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({
    super.key,
    required this.page,
    this.pageOffset = 0,
  });

  final OnboardingPageEntity page;

  /// Distance from the currently centered page (0 = active, ±1 = a full
  /// swipe away). Drives a subtle parallax scale/fade so the active slide
  /// feels alive as the user swipes.
  final double pageOffset;

  @override
  Widget build(BuildContext context) {
    final distance = pageOffset.abs().clamp(0.0, 1.0);
    final scale = 1 - distance * 0.12;
    final opacity = 1 - distance * 0.35;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenH,
        vertical: AppSpacing.vLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: scale,
              child: SizedBox(
                height: 0.32.sh,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Soft decorative glow behind the illustration.
                    Container(
                      width: 0.6.sw,
                      height: 0.6.sw,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.seed.withValues(alpha: 0.16),
                            AppColors.seed.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: double.infinity,
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
                  ],
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
