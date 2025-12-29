import 'package:a2ui/ds/ds_comparison_popup.dart';
import 'package:a2ui/ds/ds_number_input_popup.dart';
import 'package:a2ui/ds/ds_operation_popup.dart';
import 'package:a2ui/widgets/maths/comparison_widget.dart';
import 'package:a2ui/widgets/maths/counting_operation_widget.dart';
import 'package:a2ui/widgets/maths/operation_widget.dart';
import 'package:a2ui/widgets/shared/exercise_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  // Counting operation 1
  int? counting1First;
  MathOperation? counting1Operation;
  int? counting1Second;
  int? counting1Final;

  // Counting operation 2
  int? counting2First;
  MathOperation? counting2Operation;
  int? counting2Second;
  int? counting2Final;

  // Counting operation 3
  int? counting3First;
  MathOperation? counting3Operation;
  int? counting3Second;
  int? counting3Final;

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

  void _showOperationInput(Offset position, Function(MathOperation) onSelect) {
    context.showOperationPopup(position: position, onSelect: onSelect);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/parent'),
        ),
        title: const Text('Test Widgets'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ExerciseWidget(
              title: 'So sánh',
              questions: [
                OperationWidget(
                  firstNumber: 4,
                  secondNumber: 3,
                  operation: MathOperation.add,
                  userAnswer: answer1,
                  onTap: (offset) {
                    _showNumberInput(offset, answer1, (value) {
                      setState(() => answer1 = value);
                    });
                  },
                ),
                OperationWidget(
                  firstNumber: 8,
                  secondNumber: 2,
                  operation: MathOperation.subtract,
                  userAnswer: answer2,
                  onTap: (offset) {
                    _showNumberInput(offset, answer2, (value) {
                      setState(() => answer2 = value);
                    });
                  },
                ),
                OperationWidget(
                  firstNumber: 4,
                  secondNumber: 3,
                  operation: MathOperation.multiply,
                  userAnswer: answer3,
                  onTap: (offset) {
                    _showNumberInput(offset, answer3, (value) {
                      setState(() => answer3 = value);
                    });
                  },
                ),
                OperationWidget(
                  firstNumber: 12,
                  secondNumber: 3,
                  operation: MathOperation.divide,
                  userAnswer: answer4,
                  onTap: (offset) {
                    _showNumberInput(offset, answer4, (value) {
                      setState(() => answer4 = value);
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(thickness: 2),
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
            const SizedBox(height: 24),
            const Divider(thickness: 2),
            const SizedBox(height: 24),
            // Counting Operations
            const Text(
              'Counting Operations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CountingOperationWidget(
                    firstNumber: 5,
                    firstSymbol: '🍊',
                    operation: MathOperation.add,
                    secondNumber: 2,
                    secondSymbol: '🍎',
                    userFirstAnswer: counting1First,
                    userOperationAnswer: counting1Operation,
                    userSecondAnswer: counting1Second,
                    userFinalAnswer: counting1Final,
                    onTapFirstAnswer: (offset) {
                      _showNumberInput(offset, counting1First, (value) {
                        setState(() => counting1First = value);
                      });
                    },
                    onTapOperationAnswer: (offset) {
                      _showOperationInput(offset, (operation) {
                        setState(() => counting1Operation = operation);
                      });
                    },
                    onTapSecondAnswer: (offset) {
                      _showNumberInput(offset, counting1Second, (value) {
                        setState(() => counting1Second = value);
                      });
                    },
                    onTapFinalAnswer: (offset) {
                      _showNumberInput(offset, counting1Final, (value) {
                        setState(() => counting1Final = value);
                      });
                    },
                  ),
                ),
                Expanded(
                  child: CountingOperationWidget(
                    firstNumber: 4,
                    firstSymbol: '❤️',
                    operation: MathOperation.add,
                    secondNumber: 6,
                    secondSymbol: '💙',
                    userFirstAnswer: counting3First,
                    userOperationAnswer: counting3Operation,
                    userSecondAnswer: counting3Second,
                    userFinalAnswer: counting3Final,
                    onTapFirstAnswer: (offset) {
                      _showNumberInput(offset, counting3First, (value) {
                        setState(() => counting3First = value);
                      });
                    },
                    onTapOperationAnswer: (offset) {
                      _showOperationInput(offset, (operation) {
                        setState(() => counting3Operation = operation);
                      });
                    },
                    onTapSecondAnswer: (offset) {
                      _showNumberInput(offset, counting3Second, (value) {
                        setState(() => counting3Second = value);
                      });
                    },
                    onTapFinalAnswer: (offset) {
                      _showNumberInput(offset, counting3Final, (value) {
                        setState(() => counting3Final = value);
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            CountingOperationWidget(
              firstNumber: 8,
              firstSymbol: '⭐',
              operation: MathOperation.subtract,
              secondNumber: 3,
              secondSymbol: '⭐',
              userFirstAnswer: counting2First,
              userOperationAnswer: counting2Operation,
              userSecondAnswer: counting2Second,
              userFinalAnswer: counting2Final,
              onTapFirstAnswer: (offset) {
                _showNumberInput(offset, counting2First, (value) {
                  setState(() => counting2First = value);
                });
              },
              onTapOperationAnswer: (offset) {
                _showOperationInput(offset, (operation) {
                  setState(() => counting2Operation = operation);
                });
              },
              onTapSecondAnswer: (offset) {
                _showNumberInput(offset, counting2Second, (value) {
                  setState(() => counting2Second = value);
                });
              },
              onTapFinalAnswer: (offset) {
                _showNumberInput(offset, counting2Final, (value) {
                  setState(() => counting2Final = value);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
