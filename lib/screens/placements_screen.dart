import 'package:flutter/material.dart';
import '../models/placement_application.dart';
import '../services/local_store.dart';

const stages = [
  'Interested',
  'Applied',
  'Assessment',
  'Interview',
  'Offer',
  'Rejected'
];

class PlacementsScreen extends StatefulWidget {
  const PlacementsScreen({super.key});
  @override
  State<PlacementsScreen> createState() => _PlacementsScreenState();
}

class _PlacementsScreenState extends State<PlacementsScreen> {
  late List<PlacementApplication> apps;
  @override
  void initState() {
    super.initState();
    apps = LocalStore.loadApplications();
  }

  Future<void> save() async {
    await LocalStore.saveApplications(apps);
    if (mounted) setState(() {});
  }

  Future<void> addApplication() async {
    final company = TextEditingController();
    final role = TextEditingController();
    try {
      String stage = 'Interested';
      final ok = await showDialog<bool>(
          context: context,
          builder: (context) => StatefulBuilder(
              builder: (context, setDialog) => AlertDialog(
                    title: const Text('Track a placement'),
                    content: SingleChildScrollView(
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                      TextField(
                          controller: company,
                          decoration:
                              const InputDecoration(labelText: 'Company name')),
                      const SizedBox(height: 12),
                      TextField(
                          controller: role,
                          decoration: const InputDecoration(labelText: 'Role')),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                          initialValue: stage,
                          decoration: const InputDecoration(
                              labelText: 'Application stage'),
                          items: stages
                              .map((s) =>
                                  DropdownMenuItem(value: s, child: Text(s)))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) setDialog(() => stage = v);
                          }),
                    ])),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel')),
                      FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Save'))
                    ],
                  )));
      if (ok == true &&
          company.text.trim().isNotEmpty &&
          role.text.trim().isNotEmpty) {
        apps.insert(
            0,
            PlacementApplication(
                id: DateTime.now().microsecondsSinceEpoch.toString(),
                company: company.text.trim(),
                role: role.text.trim(),
                stage: stage,
                appliedOn: DateTime.now()));
        await save();
      }
    } finally {
      company.dispose();
      role.dispose();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton.extended(
            onPressed: addApplication,
            icon: const Icon(Icons.add),
            label: const Text('Add application')),
        body: apps.isEmpty
            ? const Center(
                child: Text('Track your first placement application.'))
            : ListView(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 90),
                children: [
                  const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Placement tracker',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800))),
                  ...apps.map((app) => Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: CircleAvatar(
                              child: Text(app.company.isNotEmpty
                                  ? app.company[0].toUpperCase()
                                  : '?')),
                          title: Text(app.company,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              '${app.role}\nAdded ${app.appliedOn.day}/${app.appliedOn.month}/${app.appliedOn.year}'),
                          isThreeLine: true,
                          trailing: PopupMenuButton<String>(
                            initialValue: app.stage,
                            tooltip: 'Change stage',
                            onSelected: (value) async {
                              apps = apps
                                  .map((a) => a.id == app.id
                                      ? a.copyWith(stage: value)
                                      : a)
                                  .toList();
                              await save();
                            },
                            itemBuilder: (context) => stages
                                .map((s) =>
                                    PopupMenuItem(value: s, child: Text(s)))
                                .toList(),
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 9, vertical: 6),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(app.stage,
                                    style: const TextStyle(fontSize: 11))),
                          ),
                        ),
                      )),
                ],
              ),
      );
}
