import 'package:flutter/material.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/core/widgets/custom_app_bar.dart';
import 'package:wellnest/feature/flutter_heatmap_calendar/src/widget/custom_fab_location.dart';
import 'data/heatmap_color_mode.dart';
import 'widget/heatmap_calendar_page.dart';
import 'widget/heatmap_color_tip.dart';
import 'util/date_util.dart';
import 'util/widget_util.dart';

class HeatMapCalendar extends StatefulWidget {
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
  });

  @override
  State<StatefulWidget> createState() => _HeatMapCalendar();
}

class _HeatMapCalendar extends State<HeatMapCalendar> {
  // The DateTime value of first day of the current month.
  DateTime? _currentDate;
  bool _showReturnToToday = false;

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
    setState(() {
      _currentDate =
          DateUtil.changeMonth(_currentDate ?? DateTime.now(), direction);
      _showReturnToToday = true;
    });
    if (widget.onMonthChange != null) widget.onMonthChange!(_currentDate!);
  }

  void goToCurrentDate() {
    DateTime actualDate = DateTime.now();
    setState(() {
      _currentDate = actualDate;
      _showReturnToToday = false;
    });
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
        Text(
          '${DateUtil.MONTH_LABEL[_currentDate?.month ?? 0]} ${_currentDate?.year}',
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
        for (String label in DateUtil.WEEK_LABEL.skip(1))
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
    return Scaffold(
      appBar: CustomAppBar(
        actionsList: [
          Container(
            margin: EdgeInsets.only(right: 10),
            height: 40,
            width: 40,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Color(0xFF004C63)),
            child: InkWell(
              customBorder: CircleBorder(),
              onTap: () => Navigator.of(context).pushNamed('/createRoutine'),
              child: Icon(
                Icons.add,
                color: secondary,
                size: 20,
                grade: 100,
                fill: 1,
              ),
            ),
          )
        ],
        titleString: 'CALENDAR',
      ),
      floatingActionButton: getFab(),
      floatingActionButtonLocation:
          CustomFABLocation(offset: Offset(15, -(size(context).height * .085))),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      body: SingleChildScrollView(
        primary: true,
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? size(context).width * .8
                        : size(context).width * .4,
                maxWidth:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? size(context).width
                        : size(context).width * .45,
              ),
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
            ConstrainedBox(
                //By removing this ConstrainedBox everything is slideable like an all
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * .45,
                  minHeight: MediaQuery.sizeOf(context).height * .2,
                  maxWidth: MediaQuery.sizeOf(context).width,
                ),
                child: widget.child ?? SizedBox.shrink())
          ],
        ),
      ),
    );
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
              FittedBox(
                child: Text(
                  'TODAY',
                  style:
                      textTheme(context).bodyLarge!.copyWith(color: secondary),
                ),
              ),
              Icon(Icons.today_outlined),
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
