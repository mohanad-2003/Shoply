import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/asset_paths.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/route_names.dart';
import '../cubit/splash_cubit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SplashCubit>()..decide(),
      child: BlocListener<SplashCubit, SplashDestination?>(
        listener: (context, destination) {
          if (destination == null) return;
          switch (destination) {
            case SplashDestination.onboarding:
              context.goNamed(RouteNames.nOnboarding);
            case SplashDestination.login:
              context.goNamed(RouteNames.nLogin);
            case SplashDestination.home:
              context.goNamed(RouteNames.nHome);
          }
        },
        child: const _SplashView(),
      ),
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(28.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28.r),
              ),
              child: Image.asset(
                AssetPaths.logoIcon,
                width: 72.r,
                height: 72.r,
                errorBuilder: (_, _, _) => Icon(
                  Icons.shopping_bag_rounded,
                  size: 72.r,
                  color: context.colors.primary,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              AppConstants.appName,
              style: context.textTheme.headlineMedium
                  ?.copyWith(color: Colors.white),
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: 26.r,
              height: 26.r,
              child: const CircularProgressIndicator(
                strokeWidth: 2.4,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
