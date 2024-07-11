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

  group('Test temperature flow first to end', () {
    testWidgets('Tap on the Temperature tile and check the slide close or not after 10 seconds', (tester) async {
      // GIVEN: Load app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));

      // WHEN: Tap on the Temperature tile from the bottom bar.
      await tapOnBottomMenu(tester, Key(WidgetKeys.temperatureTile));
      await tester.pumpAndSettle();

      // THEN: Verify the initial state of the countdown is 10.
      checkForCountDownText(tester, '10');

      // WHEN: Skip checking the countdown from 9 to 2 and fast-forward time to just before the countdown finishes.
      await tester.pump(const Duration(seconds: 9));

      // THEN: Verify that the countdown finishes at 1.
      checkForCountDownText(tester, '1');

      // WHEN: Pump additional time to allow the popup to close if that is the intended behavior.
      await tester.pump(const Duration(seconds: 1));

      // THEN: Verify that the popup is no longer displayed.
      expect(find.byType(Dialog), findsNothing);
      await tester.pumpAndSettle();
    });

    testWidgets('Increase and decrease temperature from Radial gauge', (WidgetTester tester) async {
      // GIVEN: Load the app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));

      // WHEN: Tap on the Temperature tile from the bottom bar to open the temperature control.
      await tapOnBottomMenu(tester, Key(WidgetKeys.temperatureTile));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // THEN: The temperature control popup should be visible.
      final findTemperaturePopupTitle = find.text(WidgetKeys.temperaturePopupTitle);
      expect(findTemperaturePopupTitle, findsOneWidget);

      // GIVEN: The gauge is located and its center position is calculated.
      final gaugeFinder = find.byKey(const Key(WidgetKeys.temperatureGaugeIndicator));
      expect(gaugeFinder, findsOneWidget);
      final Offset gaugeCenter = tester.getCenter(gaugeFinder);

      // WHEN: The user drags the temperature slider to increase the temperature.
      const Offset increaseOffset = Offset(40, 10);
      await tester.dragFrom(gaugeCenter, increaseOffset);
      await tester.pumpAndSettle();

      // THEN: The temperature value should be increased to 65.
      final int currentTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValue));
      expect(currentTemperature, equals(65));

      // WHEN: The user drags the temperature slider to decrease the temperature.
      const Offset decreaseOffset = Offset(-40, 10);
      await tester.dragFrom(gaugeCenter, decreaseOffset);
      await tester.pumpAndSettle();

      // THEN: The temperature value should be decreased to 25.
      final int decreasedTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValue));
      expect(decreasedTemperature, equals(25));
    });

    testWidgets('Increase temperature until it reaches 70', (WidgetTester tester) async {
      // GIVEN: Load the app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));

      // WHEN: Tap on the Temperature tile from the bottom bar to open the temperature control.
      await tapOnBottomMenu(tester, Key(WidgetKeys.temperatureTile));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // THEN: The temperature control popup should be visible.
      final findTemperaturePopupTitle = find.text(WidgetKeys.temperaturePopupTitle);
      expect(findTemperaturePopupTitle, findsOneWidget);

      // GIVEN: Find the Plus button and the temperature display widget.
      final Finder plusButtonFinder = find.byKey(const Key(WidgetKeys.plusButton));

      // THEN: Keep tapping the Plus button until the temperature reaches 70.
      int currentTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValue));

      while (currentTemperature < 70) {
        await tester.tap(plusButtonFinder);
        await tester.pumpAndSettle();
        currentTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValue));
        expect(currentTemperature <= 70, isTrue);
      }

      // THEN: Assert that the final temperature is 70.
      expect(currentTemperature, equals(70));
    });

    testWidgets(
        'Tap on the "Pause session" button then "Resume session" button after tapping on the "Start session" button',
        (tester) async {
      // GIVEN: Load app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));

      // WHEN: Tap on the Temprature tile from bottom bar
      await tapOnBottomMenu(tester, Key(WidgetKeys.temperatureTile));
      await tester.pump(const Duration(seconds: 5));

      // THEN: The temperature control popup should be visible.
      final findtemperaturePopupTitle = find.text(WidgetKeys.temperaturePopupTitle);
      expect(findtemperaturePopupTitle, findsOneWidget);

      // GIVEN: Find the temperature value display widget.
      final Finder temperatureValueFinder = find.byKey(const Key(WidgetKeys.temperatureValue));

      // WHEN: Retrieve the current temperature value from the widget.
      String? temperatureText = tester.widget<Text>(temperatureValueFinder).data;
      int currentTemperature = int.parse(temperatureText!.replaceAll(RegExp(r'[^0-9]'), ''));

      // THEN: Should reduce the temperature after tapping on the Minus button
      final findMinusButton = find.byKey(const Key(WidgetKeys.minusButton));
      expect(findMinusButton, findsOneWidget);

      // THEN: Reduce the temperature after tapping on the Minus button.
      while (currentTemperature >= 25) {
        // Store the previous temperature before tapping the minus button
        int previousTemperature = currentTemperature;
        await tester.tap(findMinusButton);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        temperatureText = tester.widget<Text>(temperatureValueFinder).data;
        currentTemperature = int.parse(temperatureText!.replaceAll(RegExp(r'[^0-9]'), ''));
        expect(currentTemperature, equals(previousTemperature - 1),
            reason: "The temperature should decrease by 1 after tapping the minus button.");
        if (currentTemperature < 25) {
          break;
        }
      }
      expect(currentTemperature, lessThan(25),
          reason: "The temperature should be less than 30 after tapping the minus button.");

      // WHEN: Close the temperature control popup.
      await tapOnCloseButton(tester, const Key(WidgetKeys.closeButtonPopup));
      await tester.pump();

      // AND: Tap on the Start Heating button.
      final findStartHeatingButton = find.byKey(Key(WidgetKeys.startHeatingButton));
      expect(findStartHeatingButton, findsOneWidget);
      final findStandBylabel = find.text(WidgetKeys.standByLabel);
      expect(findStandBylabel, findsOneWidget);
      await tester.tap(findStartHeatingButton);

      // WHEN: Tap on the Start Session button.
      await tester.pump(const Duration(seconds: 5));
      final startSessionButton = find.byKey(Key(WidgetKeys.startSessionButton));
      expect(startSessionButton, findsOneWidget);
      await tester.tap(startSessionButton);

      // THEN: The session should start.

      // WHEN: Tap on the Pause Session button
      await tester.pump(const Duration(seconds: 5));
      final pauseSessionButton = find.byKey(Key(WidgetKeys.pauseSessionButton));
      expect(pauseSessionButton, findsOneWidget);
      await tester.tap(pauseSessionButton);

      // THEN: The session should be paused.

      // WHEN: Tap on the Resume Session button.
      await tester.pump(const Duration(seconds: 5));
      final resumeSessionButton = find.byKey(Key(WidgetKeys.resumeSessionButton));
      expect(resumeSessionButton, findsOneWidget);
      await tester.tap(resumeSessionButton);

      // THEN: The session should resume.

      // WHEN: Tap on the Finish Session button
      await tester.pump(const Duration(seconds: 5));
      final finishSessionButton = find.byKey(Key(WidgetKeys.finishSessionButton));
      expect(finishSessionButton, findsOneWidget);
      await tester.tap(finishSessionButton);

      // THEN: The session should resume.
      await tester.pump(const Duration(seconds: 3));
      final findStandByLabel = find.text(WidgetKeys.standByLabel);
      expect(findStandByLabel, findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('Tap on the "Cancel session" button after tapping on the "Start session" button', (tester) async {
      // GIVEN: Load app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));

      // WHEN: Tap on the Temperature tile from the bottom bar to open the temperature control.
      await tapOnBottomMenu(tester, Key(WidgetKeys.temperatureTile));
      await tester.pump(const Duration(seconds: 5));
      final Finder temperatureValueFinder = find.byKey(const Key(WidgetKeys.temperatureValue));

      // WHEN: Retrieve the current temperature value from the widget.
      String? temperatureText = tester.widget<Text>(temperatureValueFinder).data;
      int currentTemperature = int.parse(temperatureText!.replaceAll(RegExp(r'[^0-9]'), ''));

      // THEN: The temperature should reduce after tapping on the Minus button.
      final findMinusButton = find.byKey(const Key(WidgetKeys.minusButton));
      expect(findMinusButton, findsOneWidget);
      while (currentTemperature >= 22) {
        int previousTemperature = currentTemperature;

        // WHEN: Tap the minus button and wait for the UI to settle.
        await tester.tap(findMinusButton);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // THEN: Retrieve the updated temperature value from the widget.
        temperatureText = tester.widget<Text>(temperatureValueFinder).data;
        currentTemperature = int.parse(temperatureText!.replaceAll(RegExp(r'[^0-9]'), ''));

        // AND: Check if the current temperature has decreased by 1.
        expect(currentTemperature, equals(previousTemperature - 1),
            reason: "The temperature should decrease by 1 after tapping the minus button.");
        if (currentTemperature < 22) {
          break;
        }
      }
      // WHEN: Close the temperature control popup.
      await tapOnCloseButton(tester, const Key(WidgetKeys.closeButtonPopup));
      await tester.pump();

      // AND: Tap on the Start Heating button.
      final findStartHeatingButton = find.byKey(Key(WidgetKeys.startHeatingButton));
      expect(findStartHeatingButton, findsOneWidget);
      final findStandBylabel = find.text(WidgetKeys.standByLabel);
      expect(findStandBylabel, findsOneWidget);
      await tester.tap(findStartHeatingButton);

      // THEN: The sauna should start heating.
      await tester.pump(const Duration(seconds: 5));

      // WHEN: Tap on the Cancel Session button.
      final cancelSessionButton = find.byKey(Key(WidgetKeys.cancleSessionButton));
      expect(cancelSessionButton, findsOneWidget);
      await tester.tap(cancelSessionButton);

      // THEN: The "StandBy Label shound show"
      await tester.pump(const Duration(seconds: 3));
      final findStandByLabel = find.text(WidgetKeys.standByLabel);
      expect(findStandByLabel, findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('Temperature should not exceed 70 when tapping the Plus button', (WidgetTester tester) async {
      // GIVEN: Load the app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());

      await tester.pumpAndSettle(const Duration(seconds: 20));
      // WHEN: Tap on the Temperature tile from the bottom bar to open the temperature control.
      await tapOnBottomMenu(tester, Key(WidgetKeys.temperatureTile));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // THEN: The temperature control popup should be visible.
      final findtemperaturePopupTitle = find.text(WidgetKeys.temperaturePopupTitle);
      expect(findtemperaturePopupTitle, findsOneWidget);

      // GIVEN: Find the Minus button and the temperature display widget.
      final Finder plusButtonFinder = find.byKey(const Key(WidgetKeys.plusButton));

      // WHEN: Retrieve the current temperature value from the widget.
      int currentTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValue));

      // THEN: If the current temperature is less then 70, Keep tapping the Plus button until the temperature reaches 70.
      while (currentTemperature < 70) {
        await tester.tap(plusButtonFinder);
        await tester.pumpAndSettle();
        currentTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValue));
      }
      expect(currentTemperature, equals(70));

      // WHEN: Tap the Plus button one more time when the temperature is at 70.
      await tester.tap(plusButtonFinder);
      await tester.pumpAndSettle();

      // THEN: The temperature should not increase above 70.
      currentTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValue));
      expect(currentTemperature, isNot(71));
      expect(currentTemperature, equals(70));
    });

    testWidgets('Temperature should not decrease below 20 when tapping the Minus button', (WidgetTester tester) async {
      // GIVEN: Load the app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());

      await tester.pumpAndSettle(const Duration(seconds: 20));

      // WHEN: Tap on the Temperature tile from the bottom bar to open the temperature control.
      await tapOnBottomMenu(tester, Key(WidgetKeys.temperatureTile));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // THEN: The temperature control popup should be visible.
      final findTemperaturePopupTitle = find.text(WidgetKeys.temperaturePopupTitle);
      expect(findTemperaturePopupTitle, findsOneWidget);

      // GIVEN: Find the Minus button and the temperature display widget.
      final Finder minusButtonFinder = find.byKey(const Key(WidgetKeys.minusButton));

      // WHEN: Retrieve the current temperature value from the widget.
      int currentTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValue));

      // THEN: If the current temperature is above 20, reduce it to 20 by tapping the Minus button.
      while (currentTemperature > 20) {
        await tester.tap(minusButtonFinder);
        await tester.pumpAndSettle();
        currentTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValue));
      }
      expect(currentTemperature, equals(20));

      // WHEN: Tap the Minus button one more time when the temperature is at 20.
      await tester.tap(minusButtonFinder);
      await tester.pumpAndSettle();

      // THEN: The temperature should not decrease below 20.
      currentTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValue));
      expect(currentTemperature, isNot(19));
      expect(currentTemperature, equals(20));
    });

    testWidgets('Verify the temperature on temperature tile after updating', (WidgetTester tester) async {
      await tester.pumpWidget(const app.FoundSpaceApp());

      await tester.pumpAndSettle(const Duration(seconds: 20));

      // WHEN: Tap on the Temperature tile from the bottom bar to open the temperature control.
      await tapOnBottomMenu(tester, Key(WidgetKeys.temperatureTile));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // THEN: The temperature control popup should be visible.
      final findTemperaturePopupTitle = find.text(WidgetKeys.temperaturePopupTitle);
      expect(findTemperaturePopupTitle, findsOneWidget);

      // GIVEN: Find the Plus and Minus buttons and the target temperature display widget.
      final Finder plusButtonFinder = find.byKey(const Key(WidgetKeys.plusButton));
      final Finder minusButtonFinder = find.byKey(const Key(WidgetKeys.minusButton));
      int initialTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValue));

      for (int i = 0; i < 5; i++) {
        await tester.tap(plusButtonFinder);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        // Check the temperature after each tap.
        int updatedTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValue));
        expect(updatedTemperature, equals(initialTemperature + i + 1));
      }
      for (int i = 0; i < 3; i++) {
        await tester.tap(minusButtonFinder);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        // Check the temperature after each tap.
        int updatedTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValue));
        expect(updatedTemperature, equals(initialTemperature + 5 - i - 1));
      }

      // THEN: Check the target temperature displayed in the Text widget.
      int newTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValue));
      int expectedTemperature = initialTemperature + 2;
      expect(newTemperature, equals(expectedTemperature));
    });
  });
}
