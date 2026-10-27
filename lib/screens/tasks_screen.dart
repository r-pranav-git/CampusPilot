import 'package:flutter/material.dart';
import '../models/campus_task.dart';
import '../services/local_store.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late List<CampusTask> tasks;
  @override
  void initState() { super.initState(); tasks = LocalStore.loadTasks(); }

  Future<void> persist() async { await LocalStore.saveTasks(tasks); if (mounted) setState(() {}); }

  Future<void> addTask() async {
    final title = TextEditingController();
    String category = 'Academic';
    DateTime due = DateTime.now().add(const Duration(days: 1));
    final result = await showDialog<bool>(context: context, builder: (context) => StatefulBuilder(
      builder: (context, setDialog) => AlertDialog(
        title: const Text('Add a task'),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: title, autofocus: true, decoration: const InputDecoration(labelText: 'Task title')),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(value: category, decoration: const InputDecoration(labelText: 'Category'), items: const [
            DropdownMenuItem(value: 'Academic', child: Text('Academic')),
            DropdownMenuItem(value: 'Placement', child: Text('Placement')),
            DropdownMenuItem(value: 'Study', child: Text('Study')),
            DropdownMenuItem(value: 'Personal', child: Text('Personal')),
          ], onChanged: (v) { if (v != null) setDialog(() => category = v); }),
          const SizedBox(height: 8),
          TextButton.icon(onPressed: () async {
            final picked = await showDatePicker(context: context, initialDate: due, firstDate: DateTime.now().subtract(const Duration(days: 1)), lastDate: DateTime.now().add(const Duration(days: 365)));
            if (picked != null) setDialog(() => due = picked);
          }, icon: const Icon(Icons.calendar_month), label: Text('Due: ${due.day}/${due.month}/${due.year}')),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Add')),
        ],
      ),
    ));
    if (result == true && title.text.trim().isNotEmpty) {
      tasks.insert(0, CampusTask(id: DateTime.now().microsecondsSinceEpoch.toString(), title: title.text.trim(), category: category, dueDate: due));
      await persist();
    }
    title.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.transparent,
    floatingActionButton: FloatingActionButton.extended(onPressed: addTask, icon: const Icon(Icons.add), label: const Text('Add task')),
    body: tasks.isEmpty ? const Center(child: Text('No tasks yet. Add your first task!')) : ListView(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 90),
      children: [
        Padding(padding: const EdgeInsets.all(8), child: Text('${tasks.where((t) => !t.isDone).length} tasks remaining', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17))),
        ...tasks.map((task) => Card(
          color: Colors.white,
          child: CheckboxListTile(
            value: task.isDone,
            onChanged: (value) async {
              tasks = tasks.map((t) => t.id == task.id ? t.copyWith(isDone: value ?? false) : t).toList();
              await persist();
            },
            title: Text(task.title, style: TextStyle(decoration: task.isDone ? TextDecoration.lineThrough : null, fontWeight: FontWeight.w600)),
            subtitle: Text('${task.category} • Due ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}'),
            secondary: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () async { tasks.removeWhere((t) => t.id == task.id); await persist(); }),
          ),
        )),
      ],
    ),
  );
}
