import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/core/constants/app_constants.dart';
import 'package:ui_kit/core/constants/asset_paths.dart';
import 'package:ui_kit/core/di/injection.dart';
import 'package:ui_kit/core/extensions/context_extensions.dart';
import 'package:ui_kit/core/routing/route_names.dart';
import 'package:ui_kit/core/theme/app_colors.dart';
import 'package:ui_kit/features/splash/presentation/cubit/splash_cubit.dart';

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
            case SplashDestination.languageSelect:
              context.goNamed(RouteNames.nLanguageSelect);
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

class _SplashView extends StatefulWidget {
  const _SplashView();

  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView>
    with TickerProviderStateMixin {
  /// Drives the one-off entrance choreography (logo → title → tagline).
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..forward();

  /// Continuous, subtle pulse for the glow ring behind the logo.
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat(reverse: true);

  late final Animation<double> _logoFade = _curve(0.00, 0.45, Curves.easeOut);
  late final Animation<double> _logoScale = Tween<double>(
    begin: 0.6,
    end: 1,
  ).animate(_curve(0.00, 0.55, Curves.elasticOut));

  late final Animation<double> _titleFade = _curve(0.35, 0.65, Curves.easeOut);
  late final Animation<double> _titleSlide = Tween<double>(
    begin: 24,
    end: 0,
  ).animate(_curve(0.35, 0.70, Curves.easeOutCubic));

  late final Animation<double> _taglineFade =
      _curve(0.55, 0.85, Curves.easeOut);
  late final Animation<double> _footerFade = _curve(0.70, 1.00, Curves.easeOut);

  CurvedAnimation _curve(double begin, double end, Curve curve) =>
      CurvedAnimation(
        parent: _entrance,
        curve: Interval(begin, end, curve: curve),
      );

  @override
  void dispose() {
    _entrance.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primary = AppColors.seed;
    final deep = Color.lerp(primary, Colors.black, 0.45) ?? primary;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.lerp(primary, Colors.white, 0.08) ?? primary,
              primary,
              deep,
            ],
            stops: const [0, 0.55, 1],
          ),
        ),
        child: Stack(
          children: [
            // Decorative, softly-blurred brand orbs in the corners.
            Positioned(
              top: -80.r,
              right: -60.r,
              child: _Orb(
                size: 220.r,
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
            Positioned(
              bottom: -90.r,
              left: -70.r,
              child: _Orb(
                size: 260.r,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),

            // Center brand lockup.
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLogo(primary),
                  SizedBox(height: 28.h),
                  _buildTitle(context),
                  SizedBox(height: 10.h),
                  _buildTagline(context),
                ],
              ),
            ),

            // Bottom loader + version.
            Positioned(
              left: 0,
              right: 0,
              bottom: 48.h,
              child: FadeTransition(
                opacity: _footerFade,
                child: Column(
                  children: [
                    _DotsLoader(color: Colors.white.withValues(alpha: 0.9)),
                    SizedBox(height: 18.h),
                    Text(
                      '${AppConstants.appName} • v1.0.0',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.65),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(Color primary) {
    return FadeTransition(
      opacity: _logoFade,
      child: ScaleTransition(
        scale: _logoScale,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Pulsing glow ring behind the badge.
            AnimatedBuilder(
              animation: _pulse,
              builder: (_, _) {
                final t = _pulse.value;
                return Container(
                  width: (150 + 20 * t).r,
                  height: (150 + 20 * t).r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.10 + 0.06 * t),
                  ),
                );
              },
            ),
            Container(
              padding: EdgeInsets.all(28.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Image.asset(
                AssetPaths.logoIcon,
                width: 72.r,
                height: 72.r,
                errorBuilder: (_, _, _) => Icon(
                  Icons.shopping_bag_rounded,
                  size: 72.r,
                  color: primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return AnimatedBuilder(
      animation: _entrance,
      builder: (_, child) => Opacity(
        opacity: _titleFade.value,
        child: Transform.translate(
          offset: Offset(0, _titleSlide.value),
          child: child,
        ),
      ),
      child: Text(
        AppConstants.appName,
        style: context.textTheme.displaySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildTagline(BuildContext context) {
    return FadeTransition(
      opacity: _taglineFade,
      child: Text(
        'Premium Shopping Experience',
        style: context.textTheme.bodyMedium?.copyWith(
          color: Colors.white.withValues(alpha: 0.85),
          letterSpacing: 2,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

/// A soft, translucent decorative circle used as a background accent.
class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}

/// Three dots that pulse in a travelling wave — a lightweight, premium
/// loading cue that reads better than a stock spinner on a brand screen.
class _DotsLoader extends StatefulWidget {
  const _DotsLoader({required this.color});

  final Color color;

  @override
  State<_DotsLoader> createState() => _DotsLoaderState();
}

class _DotsLoaderState extends State<_DotsLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            // Phase each dot so the wave travels left → right.
            final phase = (_controller.value - i * 0.2) % 1.0;
            final wave = math.sin(phase * math.pi).clamp(0.0, 1.0);
            return Container(
              width: 8.r,
              height: 8.r,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withValues(alpha: 0.35 + 0.65 * wave),
              ),
            );
          }),
        );
      },
    );
  }
}
