import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:found_space_flutter_web_application/app_startup/environment_config.dart';
import 'package:found_space_flutter_web_application/di/app_component_interface.dart';
import 'package:found_space_flutter_web_application/main.dart' as app;
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:integration_test/integration_test.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'keys.dart';
import 'widget_test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  configure();
  AppComponentBase.setupAppComponentBase(EnvironmentConfig.flavor);

  group('Test Timer flow first to end', () {
    testWidgets('Tap on the timer tile', (tester) async {
      //GIVEN: Load app widget.
      await tester.pumpWidget(const app.FoundSpaceApp());
      // Wait for 20 seconds.
      await tester.pumpAndSettle(const Duration(seconds: 20));

      // WHEN: Tap on the Timer tile from bottom bar
      tapOnBottomMenu(tester, Key(WidgetKeys.timerTile));
      await tester.pump(const Duration(seconds: 5));

      // THEN : The "Timer" title should be displayed
      final findTimerPopupTitle = find.text(WidgetKeys.timerPopupTitle);
      expect(findTimerPopupTitle, findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('Increase and decrease timer from Radial gauge', (WidgetTester tester) async {
      // GIVEN: Load the app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));

      // WHEN: Tap on the Timer tile from the bottom bar to open the Timer control.
      tapOnBottomMenu(tester, Key(WidgetKeys.timerTile));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // THEN: The Timer control popup should be visible.
      final findTimerPopupTitle = find.text(WidgetKeys.timerPopupTitle);
      expect(findTimerPopupTitle, findsOneWidget);
      // GIVEN: The gauge is located and its center position is calculated.
      final gaugeFinder = find.byKey(const Key(WidgetKeys.timerGaugeIndicator));
      expect(gaugeFinder, findsOneWidget);

      final Offset gaugeCenter = tester.getCenter(gaugeFinder);
      // WHEN: The user drags the Timer slider to increase the Timer.
      const Offset increaseOffset = Offset(60, 20);
      for (int i = 0; i < 3; i++) {
        await tester.dragFrom(gaugeCenter, increaseOffset);
        await tester.pump(const Duration(seconds: 2));
        int currentTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));
      }

      // THEN: The Timer value should be increased to 65.

      int currentTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));
      //  expect(currentTimer, equals(65));

      // WHEN: The user drags the Timer slider to decrease the Timer.
      const Offset decreaseOffset = Offset(-60, 20);
      await tester.dragFrom(gaugeCenter, decreaseOffset);
      await tester.pumpAndSettle();

      // THEN: The Timer value should be decreased to 25.
      currentTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));
      // expect(currentTimer, equals(25));
    });

    testWidgets('Increase timer until it reaches 60', (WidgetTester tester) async {
      // GIVEN: Load the app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));

      // WHEN: Tap on the Timer tile from the bottom bar to open the Timer popup.
      // final findTimerTile = find.byKey(Key(WidgetKeys.timerTile));
      // expect(findTimerTile, findsOneWidget);
      // await tester.tap(findTimerTile);
      await tapOnBottomMenu(tester, Key(WidgetKeys.timerTile));
      await tester.pump(const Duration(seconds: 5));

      // THEN: The Timer control popup should be visible.
      // final findTimerPopupTitle = find.text(WidgetKeys.timerPopupTitle);
      // expect(findTimerPopupTitle, findsOneWidget);

      findWidgetLabeltByText(tester, WidgetKeys.timerPopupTitle);

      // GIVEN: Find the Plus button and the temperature display widget.
      final Finder plusButtonFinder = find.byKey(const Key(WidgetKeys.plusButton));

      // WHEN: Retrieve the current Timer value from the widget.
      int currentTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));

      // THEN: Keep tapping the Plus button until the temperature reaches 70.
      while (currentTimer < 60) {
        await tester.tap(plusButtonFinder);
        await tester.pumpAndSettle();
        currentTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));
        expect(currentTimer <= 60, isTrue);
      }
      expect(currentTimer, equals(60));
    });

    testWidgets('Timer should not exceed 60 when tapping the Plus button', (WidgetTester tester) async {
      // GIVEN: Load the app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));

      // WHEN: Tap on the Timer tile from the bottom bar to open the Timer popup.
      final findTimerTile = find.byKey(Key(WidgetKeys.timerTile));
      expect(findTimerTile, findsOneWidget);
      await tester.tap(findTimerTile);
      await tester.pump(const Duration(seconds: 5));

      // THEN: The Timer control popup should be visible.
      final findTimerPopupTitle = find.text(WidgetKeys.timerPopupTitle);
      expect(findTimerPopupTitle, findsOneWidget);

      // GIVEN: Find the Plus button and the temperature display widget.
      final Finder plusButtonFinder = find.byKey(const Key(WidgetKeys.plusButton));

      // WHEN: Retrieve the current temperature value from the widget.
      int currentTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));

      // THEN: If the current timer is less then 60, Keep tapping the Plus button until the timer reaches 60.
      while (currentTimer < 60) {
        await tester.tap(plusButtonFinder);
        await tester.pumpAndSettle();
        currentTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));
      }
      expect(currentTimer, equals(60));

      // WHEN: Tap the Plus button one more time when the timer is at 60.
      await tester.tap(plusButtonFinder);
      await tester.pumpAndSettle();

      // THEN: The timer should not increase above 60.
      currentTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));
      expect(currentTimer, isNot(61));
      expect(currentTimer, equals(60));
    });

    testWidgets('Timer should not decrease below 1 when tapping the Minus button', (WidgetTester tester) async {
      // GIVEN: Load the app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());

      await tester.pumpAndSettle(const Duration(seconds: 20));
      // WHEN: Tap on the Timer tile from the bottom bar to open the Timer popup.
      final findTimerTile = find.byKey(Key(WidgetKeys.timerTile));
      expect(findTimerTile, findsOneWidget);
      await tester.tap(findTimerTile);
      await tester.pump(const Duration(seconds: 5));

      // THEN: The Timer control popup should be visible.
      final findTimerPopupTitle = find.text(WidgetKeys.timerPopupTitle);
      expect(findTimerPopupTitle, findsOneWidget);

      // GIVEN: Find the Plus button and the Timer display widget.
      final Finder minusButtonFinder = find.byKey(const Key(WidgetKeys.minusButton));

      // WHEN: Retrieve the current Timer value from the widget.
      int currentTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));

      // THEN: If the current timer is above 1, reduce it to 1 by tapping the Minus button.
      while (currentTimer > 1) {
        await tester.tap(minusButtonFinder);
        await tester.pumpAndSettle();
        currentTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));
      }
      expect(currentTimer, equals(1));

      // WHEN: Tap the Minus button one more time when the timer is at 1.
      await tester.tap(minusButtonFinder);
      await tester.pumpAndSettle();

      // THEN: The temperature should not decrease below 1.
      currentTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));
      expect(currentTimer, isNot(0));
      expect(currentTimer, equals(1));
    });

    testWidgets('Verify the Timer on timer tile after updating', (WidgetTester tester) async {
      await tester.pumpWidget(const app.FoundSpaceApp());

      await tester.pumpAndSettle(const Duration(seconds: 20));

      // WHEN: Tap on the Timer tile from the bottom bar to open the Timer popup.
      final findTimerTile = find.byKey(Key(WidgetKeys.timerTile));
      expect(findTimerTile, findsOneWidget);
      await tester.tap(findTimerTile);
      await tester.pump(const Duration(seconds: 5));

      // THEN: The Timer control popup should be visible.
      final findTimerPopupTitle = find.text(WidgetKeys.timerPopupTitle);
      expect(findTimerPopupTitle, findsOneWidget);

      // GIVEN: Find the Plus and Minus buttons and the target Timer display widget.
      final Finder plusButtonFinder = find.byKey(const Key(WidgetKeys.plusButton));
      final Finder minusButtonFinder = find.byKey(const Key(WidgetKeys.minusButton));

      int initialTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));

      for (int i = 0; i < 5; i++) {
        await tester.tap(plusButtonFinder);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        int updatedTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));
        expect(updatedTimer, equals(initialTimer + i + 1));
      }
      for (int i = 0; i < 3; i++) {
        await tester.tap(minusButtonFinder);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        int updatedTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));
        expect(updatedTimer, equals(initialTimer + 5 - i - 1));
      }

      // THEN: Check the target Timer displayed in the Text widget.
      int newTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));
      int expectedTimer = initialTimer + 2;
      expect(newTimer, equals(expectedTimer));
    });

    testWidgets('Seesion timer should reduce after 1 min and after finish timer session the session should be finished',
        (WidgetTester tester) async {
      // GIVEN: Load the app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));

      // WHEN: Tap on the Timer tile from the bottom bar to open the Timer popup.
      final findTimerTile = find.byKey(Key(WidgetKeys.timerTile));
      expect(findTimerTile, findsOneWidget);
      await tester.tap(findTimerTile);
      await tester.pump(const Duration(seconds: 5));

      // THEN: The Timer control popup should be visible.
      final findTimerPopupTitle = find.text(WidgetKeys.timerPopupTitle);
      expect(findTimerPopupTitle, findsOneWidget);

      // GIVEN: Find the Plus button and the Timer display widget.
      final Finder minusButtonFinder = find.byKey(const Key(WidgetKeys.minusButton));

      // WHEN: Retrieve the current Timer value from the widget.
      int currentTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));

      // THEN: If the current timer is above 1, reduce it to 1 by tapping the Minus button.
      while (currentTimer > 2) {
        await tester.tap(minusButtonFinder);
        await tester.pumpAndSettle();
        currentTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));
      }
      expect(currentTimer, equals(2));

      // WHEN: Close the Timer popup by tapping the close button.
      final findPopupCloseButton = find.byKey(const Key(WidgetKeys.closeButtonPopup));
      expect(findPopupCloseButton, findsOneWidget);
      await tester.tap(findPopupCloseButton);
      await tester.pumpAndSettle();

      // THEN: Find the first visible subtitle text widget with the key 'subtitle_programTime'.
      final findVisibleSubtitleText = find.byKey(Key(WidgetKeys.targetSubTitleTimerText)).hitTestable();
      expect(findVisibleSubtitleText, findsOneWidget);

      // WHEN: Extract the text from the subtitle text widget.
      final subtitleWidget = tester.firstWidget<Text>(findVisibleSubtitleText);
      String? subtitleTextValue = subtitleWidget.data;

      // THEN: The subtitle text value should be available for use.
      String? minutesValue = subtitleTextValue?.replaceAll(RegExp(r'[^0-9]'), '');
      expect(minutesValue, isNotNull);
      expect(minutesValue, '2');

      // WHEN: Tap on the Start Heating button.
      Finder findStandByLabel = find.text(WidgetKeys.standByLabel);
      expect(findStandByLabel, findsOneWidget);

      final findStartHeatingButton = find.byKey(Key(WidgetKeys.startHeatingButton));
      expect(findStartHeatingButton, findsOneWidget);
      await tester.tap(findStartHeatingButton);

      // AND: Tap on the "Start Session Early" button.
      await tester.pump(const Duration(seconds: 5));
      final findStartSessionEarlyButton = find.byKey(const Key(WidgetKeys.startSessionEarlyButton));
      expect(findStartSessionEarlyButton, findsOneWidget);
      final findHeatingLabel = find.text(WidgetKeys.heatingLabel);
      expect(findHeatingLabel, findsOneWidget);
      await tester.tap(findStartSessionEarlyButton);
      await tester.pump(const Duration(minutes: 1));

      // THEN: The timer should decrease to 1 minute.
      final findSubtitleText = find.byKey(const Key('subtitle_programTime')).hitTestable();
      subtitleTextValue = tester.widget<Text>(findSubtitleText).data;
      minutesValue = subtitleTextValue?.replaceAll(RegExp(r'[^0-9]'), '');
      expect(minutesValue, '1');

      // WHEN: Wait for another minute to simulate the end of the session.
      await tester.pump(const Duration(minutes: 1));

      // Verify that the displayed time resets to 2 minutes.
      subtitleTextValue = tester.widget<Text>(findSubtitleText).data;
      minutesValue = subtitleTextValue?.replaceAll(RegExp(r'[^0-9]'), '');
      expect(minutesValue, '2');

      // GIVEN: The session has ended.
      // WHEN: Check for the Stand By label.
      await tester.pumpAndSettle(const Duration(seconds: 3));
      findStandByLabel = find.text(WidgetKeys.standByLabel);

      // THEN: The Stand By label should be visible.
      expect(findStandByLabel, findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('Reset the Program data after modified the timer', (WidgetTester tester) async {
      // GIVEN: Load the app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));

      // WHEN: Tap on the Timer tile from the bottom bar to open the Timer popup.
      final findTimerTile = find.byKey(Key(WidgetKeys.timerTile));
      expect(findTimerTile, findsOneWidget);
      await tester.tap(findTimerTile);
      await tester.pump(const Duration(seconds: 5));

      // THEN: The Timer control popup should be visible.
      final findTimerPopupTitle = find.text(WidgetKeys.timerPopupTitle);
      expect(findTimerPopupTitle, findsOneWidget);

      // GIVEN: Find the Plus button and the Timer display widget.
      final Finder plusButtonFinder = find.byKey(const Key(WidgetKeys.plusButton));

      // WHEN: Retrieve the current Timer value from the widget.
      int currentTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));

      // THEN: If the current timer is above 15, reduce it to 1 by tapping the Minus button.
      while (currentTimer < 15) {
        await tester.tap(plusButtonFinder);
        await tester.pumpAndSettle();

        currentTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));
      }
      expect(currentTimer, equals(15));

      // WHEN: Close the Timer popup by tapping the close button.
      final findPopupCloseButton = find.byKey(const Key(WidgetKeys.closeButtonPopup));
      expect(findPopupCloseButton, findsOneWidget);
      await tester.tap(findPopupCloseButton);
      await tester.pumpAndSettle();

      // THEN: Find the first visible subtitle text widget with the key 'subtitle_programTime'.
      await verifySubtitleTextValue(tester, WidgetKeys.targetSubTitleTimerText, '15');
      await tester.pump(const Duration(seconds: 3));

      final findProgramModifiedText = find.byKey(const Key(WidgetKeys.programModifiedText));
      expect(findProgramModifiedText, findsOneWidget);
      await tester.pump(const Duration(seconds: 3));

      // GIVEN: The reset button is present on the screen.
      final findProgramResetButton = find.byKey(const Key(WidgetKeys.buttonResetProgram));
      expect(findProgramResetButton, findsOneWidget);

      // WHEN: Tap the reset button to reset program data.
      await tester.tap(findProgramResetButton);
      await tester.pump(const Duration(seconds: 3));

      // THEN: Verify that the subtitle text widget with the key 'subtitle_programTime' is updated.
      final findVisibleSubtitleTextAfterReset = find.byKey(Key(WidgetKeys.targetSubTitleTimerText)).hitTestable();
      expect(findVisibleSubtitleTextAfterReset, findsOneWidget);

      // WHEN: Extract the text from the subtitle text widget after the reset.
      await verifySubtitleTextValue(tester, WidgetKeys.targetSubTitleTimerText, '20');
      await tester.pumpAndSettle();
    });

    testWidgets('Save the Program data after modified the timer', (WidgetTester tester) async {
      // GIVEN: Load the app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));

      // WHEN: Tap on the Timer tile from the bottom bar to open the Timer popup.
      final findTimerTile = find.byKey(Key(WidgetKeys.timerTile));
      expect(findTimerTile, findsOneWidget);
      await tester.tap(findTimerTile);
      await tester.pump(const Duration(seconds: 5));

      // THEN: The Timer control popup should be visible.
      final findTimerPopupTitle = find.text(WidgetKeys.timerPopupTitle);
      expect(findTimerPopupTitle, findsOneWidget);

      // GIVEN: Find the Plus button and the Timer display widget.
      final Finder minusButtonFinder = find.byKey(const Key(WidgetKeys.minusButton));

      // WHEN: Retrieve the current Timer value from the widget.

      int currentTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));
      // THEN: If the current timer is above 1, reduce it to 1 by tapping the Minus button.
      while (currentTimer > 15) {
        await tester.tap(minusButtonFinder);
        await tester.pumpAndSettle();

        currentTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));
      }
      expect(currentTimer, equals(15));

      // WHEN: Close the Timer popup by tapping the close button.
      final findPopupCloseButton = find.byKey(const Key(WidgetKeys.closeButtonPopup));
      expect(findPopupCloseButton, findsOneWidget);
      await tester.tap(findPopupCloseButton);
      await tester.pumpAndSettle();

      // THEN: Find the first visible subtitle text widget with the key 'subtitle_programTime'.
      await verifySubtitleTextValue(tester, WidgetKeys.targetSubTitleTimerText, '15');
      await tester.pump(const Duration(seconds: 3));

      final findProgramModifiedText = find.byKey(const Key(WidgetKeys.programModifiedText));
      expect(findProgramModifiedText, findsOneWidget);
      await tester.pump(const Duration(seconds: 3));

      // GIVEN: The Save button is present on the screen.
      final findProgramSaveButton = find.byKey(const Key(WidgetKeys.buttonSaveProgram));
      expect(findProgramSaveButton, findsOneWidget);

      // WHEN: Tap the Save button to reset program data.
      await tester.tap(findProgramSaveButton);
      await tester.pump(const Duration(seconds: 3));

      // THEN: Verify that the subtitle text widget with the key 'subtitle_programTime' is updated.
      await verifySubtitleTextValue(tester, WidgetKeys.targetSubTitleTimerText, '15');
      await tester.pumpAndSettle();
    });

    testWidgets('Reset the Program data after modified the timer and temperature', (WidgetTester tester) async {
      // GIVEN: Load the app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));

      // WHEN: Tap on the Temperature tile from the bottom bar to open the Temperature popup.
      await tapOnBottomMenu(tester, Key(WidgetKeys.temperatureTile));
      await tester.pump(const Duration(seconds: 5));

      // THEN: The Timer control popup should be visible.
      final findTemperaturePopupTitle = find.text(WidgetKeys.temperaturePopupTitle);
      expect(findTemperaturePopupTitle, findsOneWidget);

      // GIVEN: Find the Plus button and the Temperature display widget.
      final Finder minusTimerButtonFinder = find.byKey(const Key(WidgetKeys.minusButton));

      // WHEN: Retrieve the current Temperature value from the widget.

      int currentTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValue));
      while (currentTemperature > 40) {
        await tester.tap(minusTimerButtonFinder);
        await tester.pumpAndSettle();
        currentTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValue));
      }
      expect(currentTemperature, equals(40));

      // WHEN: Close the Temperature popup by tapping the close button.
      await tapOnCloseButton(tester, const Key(WidgetKeys.closeButtonPopup));
      await tester.pumpAndSettle();

      // THEN: Find the first visible subtitle text widget with the key 'subtitle_programTemperature'.
      await verifySubtitleTextValue(tester, WidgetKeys.targetSubTitleTemperatureText, '40');
      await tester.pump(const Duration(seconds: 3));

      // WHEN: Tap on the Timer tile from the bottom bar to open the Timer popup.
      await tapOnBottomMenu(tester, Key(WidgetKeys.timerTile));
      await tester.pump(const Duration(seconds: 5));

      // THEN: The Timer control popup should be visible.
      final findTimerPopupTitle = find.text(WidgetKeys.timerPopupTitle);
      expect(findTimerPopupTitle, findsOneWidget);

      // WHEN: Retrieve the current Timer value from the widget.
      int currentTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));
      while (currentTimer > 15) {
        await tester.tap(minusTimerButtonFinder);
        await tester.pumpAndSettle();

        currentTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));
      }
      expect(currentTimer, equals(15));

      // WHEN: Close the Timer popup by tapping the close button.
      await tapOnCloseButton(tester, const Key(WidgetKeys.closeButtonPopup));
      await tester.pumpAndSettle();

      // THEN: Find the first visible subtitle text widget with the key 'subtitle_programTime'.
      await verifySubtitleTextValue(tester, WidgetKeys.targetSubTitleTimerText, '15');
      await tester.pump(const Duration(seconds: 3));

      final findProgramModifiedText = find.byKey(const Key(WidgetKeys.programModifiedText));
      expect(findProgramModifiedText, findsOneWidget);
      await tester.pump(const Duration(seconds: 3));

      // GIVEN: The reset button is present on the screen.
      final findProgramResetButton = find.byKey(const Key(WidgetKeys.buttonResetProgram));
      expect(findProgramResetButton, findsOneWidget);

      // WHEN: Tap the reset button to reset program data.
      await tester.tap(findProgramResetButton);
      await tester.pump(const Duration(seconds: 3));

      // THEN: Verify that the subtitle text widget with the key 'subtitle_programTime' is updated.
      final findVisibleSubtitleTextAfterReset = find.byKey(Key(WidgetKeys.targetSubTitleTimerText)).hitTestable();
      expect(findVisibleSubtitleTextAfterReset, findsOneWidget);

      // WHEN: Extract the text from the subtitle text widget after the reset.
      await verifySubtitleTextValue(tester, WidgetKeys.targetSubTitleTemperatureText, '45');
      await verifySubtitleTextValue(tester, WidgetKeys.targetSubTitleTimerText, '20');
      await tester.pumpAndSettle();
    });

    testWidgets('Save the Program data after modified the timer and temperature', (WidgetTester tester) async {
      // GIVEN: Load the app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));
      // WHEN: Tap on the Temperature tile from the bottom bar to open the Temperature popup.
      await tapOnBottomMenu(tester, Key(WidgetKeys.temperatureTile));
      await tester.pump(const Duration(seconds: 5));

      // THEN: The Temperature control popup should be visible.
      final findTemperaturePopupTitle = find.text(WidgetKeys.temperaturePopupTitle);
      expect(findTemperaturePopupTitle, findsOneWidget);

      // GIVEN: Find the Plus button and the Temperature display widget.
      final Finder minusTempratureButtonFinder = find.byKey(const Key(WidgetKeys.minusButton));

      // WHEN: Retrieve the current Temperature value from the widget.

      int currentTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValue));
      while (currentTemperature > 40) {
        await tester.tap(minusTempratureButtonFinder);
        await tester.pumpAndSettle();
        currentTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValue));
      }
      expect(currentTemperature, equals(40));

      // WHEN: Close the Temperature popup by tapping the close button.
      await tapOnCloseButton(tester, const Key(WidgetKeys.closeButtonPopup));
      await tester.pumpAndSettle();

      // THEN: Find the first visible subtitle text widget with the key 'subtitle_programTemperature'.
      await verifySubtitleTextValue(tester, WidgetKeys.targetSubTitleTemperatureText, '40');
      await tester.pump(const Duration(seconds: 3));

      // WHEN: Tap on the Timer tile from the bottom bar to open the Timer popup.
      await tapOnBottomMenu(tester, Key(WidgetKeys.timerTile));
      await tester.pump(const Duration(seconds: 5));

      // THEN: The Timer control popup should be visible.
      final findTimerPopupTitle = find.text(WidgetKeys.timerPopupTitle);
      expect(findTimerPopupTitle, findsOneWidget);

      // GIVEN: Find the Plus button and the Timer display widget.
      final Finder minusTimerButtonFinder = find.byKey(const Key(WidgetKeys.minusButton));

      // WHEN: Retrieve the current Timer value from the widget.

      int currentTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));
      // THEN: If the current timer is above 1, reduce it to 1 by tapping the Minus button.
      while (currentTimer > 15) {
        await tester.tap(minusTimerButtonFinder);
        await tester.pumpAndSettle();

        currentTimer = getTimerValueFromRichTextWidget(tester, const Key(WidgetKeys.timerValue));
      }
      expect(currentTimer, equals(15));

      // WHEN: Close the Timer popup by tapping the close button.
      await tapOnCloseButton(tester, const Key(WidgetKeys.closeButtonPopup));
      await tester.pumpAndSettle();

      // THEN: Find the first visible subtitle text widget with the key 'subtitle_programTime'.
      await verifySubtitleTextValue(tester, WidgetKeys.targetSubTitleTimerText, '15');
      await tester.pump(const Duration(seconds: 3));

      final findProgramModifiedText = find.byKey(const Key(WidgetKeys.programModifiedText));
      expect(findProgramModifiedText, findsOneWidget);
      await tester.pump(const Duration(seconds: 3));

      // GIVEN: The reset button is present on the screen.
      final findProgramSaveButton = find.byKey(const Key(WidgetKeys.buttonSaveProgram));
      expect(findProgramSaveButton, findsOneWidget);

      // WHEN: Tap the reset button to reset program data.
      await tester.tap(findProgramSaveButton);
      await tester.pump(const Duration(seconds: 3));

      // THEN: Verify that the subtitle text widget with the key 'subtitle_programTime' is updated.
      final findVisibleSubtitleTextAfterSave = find.byKey(Key(WidgetKeys.targetSubTitleTimerText)).hitTestable();
      expect(findVisibleSubtitleTextAfterSave, findsOneWidget);

      // WHEN: Extract the text from the subtitle text widget after the reset.
      await verifySubtitleTextValue(tester, WidgetKeys.targetSubTitleTemperatureText, '40');
      await verifySubtitleTextValue(tester, WidgetKeys.targetSubTitleTimerText, '15');
      await tester.pumpAndSettle();
    });
  });
}
