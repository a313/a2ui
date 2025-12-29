import 'package:flutter/material.dart';

class ExerciseWidget extends StatelessWidget {
  final String title;
  final List<Widget> questions;

  const ExerciseWidget({
    super.key,
    required this.title,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16, width: double.infinity),
        // Questions
        Wrap(
          spacing: 32,
          runSpacing: 16,
          alignment: .spaceEvenly,
          runAlignment: .spaceEvenly,

          children: questions,
        ),
      ],
    );
  }
}
