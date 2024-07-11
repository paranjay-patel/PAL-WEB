import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/custom_date_picker/src/era_mode.dart';
import 'package:found_space_flutter_web_application/custom_date_picker/src/material_rounded_year_picker_style.dart';

/// A scrollable list of years to allow picking a year.
///
/// The year picker widget is rarely used directly. Instead, consider using
/// [showDatePicker], which creates a date picker dialog.
///
/// Requires one of its ancestors to be a [Material] widget.
///
/// See also:
///
///  * [showDatePicker], which shows a dialog that contains a material design
///    date picker.
///  * [showTimePicker], which shows a dialog that contains a material design
///    time picker.
class FlutterRoundedYearPicker extends StatefulWidget {
  /// Creates a year picker.
  ///
  /// The [selectedDate] and [onChanged] arguments must not be null. The
  /// [lastDate] must be after the [firstDate].
  ///
  /// Rarely used directly. Instead, typically used as part of the dialog shown
  /// by [showDatePicker].
  FlutterRoundedYearPicker(
      {Key? key,
      required this.selectedDate,
      required this.onChanged,
      required this.firstDate,
      required this.lastDate,
      required this.era,
      this.fontFamily,
      this.dragStartBehavior = DragStartBehavior.start,
      this.style})
      : assert(!firstDate.isAfter(lastDate)),
        super(key: key);

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime selectedDate;

  /// Called when the user picks a year.
  final Function onChanged;

  /// The earliest date the user is permitted to pick.
  final DateTime firstDate;

  /// The latest date the user is permitted to pick.
  final DateTime lastDate;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// Era
  final EraMode era;

  /// Font
  final String? fontFamily;

  /// style
  final MaterialRoundedYearPickerStyle? style;

  @override
  _FlutterRoundedYearPickerState createState() => _FlutterRoundedYearPickerState();
}

class _FlutterRoundedYearPickerState extends State<FlutterRoundedYearPicker> {
  late double _itemExtent;
  ScrollController? scrollController;

  @override
  void initState() {
    super.initState();
    _itemExtent = widget.style?.heightYearRow ?? 50;
    scrollController = ScrollController(
      // Move the initial scroll position to the currently selected date's year.
      initialScrollOffset: (widget.selectedDate.year - widget.firstDate.year) * _itemExtent,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final screenSize = Utils.getScreenSize(context);

    const cardRatio = 130.0 / 54.0;

    return Container(
      color: Theme.of(context).colorScheme.popupBackgroundColor,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
          scrollbars: false,
        ),
        child: GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: screenSize.getHeight(min: 16, max: 24)),
          shrinkWrap: true,
          itemCount: widget.lastDate.year - widget.firstDate.year + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: cardRatio,
          ),
          itemBuilder: (context, index) {
            final int year = widget.firstDate.year + index;
            final bool isSelected = year == widget.selectedDate.year;
            final TextStyle itemStyle = TextStyle(
              fontSize: screenSize.getFontSize(min: 16, max: 20),
              fontWeight: FontWeight.w300,
              color: Theme.of(context).colorScheme.titleTextColor,
            );

            return InkWell(
              key: ValueKey<int>(year),
              onTap: () {
                widget.onChanged(DateTime(
                  year,
                  widget.selectedDate.month,
                  widget.selectedDate.day,
                ));
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                  vertical: screenSize.getHeight(min: 6, max: 10),
                  horizontal: screenSize.getWidth(min: 12, max: 20),
                ),
                decoration: BoxDecoration(
                  color: isSelected ? ThemeColors.blue50 : null,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "${calculateYearEra(widget.era, year)}",
                  style: itemStyle,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
