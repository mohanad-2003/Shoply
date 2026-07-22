import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_cubit.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/custom_bottom_sheet.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../core/widgets/settings_tile.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../cubit/profile_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>()..loadUser(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBarWidget(title: l10n.profile, showBack: false),
      body: SafeArea(
        child: BlocListener<ProfileCubit, ProfileState>(
          listenWhen: (prev, curr) =>
              prev.status != curr.status &&
              curr.status == ProfileStatus.loggedOut,
          listener: (context, state) => context.go(RouteNames.login),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state.status == ProfileStatus.initial ||
                  state.status == ProfileStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              return _ProfileContent(user: state.user);
            },
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.user});

  final UserEntity? user;

  void _stub(BuildContext context) =>
      AppSnackbar.show(context, message: context.l10n.comingSoon);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenH,
        vertical: AppSpacing.vLg,
      ),
      children: [
        _ProfileHeader(user: user),
        SizedBox(height: AppSpacing.vXl),
        _SectionLabel(label: l10n.account),
        SizedBox(height: AppSpacing.vSm),
        _TileGroup(
          children: [
            SettingsTile(
              icon: Icons.person_outline_rounded,
              title: l10n.editProfile,
              onTap: () => _stub(context),
            ),
            SettingsTile(
              icon: Icons.location_on_outlined,
              title: l10n.savedAddresses,
              onTap: () => _stub(context),
            ),
            SettingsTile(
              icon: Icons.credit_card_rounded,
              title: l10n.paymentMethods,
              onTap: () => _stub(context),
            ),
            SettingsTile(
              icon: Icons.shield_outlined,
              title: l10n.security,
              onTap: () => _stub(context),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.vXl),
        _SectionLabel(label: l10n.preferences),
        SizedBox(height: AppSpacing.vSm),
        _TileGroup(
          children: [
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, mode) {
                final isDark = mode == ThemeMode.dark ||
                    (mode == ThemeMode.system && context.isDark);
                return SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: l10n.darkMode,
                  trailing: Switch(
                    value: isDark,
                    onChanged: (v) => context.read<ThemeCubit>().setThemeMode(
                          v ? ThemeMode.dark : ThemeMode.light,
                        ),
                  ),
                );
              },
            ),
            BlocBuilder<LocaleCubit, Locale>(
              builder: (context, locale) {
                final isArabic = locale.languageCode == 'ar';
                return SettingsTile(
                  icon: Icons.translate_rounded,
                  title: l10n.language,
                  subtitle: isArabic ? l10n.arabic : l10n.english,
                  trailing: Text(
                    isArabic ? l10n.arabic : l10n.english,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                  onTap: () => context.read<LocaleCubit>().toggle(),
                );
              },
            ),
          ],
        ),
        SizedBox(height: AppSpacing.vXl),
        _TileGroup(
          children: [
            SettingsTile(
              icon: Icons.logout_rounded,
              title: l10n.logout,
              destructive: true,
              onTap: () => _confirmLogout(context),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.vXl),
      ],
    );
  }

  void _confirmLogout(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    final l10n = context.l10n;
    AppBottomSheet.show(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.logoutConfirmTitle,
            style: context.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.vMd),
          Text(
            l10n.logoutConfirmBody,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.vXl),
          AppButton(
            label: l10n.logout,
            icon: Icons.logout_rounded,
            onPressed: () {
              Navigator.of(context).pop();
              cubit.logout();
            },
          ),
          SizedBox(height: AppSpacing.vMd),
          AppButton(
            label: l10n.cancel,
            variant: AppButtonVariant.outline,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});

  final UserEntity? user;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = (user?.name.trim().isNotEmpty ?? false)
        ? user!.name
        : l10n.guest;
    final email = (user?.email.trim().isNotEmpty ?? false)
        ? user!.email
        : l10n.guestPrompt;
    final avatarUrl = user?.avatarUrl;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.vXl,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: AppRadius.rXl,
      ),
      child: Row(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            alignment: Alignment.center,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: context.colors.primary,
              shape: BoxShape.circle,
            ),
            child: (avatarUrl != null && avatarUrl.isNotEmpty)
                ? Image.network(
                    avatarUrl,
                    width: 64.w,
                    height: 64.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _InitialsLabel(
                      initials: _initials(name),
                    ),
                  )
                : _InitialsLabel(initials: _initials(name)),
          ),
          SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: context.textTheme.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSpacing.vXs),
                Text(
                  email,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InitialsLabel extends StatelessWidget {
  const _InitialsLabel({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Text(
      initials,
      style: context.textTheme.titleLarge?.copyWith(
        color: context.colors.onPrimary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: AppSpacing.sm),
      child: Text(
        label,
        style: context.textTheme.labelLarge?.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _TileGroup extends StatelessWidget {
  const _TileGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.rLg,
        border: Border.all(color: context.colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 1,
                indent: AppSpacing.lg,
                endIndent: AppSpacing.lg,
                color: context.colors.outlineVariant,
              ),
            children[i],
          ],
        ],
      ),
    );
  }
}
