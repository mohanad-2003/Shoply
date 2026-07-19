import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../cubit/onboarding_cubit.dart';
import '../widgets/onboarding_slide.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OnboardingCubit>(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await context.read<OnboardingCubit>().complete();
    if (mounted) context.goNamed(RouteNames.nLogin);
  }

  void _next(OnboardingCubit cubit) {
    if (cubit.isLastPage) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<OnboardingCubit>();
    final pages = OnboardingCubit.pages;
    final index = cubit.state;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: EdgeInsets.only(right: AppSpacing.screenH, top: 8.h),
                child: TextButton(
                  onPressed: _finish,
                  child: Text(context.l10n.skip),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: cubit.onPageChanged,
                itemBuilder: (_, i) => OnboardingSlide(page: pages[i]),
              ),
            ),
            SizedBox(height: AppSpacing.vLg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: i == index ? 22.w : 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: i == index
                        ? context.colors.primary
                        : context.colors.outlineVariant,
                    borderRadius: AppRadius.rPill,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.screenH),
              child: AppButton(
                label: cubit.isLastPage
                    ? context.l10n.getStarted
                    : context.l10n.next,
                onPressed: () => _next(cubit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
