import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:wellnest/core/global_providers/is_premium_user_provider.dart';
import 'package:wellnest/core/utils/show_paywall.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/core/utils/validate_date_model_creation.dart.dart';
import 'package:wellnest/core/widgets/custom_app_bar.dart';
import 'package:wellnest/core/widgets/custom_button.dart';
import 'package:wellnest/feature/dates/data/models/date_model.dart';
import 'package:wellnest/feature/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/feature/flutter_heatmap_calendar/src/util/date_util.dart';
import 'package:wellnest/feature/routines/data/models/routine_model.dart';
import 'package:wellnest/feature/routines/presentation/providers/routine_provider.dart';
import 'package:wellnest/feature/small_routines/presentation/providers/current_selected_date_provider.dart';

import '../../../../core/theme/theme.dart';

class CreateRoutineScreen extends ConsumerStatefulWidget {
  final RoutineModel? routineModel;
  const CreateRoutineScreen({
    super.key,
    this.routineModel,
  });

  @override
  ConsumerState createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends ConsumerState<CreateRoutineScreen> {
  late TextEditingController _nameController;
  late List<bool> _days;
  late Color _selectedColor;
  var loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.routineModel == null) {
      _nameController = TextEditingController();
      _days = List.generate(7, (index) => false);
      _selectedColor = Colors.blue;
    } else {
      _days = widget.routineModel!.days;
      _nameController = TextEditingController(text: widget.routineModel!.name);
      _selectedColor =
          Color(widget.routineModel!.colorValue ?? Colors.blue.value);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routineNotifier = ref.watch(routineProvider);
    final dateNotifier = ref.watch(dateProvider);

    return Scaffold(
      bottomNavigationBar:
          getCreateButton(routineNotifier, context, dateNotifier),
      appBar: CustomAppBar(titleString: localization(context).newRoutine.toUpperCase()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: [
              const SizedBox(),
              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: '',
                  hintText: localization(context).routineName,
                  errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  disabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedErrorBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                title: Text(
                  localization(context).selectColor,
                  style:
                      textTheme(context).bodyLarge!.copyWith(color: ghostWhite),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                leading: CircleAvatar(
                  backgroundColor: _selectedColor,
                ),
                onTap: () => _showColorPicker(context),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      '${localization(context).selectWeekDays} ',
                      maxLines: 1,
                      style: textTheme(context)
                          .bodyLarge!
                          .copyWith(color: Colors.grey.shade400),
                    ),
                  ),
                ),
              ),
              weekDays(context),
              SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: Lottie.asset('assets/lotties/sleepy-cat.json'))
            ],
          ),
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    final isPremium = ref.watch(isPremiumUser).isPremium ?? false;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ...Colors.primaries.asMap().entries.map((entry) {
                final index = entry.key;
                final color = entry.value;
                final isLocked = (index >= 6 && !isPremium);

                return GestureDetector(
                  onTap: () {
                    if (isLocked) {
                      showPaywall();
                    } else {
                      setState(() {
                        _selectedColor = color;
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: color,
                        radius: 24,
                        child: isLocked
                            ? const Icon(Icons.lock, color: Colors.white)
                            : null,
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget weekDays(BuildContext context) {
    return FittedBox(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Wrap(
          runSpacing: 10,
          alignment: WrapAlignment.center,
          spacing: 8,
          children: List.generate(
            7,
            (index) => ConstrainedBox(
              constraints: const BoxConstraints(
                  minWidth: 20, maxWidth: 50, minHeight: 20, maxHeight: 50),
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () => setState(() {
                  _days[index] = !_days[index];
                }),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _days[index] ? primary : Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      DateUtil(ref).weekLabel[index][0].toUpperCase(),
                      style: textTheme(context)
                          .bodyMedium!
                          .copyWith(color: secondary),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getCreateButton(RoutineProvider routineNotifier, BuildContext context,
      DateProvider dateNotifier) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: CustomButton(
          color: primary,
          textColor: secondary,
          text: localization(context).save.toUpperCase(),
          onClick: !loading
              ? () async {
                  setState(() {
                    loading = true;
                  });
                  if (_nameController.text.isNotEmpty &&
                      _days.any((element) => element)) {
                    final routineModel = widget.routineModel == null
                        ? RoutineModel(
                            name: _nameController.text,
                            days: _days,
                            createdDate: DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day),
                            finished: false,
                            colorValue: _selectedColor.value)
                        : RoutineModel(
                            id: widget.routineModel!.id,
                            name: _nameController.text,
                            days: _days,
                            createdDate: widget.routineModel!.createdDate,
                            finished: false,
                            colorValue: _selectedColor.value);
                    await routineNotifier.upsertRoutine(routineModel);
                    await _validateActualDayRoutineAddition(
                        routineModel, dateNotifier);
                    ref
                        .watch(currentSelectedDateProvider)
                        .changeDate(DateTime.now());
                    setState(() {
                      loading = false;
                    });
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  } else {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Please fill name and select at least one day'),
                      ),
                    );
                    setState(() {
                      loading = false;
                    });
                  }
                }
              : null),
    );
  }

  Future<void> _validateActualDayRoutineAddition(
      RoutineModel routine, DateProvider dateNotifier) async {
    if (dateNotifier.dates!.isEmpty) {
      await dateNotifier.upsertDate(DateModel(
          date: DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
          routines: [],
          completedRoutineAmount: 0));
    }

    final dateNow =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final dateModel = dateNotifier.dates!
        .where((element) => element.date.isAtSameMomentAs(dateNow))
        .first;

    dateModel.routines.removeWhere(
      (element) => element.id == routine.id,
    );

    for (int i = 0; i < routine.days.length; i++) {
      if (routine.days[i] && (adjustedWeekday(dateModel.date) == (i + 1))) {
        dateModel.routines.add(Routine.fromModel(routine));
      }
      dateModel.completedRoutineAmount = _getCompletedQuantity(dateNotifier);
      await dateNotifier.upsertDate(dateModel);
    }
  }

  int _getCompletedQuantity(DateProvider dateNotifier) {
    int result = 0;
    for (var routine in dateNotifier.date!.routines) {
      result += routine.finished! ? 1 : 0;
    }
    return result;
  }
}
