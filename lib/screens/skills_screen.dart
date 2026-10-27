import 'package:flutter/material.dart';
import '../services/local_store.dart';

class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});
  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  late Map<String, double> skills;

  @override
  void initState() {
    super.initState();
    skills = LocalStore.loadSkills();
  }

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(22)),
            child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.track_changes, size: 34),
                  SizedBox(height: 12),
                  Text('Build your skill stack',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                  SizedBox(height: 6),
                  Text(
                      'Adjust each slider as you progress. These are self-assessed learning levels, not test scores.'),
                ]),
          ),
          const SizedBox(height: 18),
          ...skills.keys.map((skill) => Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(
                              child: Text(skill,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700))),
                          Text('${(skills[skill]! * 100).round()}%',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold)),
                        ]),
                        Slider(
                            value: skills[skill]!,
                            min: 0,
                            max: 1,
                            divisions: 20,
                            onChanged: (value) {
                              setState(() => skills[skill] = value);
                              LocalStore.saveSkills(skills);
                            }),
                        LinearProgressIndicator(
                            value: skills[skill],
                            minHeight: 5,
                            borderRadius: BorderRadius.circular(8)),
                      ]),
                ),
              )),
          const SizedBox(height: 12),
          const Text(
              'Tip: Update these self-assessments honestly as you practice.',
              style: TextStyle(color: Colors.black54)),
        ],
      );
}
