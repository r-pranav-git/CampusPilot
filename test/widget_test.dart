
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:campuspilot/main.dart';
import 'package:campuspilot/models/campus_task.dart';
import 'package:campuspilot/models/placement_application.dart';
import 'package:campuspilot/services/local_store.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStore.init();
  });

  testWidgets(
    'CampusPilot app starts and displays the dashboard',
    (WidgetTester tester) async {
      await tester.pumpWidget(const CampusPilotApp());
      await tester.pumpAndSettle();

      expect(find.text('CampusPilot'), findsOneWidget);
      expect(find.text('Your overview'), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationDestination), findsNWidgets(4));

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Tasks'), findsOneWidget);
      expect(find.text('Placements'), findsOneWidget);
      expect(find.text('Skills'), findsOneWidget);
    },
  );

  testWidgets(
    'Dashboard updates when tasks change',
    (WidgetTester tester) async {
      await LocalStore.saveTasks([]);

      await tester.pumpWidget(const CampusPilotApp());
      await tester.pumpAndSettle();

      expect(find.text('Pending tasks'), findsOneWidget);
      expect(find.text('0'), findsWidgets);

      await LocalStore.saveTasks([
        CampusTask(
          id: 'test_sync_task',
          title: 'Reactive Test Task',
          category: 'Study',
          dueDate: DateTime.now().add(const Duration(days: 2)),
        ),
      ]);

      await tester.pumpAndSettle();

      expect(find.text('1'), findsWidgets);

      final taskFinder = find.text('Reactive Test Task');

      await tester.scrollUntilVisible(
        taskFinder,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(taskFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Dashboard updates when placement applications change',
    (WidgetTester tester) async {
      await LocalStore.saveApplications([]);

      await tester.pumpWidget(const CampusPilotApp());
      await tester.pumpAndSettle();

      expect(find.text('Applications'), findsOneWidget);

      await LocalStore.saveApplications([
        PlacementApplication(
          id: 'test_sync_app',
          company: 'Cloud Corp',
          role: 'SRE Intern',
          stage: 'Interview',
          appliedOn: DateTime.now(),
        ),
      ]);

      await tester.pumpAndSettle();

      expect(find.text('Applications'), findsOneWidget);

      // The dashboard displays the application count, not company names.
      expect(find.text('Cloud Corp'), findsNothing);
      expect(find.text('1'), findsWidgets);
    },
  );

 
testWidgets(
  'Dashboard displays an empty state with no pending tasks',
  (WidgetTester tester) async {
    await LocalStore.saveTasks([]);

    expect(LocalStore.loadTasks(), isEmpty);

    await tester.pumpWidget(const CampusPilotApp());
    await tester.pumpAndSettle();

    // Verify the dashboard heading before scrolling.
    expect(find.text('Your overview'), findsOneWidget);

    final scrollable = find.byType(Scrollable).first;

    // Scroll until the "Coming up" section is visible.
    await tester.scrollUntilVisible(
      find.text('Coming up'),
      200,
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();

    expect(find.text('Coming up'), findsOneWidget);

    // Scroll until the empty-state message is visible.
    final emptyStateFinder =
        find.text('All caught up! No pending tasks.');

    await tester.scrollUntilVisible(
      emptyStateFinder,
      200,
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();

    expect(emptyStateFinder, findsOneWidget);
  },
);

  testWidgets(
    'Skills progress is restored from storage',
    (WidgetTester tester) async {
      final initialSkills = LocalStore.loadSkills();

      expect(initialSkills['Dart & Flutter'], isNotNull);

      final modifiedSkills = Map<String, double>.from(initialSkills);
      modifiedSkills['Dart & Flutter'] = 0.95;

      await LocalStore.saveSkills(modifiedSkills);

      expect(
        LocalStore.loadSkills()['Dart & Flutter'],
        equals(0.95),
      );

      await tester.pumpWidget(const CampusPilotApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Skills'));
      await tester.pumpAndSettle();

      expect(find.text('95%'), findsOneWidget);
    },
  );
}
