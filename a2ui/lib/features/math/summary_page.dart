import 'package:a2ui/ds/ds_button.dart';
import 'package:a2ui/features/math/math_models.dart';
import 'package:a2ui/widgets/shared/answer_box.dart';
import 'package:a2ui/widgets/shared/number_box.dart';
import 'package:a2ui/widgets/shared/operation_symbol.dart';
import 'package:flutter/material.dart';

class SummaryPage extends StatelessWidget {
  final MathConfig config;
  final List<MathQuestion> questions;
  final List<int?> answers;

  const SummaryPage({
    super.key,
    required this.config,
    required this.questions,
    required this.answers,
  });

  int get correctCount {
    var count = 0;
    for (var i = 0; i < questions.length; i++) {
      if (answers[i] == questions[i].correctAnswer) {
        count++;
      }
    }
    return count;
  }

  double get score10 {
    if (questions.isEmpty) return 0;
    return (correctCount / questions.length) * 10;
  }

  String get encouragementText {
    if (questions.isEmpty) return 'Bắt đầu làm bài để nhận kết quả nhé!';
    if (score10 >= 9) return 'Xuất sắc! Con làm rất tốt!';
    if (score10 >= 7) return 'Tuyệt vời! Cố gắng thêm chút nữa nhé!';
    if (score10 >= 5) return 'Khá tốt! Luyện thêm là sẽ giỏi hơn!';
    return 'Cố gắng lên! Mình luyện thêm để tiến bộ nhé!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tổng kết')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Điểm số:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Text(
                          score10.toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    encouragementText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Kết quả: $correctCount/${questions.length} câu đúng',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Số lượng số: ${config.numberCount} • Phạm vi: ≤ ${config.maxValue}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  final userAnswer = answers[index];
                  final isCorrect = userAnswer == question.correctAnswer;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            ..._buildQuestionParts(question),
                            Text(
                              '=',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            AnswerBox(
                              correctAnswer: question.correctAnswer.toString(),
                              userAnswer: userAnswer?.toString(),
                              onTap: null,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isCorrect
                              ? 'Đúng'
                              : 'Sai • Đáp án đúng: ${question.correctAnswer}',
                          style: TextStyle(
                            color: isCorrect ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DsPinnedBottom(
        child: DsButton.secondary(
          title: 'Quay lại cấu hình',
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
    );
  }

  List<Widget> _buildQuestionParts(MathQuestion question) {
    final parts = <Widget>[];
    for (var i = 0; i < question.numbers.length; i++) {
      parts.add(NumberBox(number: question.numbers[i]));
      if (i < question.operations.length) {
        parts.add(OperationSymbol(operation: question.operations[i]));
      }
    }
    return parts;
  }
}
