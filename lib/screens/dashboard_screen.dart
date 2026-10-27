import 'package:flutter/material.dart';
import '../services/local_store.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocalStore.syncNotifier,
      builder: (context, _) {
        final tasks = LocalStore.loadTasks();
        final apps = LocalStore.loadApplications();
        final pending = tasks.where((t) => !t.isDone).length;
        final completed = tasks.where((t) => t.isDone).length;
        final theme = Theme.of(context);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.colorScheme.primary, const Color(0xFF8588FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'YOUR SEMESTER, IN CONTROL',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Small steps.\nBig outcomes.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Plan your work, prepare for placements, and keep moving forward.',
                    style: TextStyle(color: Colors.white, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your overview',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: _MetricCard(
                  label: 'Pending tasks',
                  value: '$pending',
                  icon: Icons.pending_actions,
                  color: const Color(0xFFFFA726),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  label: 'Completed',
                  value: '$completed',
                  icon: Icons.task_alt,
                  color: const Color(0xFF26A69A),
                ),
              ),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: _MetricCard(
                  label: 'Applications',
                  value: '${apps.length}',
                  icon: Icons.business_center,
                  color: const Color(0xFF5B5FEF),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: _MetricCard(
                  label: 'Skills tracked',
                  value: '5',
                  icon: Icons.auto_graph,
                  color: Color(0xFFEC6D9B),
                ),
              ),
            ]),
            const SizedBox(height: 22),
            const Text(
              'Coming up',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            if (tasks.where((t) => !t.isDone).isEmpty)
              const Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: Color(0xFF26A69A)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'All caught up! No pending tasks.',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...tasks.where((t) => !t.isDone).take(3).map(
                    (t) => Card(
                      child: ListTile(
                        leading:
                            const CircleAvatar(child: Icon(Icons.event_note)),
                        title: Text(t.title,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(
                            '${t.category} • Due ${t.dueDate.day}/${t.dueDate.month}'),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    ),
                  ),
            const SizedBox(height: 8),
            const Text(
              'Tip: Keep tasks small and specific so progress is easy to measure.',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _MetricCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, color: color, size: 25),
            const SizedBox(height: 12),
            Text(value,
                style:
                    const TextStyle(fontSize: 27, fontWeight: FontWeight.w800)),
            Text(label,
                style: const TextStyle(color: Colors.black54, fontSize: 12)),
          ]),
        ),
      );
}
