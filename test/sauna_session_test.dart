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

  group('Start heating button Test', () {
    testWidgets('Find Stand by label and Start Heating button', (tester) async {
      // GIVEN: Load app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));
      await tester.pumpAndSettle();
      // Then: Find the "Start Heating" button and  "Stand By label"
      final findStartHeatingButton = find.byKey(Key(WidgetKeys.startHeatingButton));
      expect(findStartHeatingButton, findsOneWidget);
      final findStandByLabel = find.text(WidgetKeys.standByLabel);
      expect(findStandByLabel, findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('Tap on the Start Heating Button and Check the "Start Heating" label displayed or not', (tester) async {
      // GIVEN: Load app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));
      await tester.pumpAndSettle();

      // WHEN: Tap on the Start heating button
      expect(findSessionLabel(WidgetKeys.standByLabel), findsOneWidget);
      expect(findSessionButton(Key(WidgetKeys.startHeatingButton)), findsOneWidget);
      await tester.tap(findSessionButton(Key(WidgetKeys.startHeatingButton)));

      // THEN : "Sauna is heating" label should be displayed
      await tester.pump(const Duration(seconds: 5));
      expect(findSessionLabel(WidgetKeys.heatingLabel), findsOneWidget);
      expect(findSessionButton(Key(WidgetKeys.stopHeatingButton)), findsOneWidget);
      await tester.tap(findSessionButton(Key(WidgetKeys.stopHeatingButton)));

      await tester.pump(const Duration(seconds: 5));
      expect(findSessionLabel(WidgetKeys.standByLabel), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('Tap on the Stop Heating Button and Check the "Sauna is in Standby" label displayed or not',
        (tester) async {
      // GIVEN: Load app widget and Tap on the "Start heating" button
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));
      await tester.pumpAndSettle();
      expect(findSessionLabel(WidgetKeys.standByLabel), findsOneWidget);
      expect(findSessionButton(Key(WidgetKeys.startHeatingButton)), findsOneWidget);
      await tester.tap(findSessionButton(Key(WidgetKeys.startHeatingButton)));

      // WHEN : Tap on the "Stop Heating" button
      await tester.pump(const Duration(seconds: 5));
      expect(findSessionLabel(WidgetKeys.heatingLabel), findsOneWidget);
      expect(findSessionButton(Key(WidgetKeys.stopHeatingButton)), findsOneWidget);
      await tester.tap(findSessionButton(Key(WidgetKeys.stopHeatingButton)));

      // THEN: "Sauna is in standby" label is displayed
      await tester.pump(const Duration(seconds: 5));
      expect(findSessionLabel(WidgetKeys.standByLabel), findsOneWidget);
      expect(findSessionButton(Key(WidgetKeys.startHeatingButton)), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets(
        'Tap on the "Start Heating" Button again after tapping on "Stop heating" button and Check the "Start Heating" button displayed or not',
        (tester) async {
      // GIVEN: Load app widget and Tap on the "Start heating" button
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));
      await tester.pumpAndSettle();
      expect(findSessionLabel(WidgetKeys.standByLabel), findsOneWidget);
      expect(findSessionButton(Key(WidgetKeys.startHeatingButton)), findsOneWidget);
      await tester.tap(findSessionButton(Key(WidgetKeys.startHeatingButton)));

      // WHEN: tap on the "Start Heating" button again after tapping on the "Stop Heating" button
      await tester.pump(const Duration(seconds: 5));
      expect(findSessionLabel(WidgetKeys.heatingLabel), findsOneWidget);
      expect(findSessionButton(Key(WidgetKeys.stopHeatingButton)), findsOneWidget);
      await tester.tap(findSessionButton(Key(WidgetKeys.stopHeatingButton)));
      await tester.pump(const Duration(seconds: 5));
      expect(findSessionLabel(WidgetKeys.standByLabel), findsOneWidget);
      expect(findSessionButton(Key(WidgetKeys.startHeatingButton)), findsOneWidget);
      await tester.tap(findSessionButton(Key(WidgetKeys.startHeatingButton)));

      // THEN: "Stop Heating" button should be displayed
      await tester.pump(const Duration(seconds: 5));
      expect(findSessionButton(Key(WidgetKeys.stopHeatingButton)), findsOneWidget);
      await tester.tap(findSessionButton(Key(WidgetKeys.stopHeatingButton)));
      await tester.pumpAndSettle();
    });

    testWidgets('Find "Start session early" Button and "Sauna is heating" label', (tester) async {
      // GIVEN: Load app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));
      await tester.pumpAndSettle();

      // WHEN : Tap on the "Start Heating" button
      expect(findSessionLabel(WidgetKeys.standByLabel), findsOneWidget);
      expect(findSessionButton(Key(WidgetKeys.startHeatingButton)), findsOneWidget);
      await tester.tap(findSessionButton(Key(WidgetKeys.startHeatingButton)));

      // THEN : "Start Session Early" button should be displayed
      await tester.pump(const Duration(seconds: 5));
      expect(findSessionLabel(WidgetKeys.heatingLabel), findsOneWidget);
      expect(findSessionButton(const Key(WidgetKeys.startSessionEarlyButton)), findsOneWidget);
      await tester.pump(const Duration(seconds: 5));
      await tester.tap(findSessionButton(Key(WidgetKeys.stopHeatingButton)));
      await tester.pumpAndSettle();
    });

    testWidgets('Tap on "Start session early" Button and find "Sauna is in session" label', (tester) async {
      // GIVEN: Load app widget and Tap on the "Start heating" button
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));
      await tester.pumpAndSettle();
      expect(findSessionLabel(WidgetKeys.standByLabel), findsOneWidget);
      expect(findSessionButton(Key(WidgetKeys.startHeatingButton)), findsOneWidget);
      await tester.tap(findSessionButton(Key(WidgetKeys.startHeatingButton)));

      // WHEN : Tap on the "Start Session Early" button
      await tester.pump(const Duration(seconds: 5));
      expect(findSessionLabel(WidgetKeys.heatingLabel), findsOneWidget);
      expect(findSessionButton(const Key(WidgetKeys.startSessionEarlyButton)), findsOneWidget);
      await tester.tap(findSessionButton(const Key(WidgetKeys.startSessionEarlyButton)));

      // THEN : "Sauna is in session" label should be displayed
      await tester.pump(const Duration(seconds: 5));
      expect(findSessionLabel(WidgetKeys.inSessionLabel), findsOneWidget);
      expect(findSessionButton(Key(WidgetKeys.finishSessionButton)), findsOneWidget);
      await tester.tap(findSessionButton(Key(WidgetKeys.finishSessionButton)));
      await tester.pumpAndSettle();
    });

    testWidgets('Find "Pause Session" and "Finish Session" button after tapping on "Start Session Early" button ',
        (tester) async {
      // GIVEN: Load app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      // Wait for 20 seconds.
      await tester.pumpAndSettle(const Duration(seconds: 20));
      await tester.pumpAndSettle();

      // GIVEN: Tap on the "Start Heating" button
      expect(findSessionLabel(WidgetKeys.standByLabel), findsOneWidget);
      expect(findSessionButton(Key(WidgetKeys.startHeatingButton)), findsOneWidget);
      await tester.tap(findSessionButton(Key(WidgetKeys.startHeatingButton)));

      // WHEN: Tap on the "Start Session Early" button
      await tester.pump(const Duration(seconds: 5));
      expect(findSessionLabel(WidgetKeys.heatingLabel), findsOneWidget);
      expect(findSessionButton(const Key(WidgetKeys.startSessionEarlyButton)), findsOneWidget);
      await tester.tap(findSessionButton(const Key(WidgetKeys.startSessionEarlyButton)));

      // THEN : "Pause session" and "Finish session" button should be displayed
      await tester.pump(const Duration(seconds: 5));
      expect(findSessionLabel(WidgetKeys.inSessionLabel), findsOneWidget);
      expect(findSessionButton(Key(WidgetKeys.finishSessionButton)), findsOneWidget);
      expect(findSessionButton(Key(WidgetKeys.pauseSessionButton)), findsOneWidget);
      await tester.tap(findSessionButton(Key(WidgetKeys.finishSessionButton)));

      await tester.pumpAndSettle();
    });

    testWidgets(
        'Tap on the "Pause Session" button, find "Sauna is Paused" label, tap on the "Resume Session" button and Find "Sauna is in session" label',
        (tester) async {
      // GIVEN: Load app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));
      await tester.pumpAndSettle();

      // GIVEN: Tap on the "Start Heating" button
      expect(findSessionLabel(WidgetKeys.standByLabel), findsOneWidget);
      expect(findSessionButton(Key(WidgetKeys.startHeatingButton)), findsOneWidget);
      await tester.tap(findSessionButton(Key(WidgetKeys.startHeatingButton)));
      await tester.pump(const Duration(seconds: 5));
      expect(findSessionLabel(WidgetKeys.heatingLabel), findsOneWidget);
      expect(findSessionButton(const Key(WidgetKeys.startSessionEarlyButton)), findsOneWidget);
      await tester.tap(findSessionButton(const Key(WidgetKeys.startSessionEarlyButton)));

      // WHEN: Tap on the "Pause Session " button
      await tester.pump(const Duration(seconds: 5));
      expect(findSessionButton(Key(WidgetKeys.finishSessionButton)), findsOneWidget);
      expect(findSessionButton(Key(WidgetKeys.pauseSessionButton)), findsOneWidget);
      await tester.tap(findSessionButton(Key(WidgetKeys.pauseSessionButton)));

      // THEN : Sauna is paused button should be disp;ayed and "Sauna is in session" label should be displayed after tapping on the "Resume session" button
      await tester.pump(const Duration(seconds: 5));
      expect(findSessionLabel(WidgetKeys.pausedLabel), findsOneWidget);
      expect(findSessionButton(Key(WidgetKeys.resumeSessionButton)), findsOneWidget);
      await tester.tap(findSessionButton(Key(WidgetKeys.resumeSessionButton)));

      await tester.pump(const Duration(seconds: 5));
      expect(findSessionLabel(WidgetKeys.inSessionLabel), findsOneWidget);
      expect(findSessionButton(Key(WidgetKeys.finishSessionButton)), findsOneWidget);
      await tester.tap(findSessionButton(Key(WidgetKeys.finishSessionButton)));
      await tester.pumpAndSettle();
    });

    testWidgets('Tap on the temperature tile', (tester) async {
      // GIVEN: Load app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));

      // WHEN: Tap on the Temprature tile from bottom bar
      await tapOnBottomMenu(tester, Key(WidgetKeys.temperatureTile));
      await tester.pump(const Duration(seconds: 5));

      // THEN : The "Temperature" title should be displayed
      final findtemperaturePopupTitle = find.text(WidgetKeys.temperaturePopupTitle);
      expect(findtemperaturePopupTitle, findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets(
        'Tap on the "Start session" button after tapping on the "Start heating" button then Tap on the "Finish session" button',
        (tester) async {
      // GIVEN: Load app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));

      await tapOnBottomMenu(tester, Key(WidgetKeys.temperatureTile));
      await tester.pump(const Duration(seconds: 5));

      // THEN: The temperature control popup should be visible.
      final findtemperaturePopupTitle = find.text(WidgetKeys.temperaturePopupTitle);
      expect(findtemperaturePopupTitle, findsOneWidget);

      // WHEN: Retrieve the current temperature value from the widget.
      int currentTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValue));

      // THEN: Should reduce the temperature after tapping on the Minus button
      final findMinusButton = find.byKey(const Key(WidgetKeys.minusButton));
      while (currentTemperature >= 25) {
        await tester.tap(findMinusButton);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        currentTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValue));
        if (currentTemperature < 25) {
          break;
        }
      }
      expect(currentTemperature, lessThan(25),
          reason: "The temperature should be less than 25 after tapping the minus button.");

      // WHEN: Close the temperature control popup.
      await tapOnCloseButton(tester, const Key(WidgetKeys.closeButtonPopup));
      await tester.pump();

      // AND: Tap on the Start Heating button.
      await tester.pump(const Duration(seconds: 5));
      expect(findSessionLabel(WidgetKeys.standByLabel), findsOneWidget);
      expect(findSessionButton(Key(WidgetKeys.startHeatingButton)), findsOneWidget);
      await tester.tap(findSessionButton(Key(WidgetKeys.startHeatingButton)));

      // WHEN: Tap on the Start Session button.
      await tester.pump(const Duration(seconds: 5));
      expect(findSessionButton(Key(WidgetKeys.startSessionButton)), findsOneWidget);
      await tester.tap(findSessionButton(Key(WidgetKeys.startSessionButton)));

      // THEN: The session should start.

      // WHEN: Tap on the Finish Session button.
      await tester.pump(const Duration(seconds: 5));
      expect(findSessionButton(Key(WidgetKeys.finishSessionButton)), findsOneWidget);
      await tester.tap(findSessionButton(Key(WidgetKeys.finishSessionButton)));

      // THEN: The session should end and the UI should return to its initial state.
      await tester.pumpAndSettle();
    });
  });
}
