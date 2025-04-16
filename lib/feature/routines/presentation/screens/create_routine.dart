// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
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

  @override
  void initState() {
    super.initState();
    _targetController = TextEditingController();
    if (widget.routineModel == null) {
      _nameController = TextEditingController();
      _days = List.generate(7, (index) => false);
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
      switch (_selectedType) {
        case RoutineType.counted:
          _targetController.text =
              widget.routineModel!.targetCount?.toString() ?? '';
          break;
        case RoutineType.timed:
          _targetController.text =
              (widget.routineModel!.targetDurationSeconds ?? 0).toString();
          break;
        case RoutineType.task:
          break;
      }
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
          'Track',
          style: textTheme(context).bodyMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child: _buildTypeButton(
              RoutineType.task,
              'Task',
            )),
            const SizedBox(width: 8),
            Expanded(
                child: _buildTypeButton(
              RoutineType.counted,
              'Amount',
            )),
            const SizedBox(width: 8),
            Expanded(
                child: _buildTypeButton(
              RoutineType.timed,
              'Time',
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeButton(RoutineType type, String label) {
    final isSelected = _selectedType == type;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? primary : Colors.transparent,
        side: BorderSide(color: isSelected ? primary : Colors.grey),
      ),
      onPressed: () {
        setState(() {
          _selectedType = type;
          _targetController.clear();
        });
      },
      child: Text(
        label,
        style: textTheme(context).bodyMedium?.copyWith(
              color: isSelected ? Colors.white : Colors.black,
            ),
      ),
    );
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
    final baseModel = RoutineModel(
      id: widget.routineModel?.id,
      name: _nameController.text,
      days: _days,
      createdDate: widget.routineModel?.createdDate ??
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
      finished: false,
      colorValue: colorNotifier.color.value,
      type: _selectedType.name,
    );

    switch (_selectedType) {
      case RoutineType.counted:
        return baseModel.copyWith(
            targetCount: int.tryParse(_targetController.text) ?? 1);
      case RoutineType.timed:
        return baseModel.copyWith(
            targetDurationSeconds: int.tryParse(_targetController.text) ?? 0);
      case RoutineType.task:
        return baseModel;
    }
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
                  text: _targetController.text.isEmpty
                      ? 'Select Amount'
                      : '${_targetController.text} times'),
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
                onClick: () => _showTimePicker(context),
                text: _targetController.text.isEmpty
                    ? 'Select Duration'
                    : _formatDuration(int.parse(_targetController.text)),
              ),
            ),
          ],
        );
      case RoutineType.task:
        return const SizedBox.shrink();
    }
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
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
                  'Select Amount',
                  style: textTheme(context).headlineSmall,
                ),
              ),
              Expanded(
                child: CupertinoPicker(
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
                  'Select Duration',
                  style: textTheme(context).headlineSmall,
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
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
                      _targetController.text =
                          (hours * 3600 + minutes * 60 + seconds).toString();
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

      return;
    }

    final dateNow =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final dateModel = dateNotifier.dates!
        .where((element) => element.date.isAtSameMomentAs(dateNow))
        .first;

    //storing the routine finished value before removing it from dateModel
    final routineSave = dateModel.routines
            .where(
              (element) => element.id == routine.id,
            )
            .firstOrNull
            ?.finished ??
        false;

    dateModel.routines.removeWhere(
      (element) => element.id == routine.id,
    );

    for (int i = 0; i < routine.days.length; i++) {
      if (routine.days[i] && (adjustedWeekday(dateModel.date) == (i + 1))) {
        routine.finished = routineSave;
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
