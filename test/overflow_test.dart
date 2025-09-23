import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'package:daily_quest_helper/main_hub_screen.dart';
import 'package:daily_quest_helper/home_screen.dart';
import 'package:daily_quest_helper/weekly_screens.dart';
import 'package:daily_quest_helper/streak_screens.dart';
import 'package:daily_quest_helper/widgets.dart';
import 'package:daily_quest_helper/models.dart';
import 'package:daily_quest_helper/constants.dart';

class _FakePathProvider extends PathProviderPlatform {
  @override
  Future<String?> getApplicationSupportPath() async {
    return '.'; // use project root for tests
  }
}

const List<Size> _testSizes = <Size>[
  //Error cases
  Size(732, 412),
  Size(740, 360),
  Size(745, 353),
  Size(720, 540),
  Size(731, 411),

  // Legacy/low-res phones (landscape)
  Size(800, 480), // WVGA
  Size(854, 480), // FWVGA
  Size(960, 540), // qHD
  Size(658, 320), // S9+
  // 7" tablets and small tablets (landscape)
  Size(1024, 600), // WSVGA
  Size(1280, 720), // HD
  Size(1280, 800), // WXGA (7-8" tablets)
  // Common laptop-like aspect used by some tablets
  Size(1366, 768),

  // HD+ tall phones in landscape
  Size(1440, 720), // 18:9
  Size(1520, 720), // 19:9 variants
  Size(1600, 720), // 20:9 variants
  // Full HD phones (landscape)
  Size(1920, 1080), // FHD 16:9
  Size(2160, 1080), // 18:9 FHD+
  Size(2220, 1080), // Galaxy S8 class
  Size(2240, 1080), // 19:9
  Size(2280, 1080), // 19:9
  Size(2310, 1080), // 19.5:9
  Size(2340, 1080), // 19.5:9
  Size(2400, 1080), // 20:9
  // QHD / QHD+ class (landscape)
  Size(2560, 1440), // QHD 16:9
  Size(3200, 1440), // QHD 16:9
  Size(3840, 2160), // 4K UHD
  Size(2960, 1440), // 18.5:9
  Size(3040, 1440), // 19:9
  Size(3120, 1440), // 19.5:9
  // Tablets common (landscape)
  Size(1920, 1200), // WUXGA 10.1"
  Size(2000, 1200), // 10.95" class (modern Android tablets)
  Size(2560, 1600), // WQXGA 10.1-10.5"
  // Foldables (inner displays, landscape)
  Size(2208, 1768), // Galaxy Z Fold (inner)
  Size(2176, 1812), // Galaxy Z Fold5 (inner)
  Size(2208, 1840), // Pixel Fold (inner)
  // Ultra-wide/taller modern phones in landscape
  Size(2460, 1080),
  Size(2640, 1080),
  Size(3088, 1440),
];

Widget _wrap(Widget child) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: colorBackground,
      colorScheme: ColorScheme.fromSeed(seedColor: colorAccent),
      textTheme: const TextTheme(bodyMedium: TextStyle(color: colorText)),
    ),
    home: child,
  );
}

