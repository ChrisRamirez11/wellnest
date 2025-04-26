// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:wellnest/core/utils/format_duration.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/core/utils/validate_date_model_creation.dart.dart';
import 'package:wellnest/core/widgets/custom_app_bar.dart';
import 'package:wellnest/core/widgets/custom_button.dart';
import 'package:wellnest/feature/dates/data/models/date_model.dart';
import 'package:wellnest/feature/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/feature/flutter_heatmap_calendar/src/util/date_util.dart';
import 'package:wellnest/feature/routines/business/entity/routine_entity.dart';
import 'package:wellnest/feature/routines/data/models/routine_model.dart';
import 'package:wellnest/feature/routines/presentation/providers/color_provider.dart';
import 'package:wellnest/feature/routines/presentation/providers/routine_provider.dart';
import 'package:wellnest/feature/routines/presentation/widgets/color_selector_tile.dart';
import 'package:wellnest/feature/routines/presentation/widgets/custom_text_field.dart';
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
  var loading = false;
  RoutineType _selectedType = RoutineType.task;
  late TextEditingController _targetController;
  late Map<RoutineType, String> _targetValues;

  @override
  void initState() {
    super.initState();
    _targetController = TextEditingController();
    _targetValues = {
      RoutineType.counted: widget.routineModel?.targetCount.toString() ?? '1',
      RoutineType.timed:
          widget.routineModel?.targetDurationSeconds.toString() ?? '0',
    };
    
    if (widget.routineModel == null) {
      _nameController = TextEditingController();
      _days = List.generate(7, (index) => true);
    } else {
      _days = widget.routineModel!.days;
      _nameController = TextEditingController(text: widget.routineModel!.name);
      _selectedType = RoutineType.values.byName(widget.routineModel!.type);

      _initializeTargetValue();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future(
      () {
        ref.read(colorProvider).setColor(
            Color(widget.routineModel?.colorValue ?? Colors.blue.value));
      },
    );
  }

  void _initializeTargetValue() {
    if (widget.routineModel != null) {
      _targetController.text = _targetValues[_selectedType] ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routineNotifier = ref.watch(routineProvider);
    final dateNotifier = ref.watch(dateProvider);
    final colorNotifier = ref.watch(colorProvider);

    return Scaffold(
      bottomNavigationBar: getCreateButton(
          routineNotifier, context, dateNotifier, colorNotifier),
      appBar: CustomAppBar(
          titleString: localization(context).newRoutine.toUpperCase()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: [
              const SizedBox(),
              CustomTextField(
                hintText: localization(context).routineName,
                controller: _nameController,
                label: '',
              ),
              const SizedBox(height: 20),
              _buildTypeSelector(),
              _buildTargetInput(),
              const SizedBox(height: 5),
              ColorSelectorTile(),
              const SizedBox(height: 10),
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

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization(context).track,
          style: textTheme(context)
              .bodyMedium!
              .copyWith(color: Colors.grey.shade400),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child: _buildTypeButton(
              RoutineType.task,
              localization(context).task,
              FontAwesomeIcons.solidCircleCheck,
            )),
            const SizedBox(width: 8),
            Expanded(
                child: _buildTypeButton(
                    RoutineType.counted,
                    localization(context).amount,
                    FontAwesomeIcons.circleArrowUp)),
            const SizedBox(width: 8),
            Expanded(
                child: _buildTypeButton(
                    RoutineType.timed,
                    localization(context).timeRoutine,
                    FontAwesomeIcons.solidClock)),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeButton(RoutineType type, String label, IconData icon) {
    final isSelected = _selectedType == type;
    return CustomButton(
        icon: Icon(icon, color: isSelected ? ghostWhite : Colors.grey.shade600),
        color: isSelected ? primary : null,
        textColor: isSelected ? ghostWhite : Colors.grey.shade600,
        radius: 10,
        onClick: () {
          // Save current target before switching
          _targetValues[_selectedType] = _targetController.text;
          setState(() {
            _selectedType = type;
            // Load new type's target
            _targetController.text = _targetValues[type] ?? '';
          });
        },
        text: label);
  }

  Widget getCreateButton(RoutineProvider routineNotifier, BuildContext context,
      DateProvider dateNotifier, ColorProvider colorNotifier) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: CustomButton(
          color: primary,
          textColor: secondary,
          text: localization(context).save.toUpperCase(),
          onClick: !loading
              ? () async {
                  if (!_validateInputs()) {
                    _showErrorSnackbar(context);
                    return;
                  }

                  setState(() => loading = true);

                  final routineModel = _createRoutineModel(colorNotifier);

                  await routineNotifier.upsertRoutine(routineModel);
                  await _validateActualDayRoutineAddition(
                      routineModel, dateNotifier);
                  ref
                      .watch(currentSelectedDateProvider)
                      .changeDate(DateTime.now());

                  if (context.mounted) {
                    setState(() => loading = false);
                    Navigator.of(context).pop();
                  }
                }
              : null),
    );
  }

  bool _validateInputs() {
    final hasName = _nameController.text.isNotEmpty;
    final hasDays = _days.any((element) => element);
    var validTarget = true;

    if (_selectedType != RoutineType.task) {
      final targetValue = int.tryParse(_targetController.text) ?? 0;
      validTarget = targetValue > 0;
    }

    return hasName && hasDays && validTarget;
  }

  RoutineModel _createRoutineModel(ColorProvider colorNotifier) {
    return RoutineModel(
        id: widget.routineModel?.id,
        name: _nameController.text,
        days: _days,
        createdDate: widget.routineModel?.createdDate ??
            DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day),
        //checks if finished or not
        finished: false,
        colorValue: colorNotifier.color.value,
        type: _selectedType.name,
        currentCount: 0,
        elapsedTimeSeconds: 0,
        targetCount: _targetValues[RoutineType.counted] != null
            ? int.tryParse(_targetValues[RoutineType.counted]!) ?? 1
            : 1,
        targetDurationSeconds: _targetValues[RoutineType.timed] != null
            ? int.tryParse(_targetValues[RoutineType.timed]!) ?? 0
            : 0);
  }

  void _showErrorSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _selectedType == RoutineType.task
              ? 'Please fill name and select days'
              : 'Please fill all required fields',
        ),
      ),
    );
  }

  Widget _buildTargetInput() {
    switch (_selectedType) {
      case RoutineType.counted:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: CustomButton(
                  radius: 15,
                  onClick: () => _showAmountPicker(context),
                  color: primary.withAlpha(200),
                  text:
                      '${_targetController.text}${int.tryParse(_targetController.text) == 1 ? ' ${localization(context).time}' : ' ${localization(context).times}'}'),
            ),
          ],
        );
      case RoutineType.timed:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: CustomButton(
                radius: 15,
                color: primary.withAlpha(200),
                onClick: () => _showTimePicker(context),
                text: formatDuration(int.parse(_targetController.text)),
              ),
            ),
          ],
        );
      case RoutineType.task:
        return const SizedBox.shrink();
    }
  }

  void _showAmountPicker(BuildContext context) {
    int currentValue = int.tryParse(_targetController.text) ?? 1;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  localization(context).selectAmount,
                  style: textTheme(context).bodyLarge!.copyWith(fontSize: 22),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                      initialItem: currentValue - 1),
                  itemExtent: 40,
                  onSelectedItemChanged: (value) {
                    currentValue = value + 1;
                  },
                  children: List<Widget>.generate(1000, (index) {
                    return Center(
                      child: Text(
                        '${index + 1}',
                        style: textTheme(context).bodyLarge,
                      ),
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomButton(
                  color: primary,
                  textColor: secondary,
                  text: 'Confirm',
                  onClick: () {
                    setState(() {
                      _targetController.text = currentValue.toString();
                      _targetValues[_selectedType] =
                          currentValue.toString(); // Update map
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTimePicker(BuildContext context) {
    int totalSeconds = int.tryParse(_targetController.text) ?? 0;
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  localization(context).selectDuration,
                  style: textTheme(context).bodyLarge!.copyWith(fontSize: 22),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        scrollController:
                            FixedExtentScrollController(initialItem: hours),
                        itemExtent: 40,
                        onSelectedItemChanged: (value) {
                          hours = value;
                        },
                        children: List<Widget>.generate(24, (index) {
                          return Center(
                            child: Text(
                              '${index.toString().padLeft(2, '0')}h',
                              style: textTheme(context).bodyLarge,
                            ),
                          );
                        }),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        scrollController:
                            FixedExtentScrollController(initialItem: minutes),
                        itemExtent: 40,
                        onSelectedItemChanged: (value) {
                          minutes = value;
                        },
                        children: List<Widget>.generate(60, (index) {
                          return Center(
                            child: Text(
                              '${index.toString().padLeft(2, '0')}m',
                              style: textTheme(context).bodyLarge,
                            ),
                          );
                        }),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        scrollController:
                            FixedExtentScrollController(initialItem: seconds),
                        itemExtent: 40,
                        onSelectedItemChanged: (value) {
                          seconds = value;
                        },
                        children: List<Widget>.generate(60, (index) {
                          return Center(
                            child: Text(
                              '${index.toString().padLeft(2, '0')}s',
                              style: textTheme(context).bodyLarge,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomButton(
                  color: primary,
                  textColor: secondary,
                  text: 'Confirm',
                  onClick: () {
                    setState(() {
                      totalSeconds = hours * 3600 + minutes * 60 + seconds;
                      _targetController.text = totalSeconds.toString();
                      _targetValues[_selectedType] =
                          totalSeconds.toString(); // Update map
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
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

    //storing the routine crucial data before removing it from dateModel
    final finished = dateModel.routines
            .where(
              (element) => element.id == routine.id,
            )
            .firstOrNull
            ?.finished ??
        false;

    final currentCount = dateModel.routines
            .where(
              (element) => element.id == routine.id,
            )
            .firstOrNull
            ?.currentCount ??
        0;

    final elapsedTimeSeconds = dateModel.routines
            .where(
              (element) => element.id == routine.id,
            )
            .firstOrNull
            ?.elapsedTimeSeconds ??
        0;

    //saving the routine index
    final routineIndex = dateModel.routines.indexWhere(
      (element) => element.id == routine.id,
    );

    //removes routine from dateModel
    dateModel.routines.removeWhere(
      (element) => element.id == routine.id,
    );

    for (int i = 0; i < routine.days.length; i++) {
      if (routine.days[i] && (adjustedWeekday(dateModel.date) == (i + 1))) {
        routine.currentCount = currentCount;
        routine.elapsedTimeSeconds = elapsedTimeSeconds;

        routine.finished = _isCompleted(
            routineFinished: finished, type: routine.type, routine: routine);
        dateModel.routines.insert(
            routineIndex != -1 ? routineIndex : 0, Routine.fromModel(routine));
      }
      dateModel.completedRoutineAmount = _getCompletedQuantity(dateNotifier);
      await dateNotifier.upsertDate(dateModel);
    }
  }

  bool _isCompleted(
      {required bool routineFinished,
      required String type,
      RoutineModel? routine}) {
    //if no routine, it means is creating a new one, so it's false
    if (routine == null) return false;

    switch (RoutineType.values.byName(type)) {
      case RoutineType.counted:
        return (routine.currentCount) >= (routine.targetCount);
      case RoutineType.timed:
        return (routine.elapsedTimeSeconds) >= (routine.targetDurationSeconds);
      case RoutineType.task:
        return routineFinished;
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
