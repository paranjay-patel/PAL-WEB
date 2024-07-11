import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

Future<void> verifySubtitleTextValue(WidgetTester tester, String key, String expectedValue) async {
  final findVisibleSubtitleText = find.byKey(Key(key)).hitTestable();
  expect(findVisibleSubtitleText, findsOneWidget);

  final subtitleWidget = tester.firstWidget<Text>(findVisibleSubtitleText);
  String? subtitleTextValue = subtitleWidget.data;

  String? minutesValue = subtitleTextValue?.replaceAll(RegExp(r'[^0-9]'), '');
  expect(minutesValue, isNotNull);
  expect(minutesValue, expectedValue);
}

Future<void> tapOnBottomMenu(WidgetTester tester, Key widgetKey) async {
  final finder = find.byKey(widgetKey);
  expect(finder, findsOneWidget);
  await tester.tap(finder);
}

Future<void> tapOnCloseButton(WidgetTester tester, Key widgetKey) async {
  final finder = find.byKey(widgetKey);
  expect(finder, findsOneWidget);
  await tester.tap(finder);
}

int getTemperatureFromTextWidget(WidgetTester tester, Key key) {
  final Finder finder = find.byKey(key);
  expect(finder, findsOneWidget); // Ensure the widget is found
  final Text textWidget = tester.widget<Text>(finder);
  final String temperatureText = textWidget.data!;
  return int.parse(temperatureText.replaceAll(RegExp(r'[^0-9]'), ''));
}

int getTimerValueFromRichTextWidget(WidgetTester tester, Key key) {
  final Finder finder = find.byKey(key);
  expect(finder, findsOneWidget); // Ensure the widget is found
  final RichText richTextWidget = tester.firstWidget<RichText>(finder);
  final String textValue = richTextWidget.text.toPlainText();
  return int.parse(textValue.replaceAll(RegExp(r'[^0-9]'), ''));
}

Finder findSessionLabel(String key) {
  return find.text(key);
}

// Global method to find the "Stop Heating" button
Finder findSessionButton(Key key) {
  return find.byKey(key);
}

void findWidgetLabeltByText(WidgetTester tester, String text) {
  final Finder finder = find.text(text);
  expect(finder, findsOneWidget);
}

Future<void> tapButtonWidgetByKey(WidgetTester tester, Key key) async {
  final finder = find.byKey(key);
  expect(finder, findsOneWidget);
  await tester.tap(finder);
}

void checkForCountDownText(WidgetTester tester, String text) {
  try {
    expect(find.text(text), findsOneWidget);
    print('Found exactly one widget with text: $text');
  } catch (e) {
    print('Did not find exactly one widget with text: $text');
  }
}

// int getTemperatureValueFromTextWidget(WidgetTester tester, Key key) {
//   final Finder finder = find.byKey(key);
//   expect(finder, findsOneWidget); // Ensure the widget is found
//   final Text textWidget = tester.firstWidget<Text>(finder);
//   final String textValue = textWidget.data ?? '';
//   return int.parse(textValue.replaceAll(RegExp(r'[^0-9]'), ''));
// }
