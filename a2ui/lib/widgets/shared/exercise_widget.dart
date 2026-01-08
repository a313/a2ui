import 'package:a2ui/ds/ds_button.dart';
import 'package:flutter/material.dart';

class ExerciseWidget<T extends Widget> extends StatelessWidget {
  final String title;
  final List<T> questions;
  final String? finishButtonLabel;
  final VoidCallback? onFinish;

  const ExerciseWidget({
    super.key,
    required this.title,
    required this.questions,
    this.finishButtonLabel,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 8, vertical: 12),
      child: Column(
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
          const SizedBox(height: 16, width: double.infinity),
          DsButton.primary(
            title: finishButtonLabel ?? 'Hoàn tất',
            onPressed: onFinish,
          ),
        ],
      ),
    );
  }
}
