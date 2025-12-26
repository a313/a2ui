import 'package:a2ui/ds/ds_comparison_popup.dart';
import 'package:a2ui/ds/ds_number_input_popup.dart';
import 'package:a2ui/widgets/maths/comparison_widget.dart';
import 'package:a2ui/widgets/maths/operation_widget.dart';
import 'package:flutter/material.dart';

class TestWidgets extends StatefulWidget {
  const TestWidgets({super.key});

  @override
  State<TestWidgets> createState() => _TestWidgetsState();
}

class _TestWidgetsState extends State<TestWidgets> {
  int? answer1;
  int? answer2;
  int? answer3;
  int? answer4;

  ComparisonOperator? comparisonAnswer1;
  ComparisonOperator? comparisonAnswer2;
  ComparisonOperator? comparisonAnswer3;

  void _showNumberInput(Offset position, int? value, Function(int) onConfirm) {
    context.showNumberInputPopup(
      position: position,
      initialValue: value,
      onConfirm: onConfirm,
    );
  }

  void _showComparisonInput(
    Offset position,
    Function(ComparisonOperator) onSelect,
  ) {
    context.showComparisonPopup(position: position, onSelect: onSelect);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Widgets')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 110.0),
              child: OperationWidget(
                firstNumber: 4,
                secondNumber: 3,
                operation: .add,
                userAnswer: answer1,
                onTap: (offset) {
                  _showNumberInput(offset, answer1, (value) {
                    setState(() => answer1 = value);
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            OperationWidget(
              firstNumber: 8,
              secondNumber: 2,
              operation: .subtract,
              userAnswer: answer2,
              onTap: (offset) {
                _showNumberInput(offset, answer2, (value) {
                  setState(() => answer2 = value);
                });
              },
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 120.0),
              child: OperationWidget(
                firstNumber: 4,
                secondNumber: 3,
                operation: .multiply,
                userAnswer: answer3,
                onTap: (offset) {
                  _showNumberInput(offset, answer3, (value) {
                    setState(() => answer3 = value);
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            OperationWidget(
              firstNumber: 12,
              secondNumber: 3,
              operation: .divide,
              userAnswer: answer4,
              onTap: (offset) {
                _showNumberInput(offset, answer4, (value) {
                  setState(() => answer4 = value);
                });
              },
            ),
            const SizedBox(height: 48),
            const Divider(thickness: 2),
            const SizedBox(height: 24),
            const Text(
              'So sánh số',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ComparisonWidget(
              firstNumber: 5,
              secondNumber: 3,
              userAnswer: comparisonAnswer1,
              onTap: (offset) {
                _showComparisonInput(offset, (operator) {
                  setState(() => comparisonAnswer1 = operator);
                });
              },
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 100.0),
              child: ComparisonWidget(
                firstNumber: 2,
                secondNumber: 8,
                userAnswer: comparisonAnswer2,
                onTap: (offset) {
                  _showComparisonInput(offset, (operator) {
                    setState(() => comparisonAnswer2 = operator);
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(right: 80.0),
              child: ComparisonWidget(
                firstNumber: 7,
                secondNumber: 7,
                userAnswer: comparisonAnswer3,
                onTap: (offset) {
                  _showComparisonInput(offset, (operator) {
                    setState(() => comparisonAnswer3 = operator);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
