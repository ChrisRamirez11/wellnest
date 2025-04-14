// ignore_for_file: public_member_api_docs, sort_constructors_first
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
              const SizedBox(height: 20),
              _buildTargetInput(),
              const SizedBox(height: 20),
              ColorSelectorTile(),
              const SizedBox(height: 30),
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
    return DropdownButtonFormField<RoutineType>(
      value: _selectedType,
      decoration: InputDecoration(
        labelText: 'localization(context).routineType',
        border: OutlineInputBorder(),
      ),
      items: RoutineType.values.map((type) {
        return DropdownMenuItem<RoutineType>(
          value: type,
          child: Text(
            type.name.toUpperCase(),
            style: textTheme(context).bodyMedium,
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedType = value!;
          _targetController.clear();
        });
      },
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
        return CustomTextField(
          controller: _targetController,
          label: 'localization(context).targetCount',
          keyboardType: TextInputType.number,
        );
      case RoutineType.timed:
        return CustomTextField(
          controller: _targetController,
          label: 'localization(context).targetDurationSeconds',
          keyboardType: TextInputType.number,
          suffixText: 'localization(context).seconds',
        );
      case RoutineType.task:
        return SizedBox.shrink();
    }
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

    //storing the routine finished value before removing it from dateModel
    final routineSave = dateModel.routines.where(
      (element) => element.id == routine.id,
    ).firstOrNull?.finished ?? false;

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
