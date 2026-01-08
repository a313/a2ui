// Copyright 2025 The Flutter Authors.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:ui';

import 'package:a2ui/genui/number_input.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

/// Enum định nghĩa các dạng bài toán cho trẻ 4-6 tuổi
enum MathType {
  comparison(
    id: 'comparison',
    label: 'So sánh',
    description: 'So sánh lớn hơn, nhỏ hơn, bằng nhau',
    icon: Icons.compare_arrows,
  ),
  operation(
    id: 'operation',
    label: 'Phép tính',
    description: 'Cộng trừ đơn giản',
    icon: Icons.calculate,
  ),
  completeMath(
    id: 'completeMath',
    label: 'Tạo phép toán',
    description: 'Từ hình ảnh tạo phép toán phù hợp',
    icon: Icons.format_list_numbered,
  );

  const MathType({
    required this.id,
    required this.label,
    required this.description,
    required this.icon,
  });

  final String id;
  final String label;
  final String description;
  final IconData icon;
}

final _mathTypeSchema = S.object(
  properties: {
    'title': A2uiSchemas.stringReference(
      description: 'An optional title to display above the math type list.',
    ),
    'confirmButtonLabel': A2uiSchemas.stringReference(
      description:
          'The label for the confirm button. Defaults to "Tiếp tục" if not provided.',
    ),
    'confirmAction': A2uiSchemas.action(
      description:
          'The action to perform when the confirm button is tapped. '
          'The context for this action will include "selectedMathTypes" - '
          'an object mapping math type IDs to their exercise counts '
          '(e.g., {"comparison": 5, "completeMath": 3}).',
    ),
    'minExercises': S.integer(
      description: 'Minimum number of exercises per type (default: 1).',
    ),
    'maxExercises': S.integer(
      description: 'Maximum number of exercises per type (default: 20).',
    ),
    'defaultExercises': S.integer(
      description:
          'Default number of exercises when selecting a type (default: 5).',
    ),
  },
  required: ['confirmAction'],
);

/// A widget that presents a list of math exercise types that users can
/// select/deselect by tapping, with a number input for each selected type
/// to specify how many exercises to create.
///
/// This component is ideal for configuring math exercises, allowing parents
/// to choose which types of math problems (comparison, counting, operation)
/// and how many of each type they want to create.
final mathTypeSelector = CatalogItem(
  name: 'MathTypeSelector',
  dataSchema: _mathTypeSchema,
  widgetBuilder: (itemContext) {
    final selectorData = _MathTypeSelectorData.fromMap(
      itemContext.data as Map<String, Object?>,
    );

    final ValueNotifier<String?> titleNotifier = itemContext.dataContext
        .subscribeToString(selectorData.title);

    final ValueNotifier<String?> confirmButtonLabelNotifier = itemContext
        .dataContext
        .subscribeToString(selectorData.confirmButtonLabel);

    return ValueListenableBuilder<String?>(
      valueListenable: titleNotifier,
      builder: (builderContext, title, _) {
        return ValueListenableBuilder<String?>(
          valueListenable: confirmButtonLabelNotifier,
          builder: (context, confirmLabel, _) {
            return _MathTypeSelector(
              title: title,
              confirmButtonLabel: confirmLabel ?? 'Tiếp tục',
              confirmAction: selectorData.confirmAction,
              minExercises: selectorData.minExercises ?? 1,
              maxExercises: selectorData.maxExercises ?? 20,
              defaultExercises: selectorData.defaultExercises ?? 5,
              widgetId: itemContext.id,
              dispatchEvent: itemContext.dispatchEvent,
              dataContext: itemContext.dataContext,
            );
          },
        );
      },
    );
  },
  exampleData: [_mathTypeExampleData],
);

extension type _MathTypeSelectorData.fromMap(Map<String, Object?> _json) {
  factory _MathTypeSelectorData({
    JsonMap? title,
    JsonMap? confirmButtonLabel,
    required JsonMap confirmAction,
    int? minExercises,
    int? maxExercises,
    int? defaultExercises,
  }) => _MathTypeSelectorData.fromMap({
    if (title != null) 'title': title,
    if (confirmButtonLabel != null) 'confirmButtonLabel': confirmButtonLabel,
    'confirmAction': confirmAction,
    if (minExercises != null) 'minExercises': minExercises,
    if (maxExercises != null) 'maxExercises': maxExercises,
    if (defaultExercises != null) 'defaultExercises': defaultExercises,
  });

  JsonMap? get title => _json['title'] as JsonMap?;
  JsonMap? get confirmButtonLabel => _json['confirmButtonLabel'] as JsonMap?;
  JsonMap get confirmAction => _json['confirmAction'] as JsonMap? ?? {};
  int? get minExercises => _json['minExercises'] as int?;
  int? get maxExercises => _json['maxExercises'] as int?;
  int? get defaultExercises => _json['defaultExercises'] as int?;
}

