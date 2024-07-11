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

  group('Test the sleep mode screen first to end', () {
    testWidgets('Check the Slepe mode and turn off screen open or not after tapping on the Sleep and Turn Off button',
        (WidgetTester tester) async {
      //   // GIVEN: Load app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));
      await tester.pumpAndSettle();

      // THEN: Verify that the dashboard tab is initially selected.
      expect(find.byKey(Key(WidgetKeys.dashboardScreenTab)), findsOneWidget);

      // WHEN: The simple mode tab is tapped.
      await tester.tap(find.byKey(Key(WidgetKeys.simpleScreenTab)));
      await tester.pumpAndSettle();

      // THEN: Verify that the simple mode tab is selected.
      expect(find.byKey(Key(WidgetKeys.simpleScreenTab)), findsOneWidget);

      // WHEN: The turn off screen tab is tapped.
      await tester.tap(find.byKey(Key(WidgetKeys.turnOffScreenTab)));
      await tester.pumpAndSettle();

      // THEN: Verify that the turn off screen tab is selected.
      expect(find.byKey(Key(WidgetKeys.turnOffScreenTab)), findsOneWidget);

      // WHEN: The dashboard tab is tapped again.
      await tester.tap(find.byKey(Key(WidgetKeys.dashboardScreenTab)));
      await tester.pumpAndSettle();

      // THEN: Verify that the dashboard tab is selected again.
      expect(find.byKey(Key(WidgetKeys.dashboardScreenTab)), findsOneWidget);
    });

    testWidgets('Check the "Sauna is in standby" label displayed or not"', (WidgetTester tester) async {
      //   // GIVEN: Load app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));
      await tester.pumpAndSettle();

      // THEN: Verify that the dashboard tab is initially selected.
      expect(find.byKey(Key(WidgetKeys.dashboardScreenTab)), findsOneWidget);

      // When: The simple mode tab is tapped.
      await tester.tap(find.byKey(Key(WidgetKeys.simpleScreenTab)));
      await tester.pumpAndSettle();

      // THEN: Verify that the simple mode tab is selected.
      expect(find.byKey(Key(WidgetKeys.simpleScreenTab)), findsOneWidget);

      // AND: Check if the "Sauna is in standby" label is displayed.
      expect(find.text(WidgetKeys.standByLabel), findsOneWidget);
    });

    testWidgets('Increase temperature until it reaches 70', (WidgetTester tester) async {
      // GIVEN: Load the app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));

      // When: The simple mode tab is tapped.
      await tester.tap(find.byKey(Key(WidgetKeys.simpleScreenTab)));
      await tester.pump(const Duration(seconds: 5));

      // GIVEN: Find the Plus button and the temperature display widget.
      final plusTemperatureButtonFinder = find.byKey(const Key(WidgetKeys.plusTemperatureButton));
      int currentTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValueSleep));

      // WHEN: The Plus button is tapped repeatedly until the temperature reaches 70.
      while (currentTemperature < 70) {
        await tester.tap(plusTemperatureButtonFinder);
        await tester.pumpAndSettle();
        currentTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValueSleep));
        // THEN: Verify the temperature does not exceed 70 after each tap.
        expect(currentTemperature <= 70, isTrue);
      }

      // THEN: Assert that the final temperature is exactly 70.
      expect(currentTemperature, equals(70));
    });

    testWidgets('Temperature should not exceed 70 when tapping the Plus button', (WidgetTester tester) async {
      // GIVEN: Load the app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));

      // When: The simple mode tab is tapped.
      await tester.tap(find.byKey(Key(WidgetKeys.simpleScreenTab)));
      await tester.pump(const Duration(seconds: 5));

      // GIVEN: The Plus button and the temperature display widget are located.
      final plusTemperatureButtonFinder = find.byKey(const Key(WidgetKeys.plusTemperatureButton));
      int currentTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValueSleep));

      // THEN: The temperature is increased to 70 by repeatedly tapping the Plus button.
      while (currentTemperature < 70) {
        await tester.tap(plusTemperatureButtonFinder);
        await tester.pumpAndSettle();
        currentTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValueSleep));
      }

      // THEN: The temperature should be 70, indicating it cannot go above this value.
      expect(currentTemperature, equals(70));

      // WHEN: The Plus button is tapped one more time at a temperature of 70.
      await tester.tap(plusTemperatureButtonFinder);
      await tester.pumpAndSettle();

      // THEN: The temperature should remain at 70 and not increase further.
      currentTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValueSleep));
      expect(currentTemperature, isNot(71));
      expect(currentTemperature, equals(70));
    });

    testWidgets('Temperature should not decrease below 20 when tapping the Minus button', (WidgetTester tester) async {
      // GIVEN: Load the app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));

      // When: The simple mode tab is tapped.
      await tester.tap(find.byKey(Key(WidgetKeys.simpleScreenTab)));
      await tester.pump(const Duration(seconds: 5));

      // GIVEN: The Minus button and the temperature display widget are located.
      final minusTemperatureButtonFinder = find.byKey(const Key(WidgetKeys.minusTemperatureButton));
      int currentTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValueSleep));

      // WHEN: The temperature is reduced to 20 by repeatedly tapping the Minus button.
      while (currentTemperature > 20) {
        await tester.tap(minusTemperatureButtonFinder);
        await tester.pumpAndSettle();
        currentTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValueSleep));
      }

      // THEN: The temperature should be 20, indicating it cannot go below this value.
      expect(currentTemperature, equals(20));

      // WHEN: The Minus button is tapped one more time at a temperature of 20.
      await tester.tap(minusTemperatureButtonFinder);
      await tester.pumpAndSettle();

      // THEN: The temperature should remain at 20 and not decrease further.
      currentTemperature = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.temperatureValueSleep));
      expect(currentTemperature, isNot(19));
      expect(currentTemperature, equals(20));
    });

    testWidgets('Increase timer until it reaches 60', (WidgetTester tester) async {
      // GIVEN: Load the app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));

      // When: The simple mode tab is tapped.
      await tester.tap(find.byKey(Key(WidgetKeys.simpleScreenTab)));
      await tester.pump(const Duration(seconds: 5));

      // GIVEN: Find the Plus button and the time display widget.
      final plusTimerButtonFinder = find.byKey(const Key(WidgetKeys.plusTimeButton));
      int currentTimer = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.timeValueSleep));

      // WHEN: The Plus button is tapped repeatedly until the time reaches 60.
      while (currentTimer < 60) {
        await tester.tap(plusTimerButtonFinder);
        await tester.pumpAndSettle();
        currentTimer = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.timeValueSleep));
        // THEN: Verify the time does not exceed 60 after each tap.
        expect(currentTimer <= 60, isTrue);
      }

      // THEN: Assert that the final time is exactly 70.
      expect(currentTimer, equals(60));
    });

    testWidgets('Timer should not exceed 60 when tapping the Plus button', (WidgetTester tester) async {
      // GIVEN: Load the app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));

      // When: The simple mode tab is tapped.
      await tester.tap(find.byKey(Key(WidgetKeys.simpleScreenTab)));
      await tester.pump(const Duration(seconds: 5));

      // GIVEN: The Plus button and the time display widget are located.
      final plusTimerButtonFinder = find.byKey(const Key(WidgetKeys.plusTimeButton));
      int currentTimer = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.timeValueSleep));

      // THEN: The time is increased to 60 by repeatedly tapping the Plus button.
      while (currentTimer < 60) {
        await tester.tap(plusTimerButtonFinder);
        await tester.pumpAndSettle();
        currentTimer = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.timeValueSleep));
      }

      // THEN: The time should be 60, indicating it cannot go above this value.
      expect(currentTimer, equals(60));

      // WHEN: The Plus button is tapped one more time at a temperature of 60.
      await tester.tap(plusTimerButtonFinder);
      await tester.pumpAndSettle();

      // THEN: The time should remain at 60 and not increase further.
      currentTimer = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.timeValueSleep));
      expect(currentTimer, isNot(61));
      expect(currentTimer, equals(60));
    });

    testWidgets('Time should not decrease below 1 when tapping the Minus button', (WidgetTester tester) async {
      // GIVEN: Load the app widget and wait for the initial UI to settle.
      await tester.pumpWidget(const app.FoundSpaceApp());
      await tester.pumpAndSettle(const Duration(seconds: 20));

      // When: The simple mode tab is tapped.
      await tester.tap(find.byKey(Key(WidgetKeys.simpleScreenTab)));
      await tester.pump(const Duration(seconds: 5));

      // GIVEN: The Minus button and the time display widget are located.
      final minusTimeButtonFinder = find.byKey(const Key(WidgetKeys.minusTimeButton));
      int currentTimer = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.timeValueSleep));

      // WHEN: The time is reduced to 20 by repeatedly tapping the Minus button.
      while (currentTimer > 1) {
        await tester.tap(minusTimeButtonFinder);
        await tester.pumpAndSettle();
        currentTimer = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.timeValueSleep));
      }

      // THEN: The time should be 20, indicating it cannot go below this value.
      expect(currentTimer, equals(1));

      // WHEN: The Minus button is tapped one more time at a time of 20.
      await tester.tap(minusTimeButtonFinder);
      await tester.pumpAndSettle();

      // THEN: The time should remain at 20 and not decrease further.
      currentTimer = getTemperatureFromTextWidget(tester, const Key(WidgetKeys.timeValueSleep));
      expect(currentTimer, isNot(0));
      expect(currentTimer, equals(1));
    });
  });
}
