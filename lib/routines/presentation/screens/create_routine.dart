import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Routine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: List.generate(
                  7,
                  (index) => CheckboxListTile(
                    title: Text(
                      DateUtil.WEEK_LABEL[index + 1],
                      style: const TextStyle(fontSize: 16),
                    ),
                    value: _days[index],
                    onChanged: (value) {
                      setState(() {
                        _days[index] = value!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty &&
                      _days.any((element) => element)) {
                    final routineModel = RoutineModel(
                      name: _nameController.text,
                      days: _days,
                      createdDate: DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day),
                          finished: false
                    );
                    routineNotifier.upsertRoutine(routineModel);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill name and select at least one day'),
                      ),
                    );
                  }
                },
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

