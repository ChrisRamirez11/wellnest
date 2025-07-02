import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wellnest/core/global_providers/locale_provider.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/core/utils/validate_date_model_creation.dart.dart';
import 'package:wellnest/feature/calendar/presentation/providers/calendar_visibility_provider.dart';
import 'package:wellnest/feature/calendar/presentation/providers/current_selected_date_provider.dart';
import 'package:wellnest/feature/flutter_heatmap_calendar/src/widget/custom_fab_location.dart';
import 'package:wellnest/feature/routines/presentation/providers/routine_provider.dart';
import 'data/heatmap_color_mode.dart';
import 'widget/heatmap_calendar_page.dart';
import 'widget/heatmap_color_tip.dart';
import 'util/date_util.dart';
import 'util/widget_util.dart';

class HeatMapCalendar extends ConsumerStatefulWidget {
  /// The datasets which fill blocks based on its value.
  final Map<DateTime, int>? datasets;

  /// The color value of every block's default color.
  final Color? defaultColor;

  /// The colorsets which give the color value for its thresholds key value.
  ///
  /// Be aware that first Color is the maximum value if [ColorMode] is [ColorMode.opacity].
  /// Also colorsets must have at least one color.
  final Map<int, Color> colorsets;

  /// The double value of every block's borderRadius.
  final double? borderRadius;

  /// The date values of initial year and month.
  final DateTime? initDate;

  /// The double value of every block's size.
  final double? size;

  /// The text color value of every blocks.
  final Color? textColor;

  /// The double value of every block's fontSize.
  final double? fontSize;

  /// The double value of month label's fontSize.
  final double? monthFontSize;

  /// The double value of week label's fontSize.
  final double? weekFontSize;

  /// The text color value of week labels.
  final Color? weekTextColor;

  /// Make block size flexible if value is true.
  ///
  /// Default value is false.
  final bool? flexible;

  /// The margin value for every block.
  final EdgeInsets? margin;

  /// ColorMode changes the color mode of blocks.
  ///
  /// [ColorMode.opacity] requires just one colorsets value and changes color
  /// dynamically based on hightest value of [datasets].
  /// [ColorMode.color] changes colors based on [colorsets] thresholds key value.
  ///
  /// Default value is [ColorMode.opacity].
  final ColorMode colorMode;

  /// Function that will be called when a block is clicked.
  ///
  /// Paratmeter gives clicked [DateTime] value.
  final Function(DateTime)? onClick;

  /// Function that will be called when month is changed.
  ///
  /// Paratmeter gives [DateTime] value of current month.
  final Function(DateTime)? onMonthChange;

  /// Function that will be called when when return to actual date is clicked is clicked.
  ///
  final Function()? onReturnToActualDate;

  /// Show color tip which represents the color range at the below.
  ///
  /// Default value is true.
  final bool? showColorTip;

  /// Show a calendar button for going to today date.
  ///
  /// Default value is false.
  final bool? showReturnToActualDate;

  /// Widgets which shown at left and right side of colorTip.
  ///
  /// First value is the left side widget and second value is the right side widget.
  /// Be aware that [colorTipHelper.length] have to greater or equal to 2.
  /// Give null value makes default 'less' and 'more' [Text].
  final List<Widget?>? colorTipHelper;

  /// The integer value which represents the number of [HeatMapColorTip]'s tip container.
  final int? colorTipCount;

  /// The double value of [HeatMapColorTip]'s tip container's size.
  final double? colorTipSize;

  /// The completionMap of [HeatMapCalendarPage]'s.
  final Map<DateTime, double> completionMap;

  /// The day that is currently selected.
  final DateTime? currentSelectedDate;

  /// The color of the currently selected day.
  final Color? currentSelectedDateColor;

  /// A widget that'll be under the heatmap calendar.
  final Widget? child;

