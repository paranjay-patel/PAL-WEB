import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as listener;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/themed_activity_indicator.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/custom_date_picker/flutter_rounded_date_picker.dart';
import 'package:found_space_flutter_web_application/custom_date_picker/src/flutter_rounded_button_action.dart';
import 'package:found_space_flutter_web_application/src/models/models.dart';
import 'package:mobx/mobx.dart';

import 'store/sauna_date_and_time_page.store.dart';

enum DateAndTime {
  date,
  time,
}

class SaunaDateAndTimePage extends StatefulWidget {
  const SaunaDateAndTimePage({Key? key}) : super(key: key);

  @override
  _SaunaDateAndTimePageState createState() => _SaunaDateAndTimePageState();
}

class _SaunaDateAndTimePageState extends State<SaunaDateAndTimePage> {
  late ColorScheme _theme;
  late ScreenSize _screenSize;
  final _store = SaunaDateAndTimePageStore();

  final _reaction = CompositeReactionDisposer();

  @override
  void initState() {
    _store.setup();
    super.initState();

    reaction<int>(
      (_) => _store.secondsRemaining,
      (secondsRemaining) {
        if (secondsRemaining == 0) {
          _store.cancelTimer();
          Navigator.pop(context);
        }
      },
    ).disposeWith(_reaction);
  }

  @override
  void dispose() {
    _reaction.dispose();
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context).colorScheme;
    _screenSize = Utils.getScreenSize(context);

