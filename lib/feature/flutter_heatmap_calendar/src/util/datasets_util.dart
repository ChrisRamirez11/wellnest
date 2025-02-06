import 'package:flutter/material.dart';
import 'date_util.dart';

class DatasetsUtil {
  /// Filtering [datasets] where the key is on the same month of [referenceDate].
  static Map<DateTime, int> filterMonth(
      Map<DateTime, int>? datasets, DateTime referenceDate) {
    return Map.from(datasets ?? {})
      ..removeWhere(
        (date, value) =>
            !(date.isAfter(DateUtil.startDayOfMonth(referenceDate)) &&
                    date.isBefore(DateUtil.endDayOfMonth(referenceDate)) ||
                date == DateUtil.endDayOfMonth(referenceDate) ||
                date == DateUtil.startDayOfMonth(referenceDate)),
      );
  }

  /// Get maximum value of [datasets].
  static int getMaxValue(Map<DateTime, int>? datasets) {
    //result = 0 causes a flashing when the datasets are 0 and:
    //1- Updating the state to one of the dataset to 1
    //2- Changing to a previous month and the datasets are 0 or one of em 1 the rest 0s
    //3- If one of the datasets in a month is one and you set another one to be higher than 0,
    //it wont casue anything, but if you swap months will also occure a flashing
    //depending in other factors like datasets and the 0 or 1 values on them
    //So, to solve this issues i change result = 1
    int result = 1;

    datasets?.forEach((date, value) {
      if (value > result) {
        result = value;
      }
    });

    return result;
  }

  /// Get color from [colorsets] using [dataValue].
  static Color? getColor(Map<int, Color>? colorsets, int? dataValue) {
    int result = 0;

    colorsets?.forEach((key, value) {
      if (key <= (dataValue ?? 0)) result = key;
    });

    return colorsets?[result];
  }
}
