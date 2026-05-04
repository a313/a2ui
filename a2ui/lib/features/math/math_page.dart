import 'package:a2ui/ds/ds_button.dart';
import 'package:a2ui/features/math/math_models.dart';
import 'package:a2ui/features/math/summary_page.dart';
import 'package:a2ui/widgets/shared/number_box.dart';
import 'package:a2ui/widgets/shared/operation_symbol.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MathPage extends StatefulWidget {
  final MathConfig config;

  const MathPage({super.key, required this.config});

  @override
  State<MathPage> createState() => _MathPageState();
}

class _MathPageState extends State<MathPage> {
  late final List<MathQuestion> _questions;
  late final List<int?> _answers;
  int _currentIndex = 0;
  late final TextEditingController _answerController;
  late final FocusNode _answerFocusNode;

  @override
  void initState() {
    super.initState();
    _questions = widget.config.generateQuestions();
    _answers = List<int?>.filled(_questions.length, null);
    _answerController = TextEditingController();
    _answerFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _answerFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _answerController.dispose();
    _answerFocusNode.dispose();
    super.dispose();
  }

  bool get _isAnswered => _answers[_currentIndex] != null;

  void _submitAnswer(int value) {
    if (_answers[_currentIndex] != null) return;
    setState(() {
      _answers[_currentIndex] = value;
    });
  }

  void _goNext() {
    if (!_isAnswered) {
      _handleSubmit(context, _answerController.text);
    }
    if (!_isAnswered) return;
    if (_currentIndex == _questions.length - 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => SummaryPage(
            config: widget.config,
            questions: _questions,
            answers: _answers,
          ),
        ),
      );
      return;
    }

    setState(() {
      _currentIndex += 1;
      _answerController.text = '';
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _answerFocusNode.requestFocus();
      }
    });
  }

  void _handleSubmit(BuildContext context, String value) {
    if (_isAnswered) return;
    final parsed = int.tryParse(value.trim());
    if (parsed == null) return;
    _submitAnswer(parsed);
    _answerController.text = parsed.toString();
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Bài tập toán')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Câu ${_currentIndex + 1}/${_questions.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: progress),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: _QuestionView(
                  question: question,
                  controller: _answerController,
                  focusNode: _answerFocusNode,
                  enabled: !_isAnswered,
                  onSubmitted: (value) => _handleSubmit(context, value),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _answerController,
                builder: (context, value, _) {
                  final canContinue =
                      _isAnswered || value.text.trim().isNotEmpty;
                  return DsButton.primary(
                    title: _currentIndex == _questions.length - 1
                        ? 'Xem kết quả'
                        : 'Tiếp tục',
                    onPressed: canContinue ? _goNext : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionView extends StatelessWidget {
  final MathQuestion question;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final ValueChanged<String> onSubmitted;

  const _QuestionView({
    required this.question,
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.onSubmitted,
  });

  Widget _buildInput() {
    return SizedBox(
      key: const ValueKey('math_answer_input'),
      width: 140,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: true,
        enabled: enabled,
        readOnly: !enabled,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: '?',
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];

    // Build the expression part (before =)
    for (var i = 0; i < question.numbers.length; i++) {
      if (i == question.blankIndex) {
        items.add(_buildInput());
      } else {
        items.add(NumberBox(number: question.numbers[i]));
      }

      if (i < question.operations.length) {
        items.add(OperationSymbol(operation: question.operations[i]));
      }
    }

    // Add the = symbol
    items.add(
      Text(
        '=',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
    );

    // Add the result part (after =)
    if (question.blankIndex == question.numbers.length) {
      items.add(_buildInput());
    } else {
      items.add(NumberBox(number: question.result));
    }

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: items,
    );
  }
}