  const HeatMapCalendar({
    super.key,
    required this.colorsets,
    this.colorMode = ColorMode.opacity,
    this.defaultColor,
    this.datasets,
    this.initDate,
    this.size = 42,
    this.fontSize,
    this.monthFontSize,
    this.textColor,
    this.weekFontSize,
    this.weekTextColor,
    this.borderRadius,
    this.flexible = false,
    this.margin,
    this.onClick,
    this.onMonthChange,
    this.showColorTip = true,
    this.colorTipHelper,
    this.colorTipCount,
    this.colorTipSize,
    this.currentSelectedDate,
    this.currentSelectedDateColor,
    this.showReturnToActualDate = false,
    this.onReturnToActualDate,
    this.child,
    required this.completionMap,
  });

  @override
  ConsumerState<HeatMapCalendar> createState() => _HeatMapCalendar();
}

class _HeatMapCalendar extends ConsumerState<HeatMapCalendar> {
  // The DateTime value of first day of the current month.
  DateTime? _currentDate;
  bool _showReturnToToday = false;

  late double height;
  late double width;

  ({double height, double width}) _calculateDimensions(
      BuildContext context, bool visible) {
    if (!visible) return (height: 0, width: 0);

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return (
      height:
          isPortrait ? size(context).width * 0.8 : size(context).width * 0.4,
      width: isPortrait ? size(context).width : size(context).width * 0.45,
    );
  }