Future<void> _pumpWithViewport(
  WidgetTester tester,
  Widget child,
  Size size,
) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  await tester.pumpWidget(_wrap(child));
  await tester.pumpAndSettle(const Duration(milliseconds: 200));
  // Small delay to ensure proper widget lifecycle
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // Mock path provider so Drift native opens a file under tests
    PathProviderPlatform.instance = _FakePathProvider();
  });

  group('No bottom overflow on screens', () {
    late void Function(FlutterErrorDetails)? oldOnError;
    late List<FlutterErrorDetails> capturedErrors;

    setUp(() {
      capturedErrors = <FlutterErrorDetails>[];
      oldOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        // Filter out widget inspector errors that are side effects of overflow
        final String message = details.exceptionAsString();
        if (!message.contains('Looking up a deactivated widget\'s ancestor') &&
            !message.contains('widget\'s element tree is no longer stable')) {
          capturedErrors.add(details);
        }
      };
    });

    tearDown(() {
      FlutterError.onError = oldOnError;
    });

    Future<void> expectNoOverflow(WidgetTester tester) async {
      await tester.pump();
      final List<FlutterErrorDetails> overflowErrors = capturedErrors.where((e) {
        final String message = e.exceptionAsString();
        return message.contains('A RenderFlex overflowed by') ||
            message.contains('RenderFlex overflowed by') ||
            message.contains('Bottom overflowed') ||
            message.contains('overflowed');
      }).toList();

      if (overflowErrors.isNotEmpty) {
        final String errorMessage = overflowErrors.first.exceptionAsString();
        throw Exception('Overflow detected: $errorMessage');
      }
    }

    testWidgets('MainHubScreen', (tester) async {
      for (final Size s in _testSizes) {
        capturedErrors.clear();
        await _pumpWithViewport(tester, const MainHubScreen(), s);
        await expectNoOverflow(tester);
      }
    });

    testWidgets('HomeScreen', (tester) async {
      for (final Size s in _testSizes) {
        capturedErrors.clear();
        await _pumpWithViewport(tester, const HomeScreen(), s);
        await expectNoOverflow(tester);
      }
    });

    testWidgets('WeeklyHomeScreen', (tester) async {
      for (final Size s in _testSizes) {
        capturedErrors.clear();
        await _pumpWithViewport(tester, const WeeklyHomeScreen(), s);
        await expectNoOverflow(tester);
      }
    });

    testWidgets('StreakHomeScreen', (tester) async {
      for (final Size s in _testSizes) {
        capturedErrors.clear();
        await _pumpWithViewport(tester, const StreakHomeScreen(), s);
        await expectNoOverflow(tester);
      }
    });

    testWidgets('StreakRegisterScreen', (tester) async {
      for (final Size s in _testSizes) {
        capturedErrors.clear();
        await _pumpWithViewport(tester, const StreakRegisterScreen(), s);
        await expectNoOverflow(tester);
      }
    });

    testWidgets('ProfileScreen', (tester) async {
      for (final Size s in _testSizes) {
        capturedErrors.clear();
        await _pumpWithViewport(tester, const ProfileScreen(), s);
        await expectNoOverflow(tester);
      }
    });

    testWidgets('RegisterQuestScreen', (tester) async {
      for (final Size s in _testSizes) {
        capturedErrors.clear();
        await _pumpWithViewport(tester, const RegisterQuestScreen(), s);
        await expectNoOverflow(tester);
      }
    });

    testWidgets('EditQuestScreen minimal', (tester) async {
      const Quest quest = Quest(
        id: 1,
        title: 'Edit me',
        progress: 0,
        target: 1,
        status: QuestStatus.incomplete,
        iconUrl: null,
        rewardUrl: null,
      );
      for (final Size s in _testSizes) {
        capturedErrors.clear();
        await _pumpWithViewport(tester, EditQuestScreen(quest: quest), s);
        await expectNoOverflow(tester);
      }
    });
  });

  group('No bottom overflow on dialogs', () {
    testWidgets('DeleteConfirmDialog', (tester) async {
      for (final Size s in _testSizes) {
        await _pumpWithViewport(
          tester,
          Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => DeleteConfirmDialog(
                      title: '정말 삭제?',
                      onCancel: () {},
                      onConfirm: () {},
                    ),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
          s,
        );
        final openBtn = find.widgetWithText(ElevatedButton, 'Open');
        await tester.ensureVisible(openBtn);
        await tester.pump();
        await tester.tap(openBtn, warnIfMissed: false);
        await tester.pumpAndSettle();
        expect(find.byType(DeleteConfirmDialog), findsOneWidget);
        // Close the dialog to clean up
        await tester.tap(find.text('취소'), warnIfMissed: false);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('BadgeAwardDialog', (tester) async {
      for (final Size s in _testSizes) {
        await _pumpWithViewport(
          tester,
          Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => BadgeAwardDialog(
                      title: '배지 획득!',
                      child: const SizedBox(height: 120, width: 120),
                      onClose: () {},
                    ),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
          s,
        );
        final openBtn = find.widgetWithText(ElevatedButton, 'Open');
        await tester.ensureVisible(openBtn);
        await tester.pump();
        await tester.tap(openBtn, warnIfMissed: false);
        await tester.pumpAndSettle();
        expect(find.byType(BadgeAwardDialog), findsOneWidget);
        // Close the dialog to clean up
        await tester.tapAt(const Offset(50, 50));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('ItemAwardDialog', (tester) async {
      for (final Size s in _testSizes) {
        await _pumpWithViewport(
          tester,
          Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => ItemAwardDialog(
                      itemId: 1,
                      itemKey: 'star',
                      onClose: () {},
                    ),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
          s,
        );
        final openBtn = find.widgetWithText(ElevatedButton, 'Open');
        await tester.ensureVisible(openBtn);
        await tester.pump();
        await tester.tap(openBtn, warnIfMissed: false);
        await tester.pumpAndSettle();
        expect(find.byType(ItemAwardDialog), findsOneWidget);
        // Close the dialog to clean up
        await tester.tapAt(const Offset(50, 50));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('RewardDialog', (tester) async {
      for (final Size s in _testSizes) {
        await _pumpWithViewport(
          tester,
          Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => const RewardDialog(
                      reward: RewardInfo(questName: 'Q', imageUrl: ''),
                      onClaim: _noop,
                    ),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
          s,
        );
        final openBtn = find.widgetWithText(ElevatedButton, 'Open');
        await tester.ensureVisible(openBtn);
        await tester.pump();
        await tester.tap(openBtn, warnIfMissed: false);
        await tester.pumpAndSettle();
        expect(find.byType(RewardDialog), findsOneWidget);
        // Close the dialog to clean up
        await tester.tapAt(const Offset(50, 50));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('LoadingScreen', (tester) async {
      for (final Size s in _testSizes) {
        await _pumpWithViewport(
          tester,
          const LoadingScreen(message: '로딩 중...'),
          s,
        );
        expect(find.text('로딩 중...'), findsOneWidget);
      }
    });
  });
}

void _noop() {}
