import 'dart:async';

import 'package:daily_quest_helper/main.dart' as app;
import 'package:daily_quest_helper/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late void Function(FlutterErrorDetails)? oldOnError;
  late List<FlutterErrorDetails> capturedErrors;

  setUp(() {
    capturedErrors = <FlutterErrorDetails>[];
    oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      capturedErrors.add(details);
    };
  });

  tearDown(() {
    FlutterError.onError = oldOnError;
  });

  Future<void> expectNoOverflow(WidgetTester tester) async {
    await tester.pump();
    final bool hasOverflow = capturedErrors.any((e) {
      final String message = e.exceptionAsString();
      return message.contains('A RenderFlex overflowed by') ||
          message.contains('RenderFlex overflowed by') ||
          message.contains('Bottom overflowed') ||
          message.contains('overflowed');
    });
    if (hasOverflow) {
      throw capturedErrors.first.exception;
    }
  }

  const List<Size> testSizes = <Size>[
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

  Future<void> setSurface(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Future<void> settle(
    WidgetTester tester, {
    int maxPumps = 40,
    Duration step = const Duration(milliseconds: 100),
  }) async {
    for (int i = 0; i < maxPumps; i++) {
      await tester.pump(step);
    }
  }

  Future<void> maybePopRoute(WidgetTester tester) async {
    final Finder nav = find.byType(Navigator);
    if (nav.evaluate().isNotEmpty) {
      final BuildContext navContext = tester.element(nav.first);
      await Navigator.of(navContext).maybePop();
      await settle(tester);
    }
  }

  Future<void> safeTap(WidgetTester tester, Finder finder) async {
    if (finder.evaluate().isEmpty) return;
    final Finder target = finder.first;
    await tester.ensureVisible(target);
    await tester.tap(target, warnIfMissed: false);
    await settle(tester);
  }

  // intentionally removed: replaced by registerMultipleQuests

  Future<void> registerMultipleQuests(WidgetTester tester, int count) async {
    for (int i = 0; i < count; i++) {
      final Finder fab = find.byType(FloatingActionButton);
      if (fab.evaluate().isEmpty) return;
      await safeTap(tester, fab);

      final Finder fields = find.byType(TextFormField);
      if (fields.evaluate().length >= 2) {
        await tester.enterText(fields.at(0), '?먮룞 ?깅줉 ${i + 1}');
        await tester.enterText(fields.at(1), '1');
        await settle(tester);
      }
      final Finder submitButton = find.widgetWithText(ElevatedButton, '?깅줉');
      if (submitButton.evaluate().isNotEmpty) {
        await safeTap(tester, submitButton);
      }
    }
  }

  // intentionally removed: replaced by completeNQuestsAndHandleRewards

  Future<void> completeNQuestsAndHandleRewards(
    WidgetTester tester,
    int count,
  ) async {
    int completed = 0;

    Future<bool> tapActionInTarget(Finder target) async {
      if (target.evaluate().isEmpty) return false;
      final Finder action = find.descendant(
        of: target.first,
        matching: find.byType(InkWell),
      );
      if (action.evaluate().isEmpty) return false;
      await safeTap(tester, action);
      return true;
    }

    // Prefer QuestCard (grid) then fallback to QuestItem (list)
    Finder cards = find.byType(QuestCard);
    Finder items = find.byType(QuestItem);

    int index = 0;
    while (completed < count) {
      Finder target;
      if (cards.evaluate().isNotEmpty && index < cards.evaluate().length) {
        target = cards.at(index);
      } else if (items.evaluate().isNotEmpty &&
          index < items.evaluate().length) {
        target = items.at(index);
      } else {
        // No more visible targets; try to refresh finders
        cards = find.byType(QuestCard);
        items = find.byType(QuestItem);
        if (index >= cards.evaluate().length &&
            index >= items.evaluate().length) {
          break;
        }
        target = (cards.evaluate().length > index)
            ? cards.at(index)
            : items.at(index);
      }

      final bool tapped = await tapActionInTarget(target);
      if (!tapped) {
        index++;
        continue;
      }

      // RewardDialog -> Claim
      if (find.byType(RewardDialog).evaluate().isNotEmpty) {
        final Finder claim = find.text('Claim');
        if (claim.evaluate().isNotEmpty) {
          await safeTap(tester, claim);
        }
      }

      // Any subsequent ItemAward/BadgeAward -> ?뺤씤
      final Finder ok = find.text('확인');
      if (ok.evaluate().isNotEmpty) {
        await safeTap(tester, ok);
      }

      await expectNoOverflow(tester);
      completed++;
      index++;
    }
  }

  testWidgets('No bottom overflow during typical interactions', (tester) async {
    for (final size in testSizes) {
      capturedErrors.clear();
      await setSurface(tester, size);

      app.main();
      await settle(tester);

      // MainHubScreen basic check
      await expectNoOverflow(tester);

      // Tap Daily tile to go to HomeScreen
      final Finder daily = find.text('일일 임무');
      if (daily.evaluate().isNotEmpty) {
        await safeTap(tester, daily);
        await expectNoOverflow(tester);
        // Register 5 daily quests (target 1) then complete 5 to trigger daily5 badge
        await registerMultipleQuests(tester, 5);
        await settle(tester);
        await expectNoOverflow(tester);
        await completeNQuestsAndHandleRewards(tester, 5);
        if (find.byType(BadgeAwardDialog).evaluate().isNotEmpty) {
          await expectNoOverflow(tester);
          final Finder ok = find.text('확인');
          if (ok.evaluate().isNotEmpty) {
            await safeTap(tester, ok);
          }
        }
        await expectNoOverflow(tester);
      }

      // Back to hub
      if (find.byIcon(Icons.home).evaluate().isNotEmpty) {
        await safeTap(tester, find.byIcon(Icons.home));
      } else {
        await maybePopRoute(tester);
      }
      await expectNoOverflow(tester);

      // Go to Weekly screen
      final Finder weekly = find.text('주간 임무');
      if (weekly.evaluate().isNotEmpty) {
        await safeTap(tester, weekly);
        await expectNoOverflow(tester);
        // Register 3 weekly quests (target 1) then complete 3 to trigger weekly3 badge
        await registerMultipleQuests(tester, 3);
        await settle(tester);
        await expectNoOverflow(tester);
        await completeNQuestsAndHandleRewards(tester, 3);
        // BadgeAwardDialog may appear; validate and close if present
        if (find.byType(BadgeAwardDialog).evaluate().isNotEmpty) {
          await expectNoOverflow(tester);
          final Finder ok = find.text('확인');
          if (ok.evaluate().isNotEmpty) {
            await safeTap(tester, ok);
          }
        }
        await expectNoOverflow(tester);
        await maybePopRoute(tester);
      }

      // Go to Streak screen
      final Finder streak = find.text('연속 임무');
      if (streak.evaluate().isNotEmpty) {
        await safeTap(tester, streak);
        await expectNoOverflow(tester);
        // Register 1 streak quest then complete 1 to trigger streak1 badge
        await registerMultipleQuests(tester, 1);
        await settle(tester);
        await expectNoOverflow(tester);
        await completeNQuestsAndHandleRewards(tester, 1);
        if (find.byType(BadgeAwardDialog).evaluate().isNotEmpty) {
          await expectNoOverflow(tester);
          final Finder ok = find.text('확인');
          if (ok.evaluate().isNotEmpty) {
            await safeTap(tester, ok);
          }
        }
        await expectNoOverflow(tester);
        await maybePopRoute(tester);
      }

      // Open corner decoration sticker panel and close
      final Finder corner = find.byType(CornerDecoration);
      if (corner.evaluate().isNotEmpty) {
        await safeTap(tester, corner);
        await expectNoOverflow(tester);
        final Finder close = find.text('닫기');
        if (close.evaluate().isNotEmpty) {
          await safeTap(tester, close);
          await expectNoOverflow(tester);
        }
      }

      // Open top-right profile badge to ProfileScreen, then back
      final Finder profileBadge = find.byType(TopRightCharacterBadge);
      if (profileBadge.evaluate().isNotEmpty) {
        await safeTap(tester, profileBadge);
        await expectNoOverflow(tester);
        await maybePopRoute(tester);
      }

      // Open a dialog by pushing a minimal RewardDialog via overlay
      // (simulate showing any dialog to verify no overflow)
      // Use Navigator context when available; fallback to any Scaffold
      BuildContext dialogHostContext;
      final Finder navFinder = find.byType(Navigator);
      if (navFinder.evaluate().isNotEmpty) {
        dialogHostContext = tester.element(navFinder.first);
      } else {
        dialogHostContext = tester.element(find.byType(Scaffold).first);
      }
      unawaited(
        showDialog<void>(
          context: dialogHostContext,
          builder: (dialogContext) => AlertDialog(
            content: const Text('Test Dialog'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('?類ㅼ뵥'),
              ),
            ],
          ),
        ),
      );
      await settle(tester);
      await expectNoOverflow(tester);
      if (find.text('?類ㅼ뵥').evaluate().isNotEmpty) {
        await safeTap(tester, find.text('확인'));
        await expectNoOverflow(tester);
      }
    }
  });
}