  void _toggleCalendarVisibility(bool visible, void Function() fun) {
    if (context.mounted) {
      setState(() {
        final dimensions = _calculateDimensions(context, !visible);
        height = dimensions.height;
        width = dimensions.width;
        fun();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.mounted) {
      final visible = ref.watch(calendarVisibilityProvider);
      final dimensions = _calculateDimensions(context, visible);
      height = dimensions.height;
      width = dimensions.width;
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      // Set _currentDate value to first day of initialized date or
      // today's month if widget.initDate is null.
      _currentDate =
          DateUtil.startDayOfMonth(widget.initDate ?? DateTime.now());
    });
  }

  void changeMonth(int direction) {
    DateTime actualMonthYear =
        DateTime(DateTime.now().year, DateTime.now().month);

    setState(() {
      _currentDate =
          DateUtil.changeMonth(_currentDate ?? DateTime.now(), direction);

      DateTime currentSelectedMonthYear = DateTime(
          _currentDate?.year ?? DateTime.now().year,
          _currentDate?.month ?? DateTime.now().month);

      if (actualMonthYear.isAtSameMomentAs(currentSelectedMonthYear)) {
        _showReturnToToday = false;
      } else {
        _showReturnToToday = true;
      }
    });
    if (widget.onMonthChange != null) widget.onMonthChange!(_currentDate!);
  }

  Future<void> goToCurrentDate() async {
    DateTime actualDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    setState(() {
      _currentDate = actualDate;
      _showReturnToToday = false;
    });
    final routines = ref.watch(routineProvider).routines!;
    await validateDateModel(routines, actualDate, ref);
    if (widget.onMonthChange != null) widget.onMonthChange!(_currentDate!);
    if (widget.onReturnToActualDate != null) widget.onReturnToActualDate!();
  }

  /// Header widget which shows left, right buttons and year/month text.
  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // Previous month button.
        IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 14,
          ),
          onPressed: () => changeMonth(-1),
        ),

        // Text which shows the current year and month
        //If currentDate isn't null and month is valid then show the month name and year, otherwise show empty string.
        // This shows the month and year in a format like "January 2022", "February 2023" etc.
        Text(
          '${_currentDate?.month != null ? DateUtil(ref).monthLabel[_currentDate!.month - 1] : ''} ${_currentDate?.year}',
          style: TextStyle(
            fontSize: widget.monthFontSize ?? 12,
          ),
        ),

        // Next month button.
        IconButton(
          icon: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
          ),
          onPressed: () => changeMonth(1),
        ),
      ],
    );
  }

  Widget _weekLabel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (String label in DateUtil(ref).weekLabel)
          WidgetUtil.flexibleContainer(
            widget.flexible ?? false,
            false,
            Container(
              margin: EdgeInsets.only(
                  left: widget.margin?.left ?? 2,
                  right: widget.margin?.right ?? 2),
              width: widget.size ?? 42,
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: widget.weekFontSize ?? 12,
                  color: widget.weekTextColor ?? const Color(0xFF758EA1),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Expand width dynamically if [flexible] is true.
  Widget _intrinsicWidth({
    required Widget child,
  }) =>
      (widget.flexible ?? false) ? child : IntrinsicWidth(child: child);

  @override
  Widget build(BuildContext context) {
    final selectedDate =
        ref.watch(currentSelectedDateProvider).currentSelectedDate;
    final locale = ref.watch(localeProvider).locale?.languageCode;

    //Calendar Visibility
    final visibleNotifier = ref.read(calendarVisibilityProvider.notifier);
    final visible = ref.watch(calendarVisibilityProvider);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: secondary,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 15),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // color: colorScheme(context).primaryContainer,
            ),
            child: InkWell(
              customBorder: CircleBorder(),
              onTap: () => Navigator.of(context).pushNamed('/routines'),
              child: Icon(
                shadows: [
                  Shadow(blurRadius: 10, color: obsidian, offset: Offset(1, 1))
                ],
                Icons.list_alt_rounded,
                color: ghostWhite,
                size: 30,
                grade: 100,
                fill: 1,
              ),
            ),
          )
        ],
        title: appBarTitleWidget(
            visible, visibleNotifier, context, locale, selectedDate),
      ),
      floatingActionButton: getFab(),
      floatingActionButtonLocation:
          CustomFABLocation(offset: Offset(15, -(size(context).height * .1))),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: height,
            width: width,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: _intrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _header(),
                      _weekLabel(),
                      HeatMapCalendarPage(
                        completionMap: widget.completionMap,
                        currentSelectedDate: widget.currentSelectedDate,
                        currentSelectedDateColor:
                            widget.currentSelectedDateColor,
                        baseDate: _currentDate ?? DateTime.now(),
                        colorMode: widget.colorMode,
                        flexible: widget.flexible,
                        size: widget.size,
                        fontSize: widget.fontSize,
                        defaultColor: widget.defaultColor,
                        textColor: widget.textColor,
                        margin: widget.margin,
                        datasets: widget.datasets,
                        colorsets: widget.colorsets,
                        borderRadius: widget.borderRadius,
                        onClick: widget.onClick,
                      ),
                      if (widget.showColorTip == true)
                        HeatMapColorTip(
                          colorMode: widget.colorMode,
                          colorsets: widget.colorsets,
                          leftWidget: widget.colorTipHelper?[0],
                          rightWidget: widget.colorTipHelper?[1],
                          containerCount: widget.colorTipCount,
                          size: widget.colorTipSize,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: widget.child ?? SizedBox.shrink())
        ],
      ),
    );
  }

  GestureDetector appBarTitleWidget(
      bool visible,
      CalendarVisibilityProvider visibleNotifier,
      BuildContext context,
      String? locale,
      DateTime selectedDate) {
    return GestureDetector(
        onTap: () => _toggleCalendarVisibility(
            visible, visibleNotifier.toggleVisibility),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          child: Row(
            spacing: 5,
            key: ValueKey<bool>(visible),
            children: [
              Text(
                visible
                    ? localization(context).calendar.toUpperCase()
                    : DateFormat.yMMMd(locale)
                        .format(selectedDate)
                        .toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: secondary,
                ),
              ),
              Icon(
                visible ? Icons.keyboard_arrow_down : Icons.arrow_forward_ios,
                size: visible ? 25 : 15,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ));
  }

  Widget getFab() {
    late Widget fab;
    if (widget.showReturnToActualDate == true &&
        (_showReturnToToday == true ||
            !widget.currentSelectedDate!.isAtSameMomentAs(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day)))) {
      fab = SizedBox(
        height: 50,
        width: 120,
        child: FloatingActionButton(
          backgroundColor: widget.colorsets.entries.last.value,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              bottomLeft: Radius.circular(40),
            ),
          ),
          onPressed: goToCurrentDate,
          child: Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.today_outlined,
                color: secondary,
              ),
              FittedBox(
                child: Text(
                  localization(context).today.toUpperCase(),
                  style: textTheme(context)
                      .bodyMedium!
                      .copyWith(color: ghostWhite),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      fab = SizedBox.shrink();
    }
    return fab;
  }
}
