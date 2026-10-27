import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/campus_task.dart';
import '../models/placement_application.dart';

class LocalStore {
  static late SharedPreferences _prefs;
  static const _tasksKey = 'campuspilot_tasks';
  static const _appsKey = 'campuspilot_applications';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static List<CampusTask> loadTasks() {
    final raw = _prefs.getString(_tasksKey);
    if (raw == null) return _sampleTasks();
    try {
      return (jsonDecode(raw) as List)
          .map((e) => CampusTask.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return _sampleTasks();
    }
  }

  static Future<void> saveTasks(List<CampusTask> tasks) =>
      _prefs.setString(_tasksKey, jsonEncode(tasks.map((e) => e.toJson()).toList()));

  static List<PlacementApplication> loadApplications() {
    final raw = _prefs.getString(_appsKey);
    if (raw == null) return _sampleApplications();
    try {
      return (jsonDecode(raw) as List)
          .map((e) => PlacementApplication.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return _sampleApplications();
    }
  }

  static Future<void> saveApplications(List<PlacementApplication> apps) =>
      _prefs.setString(_appsKey, jsonEncode(apps.map((e) => e.toJson()).toList()));

  static List<CampusTask> _sampleTasks() {
    final now = DateTime.now();
    return [
      CampusTask(id: 't1', title: 'Complete Flutter lab record', category: 'Academic', dueDate: now.add(const Duration(days: 1))),
      CampusTask(id: 't2', title: 'Practice 2 coding problems', category: 'Placement', dueDate: now.add(const Duration(days: 2))),
      CampusTask(id: 't3', title: 'Revise data structures', category: 'Study', dueDate: now.add(const Duration(days: 3))),
    ];
  }

  static List<PlacementApplication> _sampleApplications() => [
    PlacementApplication(id: 'a1', company: 'Example Technologies', role: 'Software Developer', stage: 'Applied', appliedOn: DateTime.now()),
    PlacementApplication(id: 'a2', company: 'Sample Systems', role: 'Graduate Engineer Trainee', stage: 'Assessment', appliedOn: DateTime.now().subtract(const Duration(days: 3))),
  ];
}