class _DesktopAndWebScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class _MathTypeSelector extends StatefulWidget {
  const _MathTypeSelector({
    this.title,
    required this.confirmButtonLabel,
    required this.confirmAction,
    required this.minExercises,
    required this.maxExercises,
    required this.defaultExercises,
    required this.widgetId,
    required this.dispatchEvent,
    required this.dataContext,
  });

  final String? title;
  final String confirmButtonLabel;
  final JsonMap confirmAction;
  final int minExercises;
  final int maxExercises;
  final int defaultExercises;
  final String widgetId;
  final DispatchEventCallback dispatchEvent;
  final DataContext dataContext;

  @override
  State<_MathTypeSelector> createState() => _MathTypeSelectorState();
}

class _MathTypeSelectorState extends State<_MathTypeSelector> {
  // Map from MathType to exercise count
  final Map<MathType, int> _selectedTypes = {};

  void _toggleSelection(MathType type) {
    setState(() {
      if (_selectedTypes.containsKey(type)) {
        _selectedTypes.remove(type);
      } else {
        _selectedTypes[type] = widget.defaultExercises;
      }
    });
  }

  void _updateExerciseCount(MathType type, int count) {
    setState(() {
      _selectedTypes[type] = count;
    });
  }

  void _onConfirm() {
    if (_selectedTypes.isEmpty) return;

    final name = widget.confirmAction['name'] as String;
    final List<Object?> contextDefinition =
        (widget.confirmAction['context'] as List<Object?>?) ?? <Object?>[];
    final JsonMap resolvedContext = resolveContext(
      widget.dataContext,
      contextDefinition,
    );

    // Create a map of type ID to exercise count
    final Map<String, int> selectedMathTypes = {};
    for (final entry in _selectedTypes.entries) {
      selectedMathTypes[entry.key.id] = entry.value;
    }
    resolvedContext['selectedMathTypes'] = selectedMathTypes;

    widget.dispatchEvent(
      UserActionEvent(
        name: name,
        sourceComponentId: widget.widgetId,
        context: resolvedContext,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool hasSelection = _selectedTypes.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.title != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(widget.title!, style: theme.textTheme.headlineSmall),
          ),
          const SizedBox(height: 16.0),
        ],
        SizedBox(
          height: 280,
          child: ScrollConfiguration(
            behavior: _DesktopAndWebScrollBehavior(),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              scrollDirection: Axis.horizontal,
              itemCount: MathType.values.length,
              itemBuilder: (context, index) {
                final type = MathType.values[index];
                final isSelected = _selectedTypes.containsKey(type);
                final exerciseCount = _selectedTypes[type];
                return _MathTypeItem(
                  type: type,
                  isSelected: isSelected,
                  exerciseCount: exerciseCount,
                  minExercises: widget.minExercises,
                  maxExercises: widget.maxExercises,
                  onTap: () => _toggleSelection(type),
                  onExerciseCountChanged: (count) =>
                      _updateExerciseCount(type, count),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 16),
            ),
          ),
        ),
        const SizedBox(height: 24.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: hasSelection ? _onConfirm : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(widget.confirmButtonLabel),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MathTypeItem extends StatelessWidget {
  const _MathTypeItem({
    required this.type,
    required this.isSelected,
    required this.exerciseCount,
    required this.minExercises,
    required this.maxExercises,
    required this.onTap,
    required this.onExerciseCountChanged,
  });

  final MathType type;
  final bool isSelected;
  final int? exerciseCount;
  final int minExercises;
  final int maxExercises;
  final VoidCallback onTap;
  final void Function(int) onExerciseCountChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: 180,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.surfaceDim,
            width: 2.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tappable header
            GestureDetector(
              onTap: onTap,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primaryContainer
                              : colorScheme.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          type.icon,
                          size: 32,
                          color: isSelected
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                      // Selection indicator
                      if (isSelected)
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.surface,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.check,
                            color: colorScheme.onPrimary,
                            size: 12,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    type.label,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? colorScheme.primary : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    type.description,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Number input (only when selected)
            if (isSelected) ...[
              const SizedBox(height: 12),
              NumberInput(
                label: 'Số lượng',
                value: exerciseCount ?? minExercises,
                min: minExercises,
                max: maxExercises,
                onChanged: onExerciseCountChanged,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String _mathTypeExampleData() => jsonEncode([
  {
    'id': 'root',
    'component': {
      'Column': {
        'children': {
          'explicitList': ['title_text', 'math_type_selector'],
        },
      },
    },
  },
  {
    'id': 'title_text',
    'component': {
      'Text': {
        'text': {'literalString': 'Chọn dạng bài toán và số lượng!'},
      },
    },
  },
  {
    'id': 'math_type_selector',
    'component': {
      'MathTypeSelector': {
        'title': {'literalString': 'Dạng bài toán'},
        'confirmButtonLabel': {'literalString': 'Tạo bài tập'},
        'confirmAction': {'name': 'selectMathTypes'},
        'minExercises': 1,
        'maxExercises': 20,
        'defaultExercises': 5,
      },
    },
  },
]);
