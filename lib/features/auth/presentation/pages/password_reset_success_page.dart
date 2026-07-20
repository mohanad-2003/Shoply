import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';

class PasswordResetSuccessPage extends StatelessWidget {
  const PasswordResetSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 112.w,
                              height: 112.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color:
                                    AppColors.success.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                width: 72.w,
                                height: 72.w,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 40.r,
                                ),
                              ),
                            ),
                            SizedBox(height: AppSpacing.vXxl),
                            Text(
                              l10n.passwordResetSuccessTitle,
                              style: context.textTheme.displayLarge,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: AppSpacing.vMd),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md),
                              child: Text(
                                l10n.passwordResetSuccessBody,
                                style: context.textTheme.bodyLarge?.copyWith(
                                  color: context.colors.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: AppSpacing.vXxl),
                      AppButton(
                        label: l10n.backToLogin,
                        onPressed: () => context.goNamed(RouteNames.nLogin),
                      ),
                      SizedBox(height: AppSpacing.vMd),
                    ],
                  ),
                ),
              );
          },
        ),
      ),
    );
  }
}
