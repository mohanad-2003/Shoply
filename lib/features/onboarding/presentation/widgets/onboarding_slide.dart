import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/l10n_lookup.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/onboarding_page_entity.dart';

class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({super.key, required this.page});

  final OnboardingPageEntity page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: AppSpacing.vXxl),
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerHighest,
                borderRadius: AppRadius.rXxl,
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                page.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Icon(
                  Icons.image_outlined,
                  size: 80.r,
                  color: context.colors.primary,
                ),
              ),
            ),
          ),
          Text(
            tr(context, page.titleKey),
            style: context.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.vMd),
          Text(
            tr(context, page.bodyKey),
            style: context.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.vXxl),
        ],
      ),
    );
  }
}
