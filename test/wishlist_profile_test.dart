import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_kit/core/di/injection.dart';
import 'package:ui_kit/core/localization/l10n/app_localizations.dart';
import 'package:ui_kit/core/localization/locale_cubit.dart';
import 'package:ui_kit/core/theme/app_theme.dart';
import 'package:ui_kit/core/theme/theme_cubit.dart';
import 'package:ui_kit/features/product/domain/repositories/favorites_repository.dart';
import 'package:ui_kit/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:ui_kit/features/profile/presentation/pages/profile_page.dart';
import 'package:ui_kit/features/wishlist/presentation/pages/wishlist_page.dart';

/// Renders the new Wishlist and Profile screens at multiple viewport aspect
/// ratios (portrait phone, short-wide desktop, landscape phone) in both light
/// and dark themes, and asserts none overflow — targeting the RenderFlex bug
/// class that broke prior phases. Also exercises Wishlist removal and the
/// ProfileCubit logout flow against the real DI graph.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final secureStore = <String, String>{};
  late Directory hiveDir;

  setUpAll(() async {
    const channel =
        MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      final args = (call.arguments as Map?)?.cast<String, dynamic>() ?? {};
      final key = args['key'] as String?;
      switch (call.method) {
        case 'write':
          secureStore[key!] = args['value'] as String;
          return null;
        case 'read':
          return secureStore[key];
        case 'readAll':
          return Map<String, String>.from(secureStore);
        case 'delete':
          secureStore.remove(key);
          return null;
        case 'deleteAll':
          secureStore.clear();
          return null;
        case 'containsKey':
          return secureStore.containsKey(key);
        default:
          return null;
      }
    });

    hiveDir = await Directory.systemTemp.createTemp('hive_wishlist_test');
    Hive.init(hiveDir.path);
    SharedPreferences.setMockInitialValues({});
    await configureDependencies();
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
    await hiveDir.delete(recursive: true);
    await sl.reset();
  });

  Widget harness(Widget page, {ThemeMode themeMode = ThemeMode.light}) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: sl<LocaleCubit>()),
          BlocProvider.value(value: sl<ThemeCubit>()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          locale: const Locale('en'),
          supportedLocales: LocaleCubit.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: page,
        ),
      ),
    );
  }

  final sizes = <(String, Size)>[
    ('phone-portrait', const Size(375, 812)),
    ('desktop-short-wide', const Size(1280, 560)),
    ('landscape-phone', const Size(740, 360)),
  ];

  Future<void> clearFavorites() async {
    final ids = sl<FavoritesRepository>().getFavoriteIds().getOrElse((_) => {});
    for (final id in ids) {
      await sl<FavoritesRepository>().toggle(id);
    }
  }

  Future<void> seedFavorites() async {
    await clearFavorites();
    for (final id in ['p1', 'p3', 'p6', 'nike1', 'sh1']) {
      await sl<FavoritesRepository>().toggle(id);
    }
  }

  for (final (sizeName, size) in sizes) {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      final themeName = mode == ThemeMode.dark ? 'dark' : 'light';

      testWidgets('Wishlist (seeded) no overflow @ $sizeName/$themeName',
          (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await seedFavorites();
        await tester.pumpWidget(
          harness(const WishlistPage(), themeMode: mode),
        );
        await tester.pump(const Duration(milliseconds: 300));
        expect(tester.takeException(), isNull,
            reason: 'Wishlist grid overflowed at $sizeName/$themeName');
      });

      testWidgets('Wishlist (empty) no overflow @ $sizeName/$themeName',
          (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await clearFavorites();
        await tester.pumpWidget(
          harness(const WishlistPage(), themeMode: mode),
        );
        await tester.pump(const Duration(milliseconds: 300));
        expect(tester.takeException(), isNull,
            reason: 'Wishlist empty state overflowed at $sizeName/$themeName');
      });

      testWidgets('Profile no overflow @ $sizeName/$themeName',
          (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          harness(const ProfilePage(), themeMode: mode),
        );
        await tester.pump(const Duration(milliseconds: 300));
        expect(tester.takeException(), isNull,
            reason: 'Profile overflowed at $sizeName/$themeName');
      });
    }
  }

  testWidgets('Wishlist removal empties the list', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await clearFavorites();
    await sl<FavoritesRepository>().toggle('p1');

    await tester.pumpWidget(harness(const WishlistPage()));
    await tester.pump(const Duration(milliseconds: 300));

    // The seeded product renders.
    expect(find.text('Aero Runner Sneakers'), findsOneWidget);

    // Tap its favorite (heart) toggle to remove it.
    await tester.tap(find.byIcon(Icons.favorite_rounded).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Empty state now shows.
    expect(find.text('Your wishlist is empty'), findsOneWidget);
  });

  testWidgets('ProfileCubit logout emits loggedOut', (tester) async {
    final cubit = sl<ProfileCubit>();
    await cubit.loadUser();
    expect(cubit.state.status, ProfileStatus.loaded);

    await cubit.logout();
    expect(cubit.state.status, ProfileStatus.loggedOut);
    await cubit.close();
  });
}
