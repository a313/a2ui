import 'package:a2ui/ds/ds_button.dart';
import 'package:a2ui/ds/ds_number_input.dart';
import 'package:a2ui/features/math/math_models.dart';
import 'package:a2ui/features/math/math_page.dart';
import 'package:a2ui/theme/app_colors.dart';
import 'package:a2ui/widgets/maths/operation_widget.dart';
import 'package:flutter/material.dart';

class MathConfigPage extends StatefulWidget {
  const MathConfigPage({super.key});

  @override
  State<MathConfigPage> createState() => _MathConfigPageState();
}

class _MathConfigPageState extends State<MathConfigPage> {
  final Set<MathOperation> _operations = {
    MathOperation.add,
    MathOperation.subtract,
  };
  int _maxValue = 10;
  int _numberCount = 2;
  double _questionCount = 10;
  bool _randomBlank = false;

  void _toggleOperation(MathOperation operation) {
    setState(() {
      if (_operations.contains(operation)) {
        if (_operations.length > 1) {
          _operations.remove(operation);
        }
      } else {
        _operations.add(operation);
      }
    });
  }

  void _startExercise() {
    final config = MathConfig(
      operations: _operations,
      maxValue: _maxValue,
      numberCount: _numberCount,
      questionCount: _questionCount.round(),
      randomBlank: _randomBlank,
    );

    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => MathPage(config: config)));
  }

  @override
  Widget build(BuildContext context) {
    final canStart = _operations.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Cấu hình bài tập')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chọn phép toán',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          _OperationChip(
                            label: 'Cộng (+)',
                            isSelected: _operations.contains(MathOperation.add),
                            onTap: () => _toggleOperation(MathOperation.add),
                          ),
                          _OperationChip(
                            label: 'Trừ (-)',
                            isSelected: _operations.contains(
                              MathOperation.subtract,
                            ),
                            onTap: () => _toggleOperation(
                              MathOperation.subtract,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Phạm vi số',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        children: [10, 20, 30, 40, 50].map((value) {
                          return ChoiceChip(
                            label: Text('≤ $value'),
                            selected: _maxValue == value,
                            onSelected: (_) {
                              setState(() {
                                _maxValue = value;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Số lượng các số',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: DsNumberInput(
                              value: _numberCount,
                              min: 2,
                              max: 5,
                              onChanged: (value) {
                                setState(() {
                                  _numberCount = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Số lượng bài tập',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: _questionCount,
                        min: 10,
                        max: 100,
                        divisions: 90,
                        label: _questionCount.round().toString(),
                        onChanged: (value) {
                          setState(() {
                            _questionCount = value;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_questionCount.round()} câu',
                        style: const TextStyle(color: AppColors.n600),
                      ),
                      const SizedBox(height: 24),
                      SwitchListTile(
                        title: const Text(
                          'Vị trí ẩn số ngẫu nhiên',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: const Text('Ví dụ: ? + 3 = 5 hoặc 2 + ? = 5'),
                        contentPadding: EdgeInsets.zero,
                        value: _randomBlank,
                        onChanged: (value) {
                          setState(() {
                            _randomBlank = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              DsPinnedBottom(
                child: DsButton.primary(
                  title: 'Bắt đầu',
                  onPressed: canStart ? _startExercise : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OperationChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OperationChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.p50,
      checkmarkColor: AppColors.p300,
    );
  }
}