    return Scaffold(
      backgroundColor: _theme.mainPopupBackgroundColor,
      body: listener.Listener(
        onPointerDown: (_) => _resetTimer(),
        onPointerMove: (_) => _resetTimer(),
        onPointerUp: (_) => _resetTimer(),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            color: _theme.mainPopupBaseBackgroundColor,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Center(
                child: Container(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Observer(builder: (context) {
                      final isAutomaticDateAndTime = _store.isAutomaticDateAndTime;
                      final currentTimeZone = _store.currentTimeZone;
                      final currentUTCTimeZone = _store.currentUTCTimeZone;

                      return Container(
                        width: _screenSize.getWidth(min: 420, max: 500),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 14, max: 20)),
                          color: _theme.popupBackgroundColor,
                          boxShadow: _theme.saunaControlPageButtonShadow,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: _screenSize.getHeight(min: 18, max: 24)),
                            _TitleAndCloseButton(store: _store),
                            SizedBox(height: _screenSize.getHeight(min: 18, max: 24)),
                            _DateAndTimeHeader(
                              isSwitchOn: isAutomaticDateAndTime,
                              isLoading: _store.isLoading,
                              onSwitchChanged: (bool? value) {
                                _store.setAutomaticDateAndTime(!isAutomaticDateAndTime);
                                _store.setSaunaDateAndTimeType(SaunaDateAndTimeType.none);
                              },
                            ),
                            Stack(
                              children: [
                                if (_store.saunaDateAndTimeType == SaunaDateAndTimeType.none)
                                  Column(
                                    children: [
                                      SizedBox(height: _screenSize.getHeight(min: 28, max: 40)),
                                      _TimezoneSection(
                                        isAutomaticDateAndTime: !isAutomaticDateAndTime,
                                        timezoneName: _store.currentUTCTimeZone,
                                        timezoneCode: extractString(_store.currentTimeZone) ?? '',
                                        onTap: () {
                                          if (_store.isLoading) return;
                                          _store.setSaunaDateAndTimeType(SaunaDateAndTimeType.timezone);
                                        },
                                      ),
                                      SizedBox(height: _screenSize.getHeight(min: 40, max: 60)),
                                      _DateAndTimeSection(
                                        isAutomaticDateAndTime: isAutomaticDateAndTime,
                                        dateAndTime: DateAndTime.date,
                                        currentDate: _store.currentDate,
                                        currentYear: _store.currentYear,
                                        onTap: () {
                                          if (_store.isLoading) return;
                                          _store.setSaunaDateAndTimeType(SaunaDateAndTimeType.date);
                                        },
                                      ),
                                      SizedBox(height: _screenSize.getHeight(min: 40, max: 60)),
                                      _DateAndTimeSection(
                                        isAutomaticDateAndTime: isAutomaticDateAndTime,
                                        dateAndTime: DateAndTime.time,
                                        currentTime: _store.currentTime,
                                        onTap: () {
                                          if (_store.isLoading) return;
                                          _store.setSaunaDateAndTimeType(SaunaDateAndTimeType.time);
                                        },
                                      ),
                                      SizedBox(height: _screenSize.getHeight(min: 28, max: 40)),
                                    ],
                                  )
                                else if (_store.saunaDateAndTimeType == SaunaDateAndTimeType.date)
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: showRoundedDatePicker(
                                      context: context,
                                      initialDate: _store.date,
                                      firstDate: DateTime(_store.date.year - 11),
                                      lastDate: DateTime(_store.date.year + 6),
                                      borderRadius: 16,
                                      onTapSetButton: (dateTime) {
                                        _store.setDate(dateTime);
                                        _store.setSaunaDateAndTimeType(SaunaDateAndTimeType.none);
                                        _store.setTimeSaunaSystem();
                                      },
                                      styleDatePicker: MaterialRoundedDatePickerStyle(
                                        paddingMonthHeader: EdgeInsets.symmetric(
                                          vertical: _screenSize.getHeight(min: 10, max: 16),
                                        ),
                                        marginTopArrowNext: _screenSize.getHeight(min: 6, max: 10),
                                        marginLeftArrowPrevious: _screenSize.getHeight(min: 6, max: 10),
                                        backgroundHeader: ThemeColors.blue50,
                                        backgroundPicker: _theme.popupBackgroundColor,
                                        textStyleYearButton: TextStyle(
                                          fontSize: _screenSize.getFontSize(min: 16, max: 20),
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textStyleDayHeader: TextStyle(
                                          fontSize: _screenSize.getFontSize(min: 10, max: 16),
                                          color: _theme.wifiSubTitleTextColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textStyleMonthYearHeader: TextStyle(
                                          fontSize: _screenSize.getFontSize(min: 16, max: 20),
                                          color: _theme.iconColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textStyleDayOnCalendar: TextStyle(
                                          fontSize: _screenSize.getFontSize(min: 16, max: 20),
                                          color: _theme.iconColor,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        textStyleDayOnCalendarSelected: TextStyle(
                                          fontSize: _screenSize.getFontSize(min: 16, max: 20),
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        decorationDateSelected: const BoxDecoration(
                                          color: ThemeColors.blue50,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  )
                                else if (_store.saunaDateAndTimeType == SaunaDateAndTimeType.time)
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: showRoundedTimePicker(
                                      context: context,
                                      background: _theme.popupBackgroundColor,
                                      initialTime: _store.time,
                                      borderRadius: 16,
                                      onTapSetButton: (timeOfDay) {
                                        _store.setTime(timeOfDay);
                                        _store.setSaunaDateAndTimeType(SaunaDateAndTimeType.none);
                                        _store.setTimeSaunaSystem();
                                      },
                                    ),
                                  )
                                else if (_store.saunaDateAndTimeType == SaunaDateAndTimeType.timezone)
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: _screenSize.getHeight(min: 420, max: 500),
                                          child: ClipRect(
                                            child: ScrollConfiguration(
                                              behavior: ScrollConfiguration.of(context).copyWith(
                                                dragDevices: {
                                                  PointerDeviceKind.touch,
                                                  PointerDeviceKind.mouse,
                                                },
                                              ),
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                clipBehavior: Clip.none,
                                                scrollDirection: Axis.vertical,
                                                itemCount: _store.timeZones.length,
                                                itemBuilder: (context, index) {
                                                  final timezone = _store.timeZones[index];
                                                  final timezoneName = timezone.text;
                                                  if (timezoneName == null) return const SizedBox();
                                                  final isSelected = currentTimeZone == timezoneName;

                                                  return _TimezoneTile(
                                                    timezone: timezone,
                                                    currentUTCTimeZone: currentUTCTimeZone,
                                                    isSelected: isSelected,
                                                    onTap: () {
                                                      _store.setTimeZone(timezoneName);
                                                    },
                                                    onUTCTimezoneTap: (String utcTimezone) {
                                                      _store.setUTCTimeZone(utcTimezone);
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: _screenSize.getHeight(min: 14, max: 20)),
                                        FlutterRoundedButtonAction(
                                          onTapButtonPositive: () {
                                            _store.setTimeZoneSectionName();
                                            _store.setTimeSaunaSystem();
                                            _store.setSaunaDateAndTimeType(SaunaDateAndTimeType.none);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _resetTimer() {
    _store.cancelTimer();
    _store.startTimer();
  }

  String? extractString(String inputString) {
    final RegExp regex = RegExp(r'\((.*?)\)');
    final RegExpMatch? match = regex.firstMatch(inputString);

    if (match != null) {
      final String? extractedString = match.group(1);
      return extractedString;
    }

    return '';
  }
}

class _TitleAndCloseButton extends StatelessWidget {
  final SaunaDateAndTimePageStore store;
  const _TitleAndCloseButton({
    Key? key,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: Utils.getScreenSize(context).getWidth(min: 18, max: 24), right: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Date & Time',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.titleTextColor,
                    fontSize: Utils.getScreenSize(context).getFontSize(min: 18, max: 24),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
                _buildTimer(context),
              ],
            ),
          ),
          FeedbackSoundWrapper(
            onTap: () {
              Navigator.pop(context);
            },
            child: SizedBox(
              width: Utils.getScreenSize(context).getWidth(min: 40, max: 50),
              height: Utils.getScreenSize(context).getHeight(min: 40, max: 50),
              child: Align(
                alignment: Alignment.center,
                child: Assets.close.toSvgPicture(
                  width: Utils.getScreenSize(context).getWidth(min: 20, max: 24),
                  height: Utils.getScreenSize(context).getHeight(min: 20, max: 24),
                  color: Theme.of(context).colorScheme.iconColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimer(BuildContext context) {
    final _screenSize = Utils.getScreenSize(context);
    return Observer(builder: (context) {
      final countdown = store.secondsRemaining;
      if (countdown > 10 || countdown <= 0) return const SizedBox();

      return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            '$countdown',
            style: TextStyle(
              color: Theme.of(context).colorScheme.titleTextColor,
              fontSize: _screenSize.getFontSize(min: 16, max: 20),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      );
    });
  }
}

class _DateAndTimeHeader extends StatelessWidget {
  final bool isSwitchOn;
  final bool isLoading;
  final Function(bool)? onSwitchChanged;
  const _DateAndTimeHeader({
    Key? key,
    this.isSwitchOn = false,
    this.isLoading = false,
    this.onSwitchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: Utils.getScreenSize(context).getWidth(min: 18, max: 24), right: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              'Set Date and Time Automatically',
              style: TextStyle(
                color: Theme.of(context).colorScheme.titleTextColor,
                fontSize: Utils.getScreenSize(context).getFontSize(min: 16, max: 20),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          if (isLoading) const ThemedActivityIndicator(radius: 6),
          const SizedBox(width: 4),
          CupertinoSwitch(
            value: isSwitchOn,
            activeColor: ThemeColors.blue50,
            onChanged: onSwitchChanged,
          ),
        ],
      ),
    );
  }
}

class _DateAndTimeSection extends StatelessWidget {
  final DateAndTime dateAndTime;
  final bool isAutomaticDateAndTime;
  final String? currentDate;
  final String? currentYear;
  final String? currentTime;
  final Function() onTap;

  const _DateAndTimeSection({
    Key? key,
    required this.dateAndTime,
    required this.onTap,
    this.isAutomaticDateAndTime = false,
    this.currentDate,
    this.currentYear,
    this.currentTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDate = dateAndTime == DateAndTime.date;
    final screenSize = Utils.getScreenSize(context);
    final theme = Theme.of(context).colorScheme;

    return IgnorePointer(
      ignoring: isAutomaticDateAndTime,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.getWidth(min: 18, max: 24)),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  isDate ? 'Choose Date' : 'Choose Time',
                  style: TextStyle(
                    color: isAutomaticDateAndTime ? theme.dateAndTimeDeselectedColor : theme.titleTextColor,
                    fontSize: screenSize.getFontSize(min: 16, max: 20),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: onTap,
                child: Container(
                  height: screenSize.getHeight(min: 80, max: 100),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenSize.getHeight(min: 10, max: 16)),
                    color: theme.borderColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isDate) ...[
                        Text(
                          currentYear ?? '',
                          style: TextStyle(
                            color: isAutomaticDateAndTime ? theme.dateAndTimeDeselectedColor : theme.titleTextColor,
                            fontSize: screenSize.getFontSize(min: 16, max: 20),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                      Text(
                        isDate ? currentDate ?? '' : currentTime ?? '',
                        style: TextStyle(
                          color: isAutomaticDateAndTime ? theme.dateAndTimeDeselectedColor : theme.titleTextColor,
                          fontSize: screenSize.getFontSize(min: 20, max: 28),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _TimezoneSection extends StatelessWidget {
  final bool isAutomaticDateAndTime;
  final String timezoneName;
  final String timezoneCode;
  final Function() onTap;

  const _TimezoneSection({
    Key? key,
    required this.onTap,
    required this.timezoneName,
    required this.timezoneCode,
    this.isAutomaticDateAndTime = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    final theme = Theme.of(context).colorScheme;

    return IgnorePointer(
      ignoring: isAutomaticDateAndTime,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.getWidth(min: 18, max: 24)),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  'Choose Time Zone',
                  style: TextStyle(
                    color: isAutomaticDateAndTime ? theme.dateAndTimeDeselectedColor : theme.titleTextColor,
                    fontSize: screenSize.getFontSize(min: 16, max: 20),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 8),
              FeedbackSoundWrapper(
                onTap: onTap,
                child: Container(
                  height: screenSize.getHeight(min: 80, max: 100),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenSize.getHeight(min: 10, max: 16)),
                    color: theme.borderColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        timezoneName,
                        style: TextStyle(
                          color: isAutomaticDateAndTime ? theme.dateAndTimeDeselectedColor : theme.titleTextColor,
                          fontSize: screenSize.getFontSize(min: 16, max: 20),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        timezoneCode,
                        style: TextStyle(
                          color: isAutomaticDateAndTime ? theme.dateAndTimeDeselectedColor : theme.titleTextColor,
                          fontSize: screenSize.getFontSize(min: 20, max: 28),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _TimezoneTile extends StatelessWidget {
  final TimeZone timezone;
  final bool isSelected;
  final String? currentUTCTimeZone;
  final Function() onTap;
  final Function(String) onUTCTimezoneTap;

  const _TimezoneTile({
    Key? key,
    required this.timezone,
    required this.isSelected,
    required this.onTap,
    required this.onUTCTimezoneTap,
    this.currentUTCTimeZone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    final theme = Theme.of(context).colorScheme;
    final utcTimezones = timezone.utc ?? [];

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: screenSize.getHeight(min: 60, max: 74),
            margin: EdgeInsets.symmetric(
              vertical: screenSize.getHeight(min: 2, max: 4),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.getHeight(min: 10, max: 16),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                screenSize.getHeight(min: 8, max: 16),
              ),
              border: Border.all(color: isSelected ? ThemeColors.blue50 : theme.timezoneBorderColor, width: 1),
            ),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    timezone.text ?? '',
                    style: TextStyle(
                      fontSize: screenSize.getFontSize(min: 16, max: 20),
                      color: theme.titleTextColor,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                (isSelected ? Assets.arrowDownIcon : Assets.arrowRight).toSvgPicture(
                  color: ThemeColors.blue50,
                  height: screenSize.getHeight(min: 16, max: 20),
                  width: screenSize.getHeight(min: 16, max: 20),
                ),
              ],
            ),
          ),
          if (isSelected)
            ListView.builder(
              shrinkWrap: true,
              clipBehavior: Clip.none,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: utcTimezones.length,
              itemBuilder: (context, index) {
                final timezone = utcTimezones[index];
                final isSelectedUTCTime = currentUTCTimeZone == timezone;

                return _TimezoneSubTile(
                  timezone: timezone ?? '',
                  isSelected: isSelectedUTCTime,
                  onTap: () {
                    onUTCTimezoneTap.call(timezone ?? '');
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}

class _TimezoneSubTile extends StatelessWidget {
  final String timezone;
  final bool isSelected;
  final Function() onTap;

  const _TimezoneSubTile({
    Key? key,
    required this.timezone,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    final theme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: screenSize.getHeight(min: 60, max: 74),
        margin: EdgeInsets.symmetric(
          vertical: screenSize.getHeight(min: 2, max: 4),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.getHeight(min: 10, max: 16),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            screenSize.getHeight(min: 8, max: 16),
          ),
          border: Border.all(color: isSelected ? ThemeColors.blue50 : theme.timezoneBorderColor, width: 1),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          timezone,
          style: TextStyle(
            fontSize: screenSize.getFontSize(min: 16, max: 20),
            color: theme.titleTextColor,
            fontWeight: FontWeight.w300,
          ),
          textAlign: TextAlign.left,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
