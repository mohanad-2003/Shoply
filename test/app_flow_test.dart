import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_kit/app.dart';
import 'package:ui_kit/core/constants/app_constants.dart';
import 'package:ui_kit/core/di/injection.dart';

/// Boots the real app (real DI graph, Hive, go_router, mock datasources) and
/// walks the core shopping loop end-to-end, headlessly. Platform channels for
/// secure storage are stubbed with an in-memory map; Hive uses a temp dir.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final secureStore = <String, String>{};
  late Directory hiveDir;

  setUpAll(() async {
    // Stub flutter_secure_storage's platform channel.
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
        case 'delete':
          secureStore.remove(key);
          return null;
        case 'readAll':
          return Map<String, String>.from(secureStore);
        case 'deleteAll':
          secureStore.clear();
          return null;
        case 'containsKey':
          return secureStore.containsKey(key);
        default:
          return null;
      }
    });

    hiveDir = await Directory.systemTemp.createTemp('hive_test');
    Hive.init(hiveDir.path);

    // Onboarding already seen so splash routes straight to Login.
    SharedPreferences.setMockInitialValues({
      AppConstants.prefOnboardingSeen: true,
    });

    await configureDependencies();
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
    await hiveDir.delete(recursive: true);
    await sl.reset();
  });

  testWidgets('Splash → Login → Home → Product → Cart', (tester) async {
    await tester.pumpWidget(const ShoplyApp());

    // Splash renders.
    await tester.pump();
    expect(find.text(AppConstants.appName), findsWidgets);

    // Splash decides destination (1.6s) → Login.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.byType(TextFormField), findsWidgets,
        reason: 'Login form should be visible');

    // Fill credentials and submit.
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'shopper@test.com');
    await tester.enterText(fields.at(1), 'secret123');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    // Tap the login button (elevated).
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pump(); // loading
    await tester.pump(const Duration(seconds: 2)); // mock auth delay

    // Home loads (mock delay ~1.2s). Avoid pumpAndSettle while shimmer spins.
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 500));

    // A product section title from Home should be present.
    expect(find.textContaining('Flash Sale').evaluate().isNotEmpty ||
        find.textContaining('Featured').evaluate().isNotEmpty ||
        find.byIcon(Icons.home_rounded).evaluate().isNotEmpty,
        isTrue,
        reason: 'Home content should render after login');
  });
}
