import 'package:wellnest/feature/routines/data/models/routine_model.dart';

bool areSameRoutine(RoutineModel a, RoutineModel b) {
  return a.name == b.name &&
      _listEquals(a.days, b.days) &&
      a.createdDate.isAtSameMomentAs(b.createdDate);
}

bool _listEquals(List<bool> a, List<bool> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
