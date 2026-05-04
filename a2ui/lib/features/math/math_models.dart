import 'dart:math';

import 'package:a2ui/widgets/maths/operation_widget.dart';

class MathConfig {
  final Set<MathOperation> operations;
  final int maxValue;
  final int numberCount;
  final int questionCount;
  final bool randomBlank;

  const MathConfig({
    required this.operations,
    required this.maxValue,
    required this.numberCount,
    required this.questionCount,
    this.randomBlank = false,
  }) : assert(numberCount >= 2 && numberCount <= 5);

  bool get isValid => operations.isNotEmpty;

  List<MathQuestion> generateQuestions({int? seed}) {
    final random = seed == null ? Random() : Random(seed);
    return List.generate(questionCount, (_) {
      return _generateQuestion(random);
    });
  }

  MathQuestion _generateQuestion(Random random) {
    while (true) {
      final ops = <MathOperation>[];
      final numbers = <int>[];

      var current = random.nextInt(maxValue + 1);
      numbers.add(current);

      var valid = true;

      for (var i = 0; i < numberCount - 1; i++) {
        final operation = _pickOperation(random);
        ops.add(operation);

        switch (operation) {
          case MathOperation.add:
            final maxAdd = maxValue - current;
            if (maxAdd < 0) {
              valid = false;
            } else {
              final next = random.nextInt(maxAdd + 1);
              numbers.add(next);
              current += next;
            }
            break;
          case MathOperation.subtract:
            final maxSub = current;
            if (maxSub < 0) {
              valid = false;
            } else {
              final next = random.nextInt(maxSub + 1);
              numbers.add(next);
              current -= next;
            }
            break;
          case MathOperation.multiply:
          case MathOperation.divide:
            final next = random.nextInt(maxValue + 1);
            numbers.add(next);
            current = _applyOperation(current, next, operation);
            if (current < 0 || current > maxValue) {
              valid = false;
            }
            break;
        }

        if (!valid) break;
      }

      if (valid && current >= 0 && current <= maxValue) {
        final blankIndex = randomBlank ? random.nextInt(numberCount + 1) : numberCount;
        return MathQuestion(
          numbers: numbers,
          operations: ops,
          result: current,
          blankIndex: blankIndex,
        );
      }
    }
  }

  MathOperation _pickOperation(Random random) {
    final ops = operations.toList();
    return ops[random.nextInt(ops.length)];
  }

  static int _applyOperation(int left, int right, MathOperation operation) {
    switch (operation) {
      case MathOperation.add:
        return left + right;
      case MathOperation.subtract:
        return left - right;
      case MathOperation.multiply:
        return left * right;
      case MathOperation.divide:
        return right == 0 ? left : left ~/ right;
    }
  }
}

class MathQuestion {
  final List<int> numbers;
  final List<MathOperation> operations;
  final int result;
  final int blankIndex;

  const MathQuestion({
    required this.numbers,
    required this.operations,
    required this.result,
    required this.blankIndex,
  }) : assert(numbers.length >= 2),
       assert(numbers.length == operations.length + 1),
       assert(blankIndex >= 0 && blankIndex <= numbers.length);

  int get correctAnswer => blankIndex == numbers.length ? result : numbers[blankIndex];
}
