import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/core/utils/validate_date_model_creation.dart.dart';
import 'package:wellnest/core/widgets/custom_app_bar.dart';
import 'package:wellnest/core/widgets/custom_button.dart';
import 'package:wellnest/dates/data/models/date_model.dart';
import 'package:wellnest/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/flutter_heatmap_calendar/src/util/date_util.dart';
import 'package:wellnest/routines/data/models/routine_model.dart';
import 'package:wellnest/routines/presentation/providers/routine_provider.dart';

class CreateRoutineScreen extends ConsumerStatefulWidget {
  const CreateRoutineScreen({super.key});

  @override
  ConsumerState createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends ConsumerState<CreateRoutineScreen> {
  late TextEditingController _nameController;
  late List<bool> _days;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _days = List.generate(7, (index) => false);
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
      appBar: CustomAppBar(titleString: 'Create Routine'),
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
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: '',
                  hintText: 'Routine name',
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
                height: 60,
              ),
              weekDays(context),
              Padding(
                padding: const EdgeInsets.only(right: 70.0, top: 40),
                child: Lottie.asset('assets/lotties/green-cat.json'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Wrap weekDays(BuildContext context) {
    return Wrap(
      runSpacing: 10,
      alignment: WrapAlignment.center,
      spacing: 8,
      children: List.generate(
        7,
        (index) => ConstrainedBox(
          constraints: const BoxConstraints(
              minWidth: 20, maxWidth: 40, minHeight: 20, maxHeight: 40),
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () => setState(() {
              _days[index] = !_days[index];
            }),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _days[index] ? primary : catColor,
              ),
              child: Center(
                child: Text(
                  DateUtil.WEEK_LABEL[index + 1][0].toUpperCase(),
                  style:
                      textTheme(context).bodyMedium!.copyWith(color: obsidian),
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
          text: 'SAVE',
          onClick: () async {
            if (_nameController.text.isNotEmpty &&
                _days.any((element) => element)) {
              final routineModel = RoutineModel(
                  name: _nameController.text,
                  days: _days,
                  createdDate: DateTime(DateTime.now().year,
                      DateTime.now().month, DateTime.now().day),
                  finished: false);
              await routineNotifier.upsertRoutine(routineModel);
              await _validateActualDayRoutineAddition(
                  routineModel, dateNotifier);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            } else {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please fill name and select at least one day'),
                ),
              );
            }
          }),
    );
  }

  Future<void> _validateActualDayRoutineAddition(
      RoutineModel routine, DateProvider dateNotifier) async {
    final dateNow =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final dateModel = dateNotifier.dates!
        .where((element) => element.date.isAtSameMomentAs(dateNow))
        .first;

    for (int i = 0; i < routine.days.length; i++) {
      if (routine.days[i] && (adjustedWeekday(dateModel.date) == (i + 1))) {
        dateModel.routines.add(Routine.fromModel(routine));
      }
    }
    await dateNotifier.upsertDate(dateModel);
  }
}
