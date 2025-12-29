import 'package:a2ui/features/parents/parent_page.dart';
import 'package:a2ui/features/test_widgets.dart';
import 'package:a2ui/src/travel_planner_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Router configuration for the app
final router = GoRouter(
  initialLocation: '/travel',
  routes: [
    GoRoute(
      path: '/travel',
      name: 'travel',
      builder: (context, state) => TravelPlannerPage(),
    ),
    GoRoute(
      path: '/test',
      name: 'test',
      builder: (context, state) => const TestWidgets(),
    ),
    GoRoute(
      path: '/parent',
      name: 'parent',
      builder: (context, state) => const ParentPage(),
    ),
    GoRoute(
      path: '/child',
      name: 'child',
      builder: (context, state) => const ChildPage(),
    ),
  ],
);

/// Child page placeholder
class ChildPage extends StatelessWidget {
  const ChildPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Child Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Child Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/parent'),
              child: const Text('Go to Parent Page'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.go('/test'),
              child: const Text('Go to Test Page'),
            ),
          ],
        ),
      ),
    );
  }
}
