import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/custom_snackbar.dart';

/// UI-only social sign-in row (no real OAuth in Phase 1).
class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SocialButton(asset: AssetPaths.socialGoogle),
        SizedBox(width: AppSpacing.md),
        _SocialButton(asset: AssetPaths.socialApple),
        SizedBox(width: AppSpacing.md),
        _SocialButton(asset: AssetPaths.socialFacebook),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: AppRadius.rMd,
        onTap: () => AppSnackbar.show(
          context,
          message: context.l10n.comingSoon,
        ),
        child: Container(
          height: 54.h,
          decoration: BoxDecoration(
            borderRadius: AppRadius.rMd,
            border: Border.all(color: context.colors.outlineVariant),
          ),
          alignment: Alignment.center,
          child: Image.asset(
            asset,
            height: 24.r,
            width: 24.r,
            errorBuilder: (_, _, _) =>
                Icon(Icons.login_rounded, size: 22.r),
          ),
        ),
      ),
    );
  }
}
