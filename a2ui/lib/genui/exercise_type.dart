import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

/// Enum định nghĩa các loại bài tập cố định
enum ExerciseType {
  math(
    id: 'math',
    label: 'Toán',
    description: 'Đếm số, cộng trừ đơn giản',
    icon: Icons.calculate,
  ),
  vietnamese(
    id: 'vietnamese',
    label: 'Tiếng Việt',
    description: 'Chữ cái, từ vựng cơ bản',
    icon: Icons.abc,
  ),
  english(
    id: 'english',
    label: 'Tiếng Anh',
    description: 'Alphabet, basic vocabulary',
    icon: Icons.translate,
  );

  const ExerciseType({
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

final _schema = S.object(
  properties: {
    'title': A2uiSchemas.stringReference(
      description: 'An optional title to display above the exercise type list.',
    ),
    'confirmButtonLabel': A2uiSchemas.stringReference(
      description:
          'The label for the confirm button. Defaults to "Tiếp tục" if not provided.',
    ),
    'confirmAction': A2uiSchemas.action(
      description:
          'The action to perform when the confirm button is tapped. '
          'The context for this action will include "selectedTypes" - an array '
          'of selected exercise type IDs (e.g., ["math", "vietnamese"]).',
    ),
  },
  required: ['confirmAction'],
);

/// A widget that presents a horizontally scrolling list of exercise types
/// that users can select/deselect by tapping.
///
/// This component is ideal for the first step of the exercise creation flow,
/// allowing parents to choose which types of exercises they want to create
/// (Math, Vietnamese, English). Each item can be toggled on/off and shows
/// a check icon when selected. A confirm button at the bottom is enabled
/// only when at least one item is selected.
///
/// The exercise types are predefined in [ExerciseType] enum and cannot be
/// customized by the AI.
final exerciseTypeSelector = CatalogItem(
  name: 'ExerciseTypeSelector',
  dataSchema: _schema,
  widgetBuilder: (itemContext) {
    final selectorData = _ExerciseTypeSelectorData.fromMap(
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
            return _ExerciseTypeSelector(
              title: title,
              confirmButtonLabel: confirmLabel ?? 'Tiếp tục',
              confirmAction: selectorData.confirmAction,
              widgetId: itemContext.id,
              dispatchEvent: itemContext.dispatchEvent,
              dataContext: itemContext.dataContext,
            );
          },
        );
      },
    );
  },
);

extension type _ExerciseTypeSelectorData.fromMap(Map<String, Object?> _json) {
  factory _ExerciseTypeSelectorData({
    JsonMap? title,
    JsonMap? confirmButtonLabel,
    required JsonMap confirmAction,
  }) => _ExerciseTypeSelectorData.fromMap({
    if (title != null) 'title': title,
    if (confirmButtonLabel != null) 'confirmButtonLabel': confirmButtonLabel,
    'confirmAction': confirmAction,
  });

  JsonMap? get title => _json['title'] as JsonMap?;
  JsonMap? get confirmButtonLabel => _json['confirmButtonLabel'] as JsonMap?;
  JsonMap get confirmAction => _json['confirmAction'] as JsonMap? ?? {};
}

class _DesktopAndWebScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class _ExerciseTypeSelector extends StatefulWidget {
  const _ExerciseTypeSelector({
    this.title,
    required this.confirmButtonLabel,
    required this.confirmAction,
    required this.widgetId,
    required this.dispatchEvent,
    required this.dataContext,
  });

  final String? title;
  final String confirmButtonLabel;
  final JsonMap confirmAction;
  final String widgetId;
  final DispatchEventCallback dispatchEvent;
  final DataContext dataContext;

  @override
  State<_ExerciseTypeSelector> createState() => _ExerciseTypeSelectorState();
}

class _ExerciseTypeSelectorState extends State<_ExerciseTypeSelector> {
  final Set<ExerciseType> _selectedTypes = {};

  void _toggleSelection(ExerciseType type) {
    setState(() {
      if (_selectedTypes.contains(type)) {
        _selectedTypes.remove(type);
      } else {
        _selectedTypes.add(type);
      }
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
    resolvedContext['selectedTypes'] = _selectedTypes.map((t) => t.id).toList();

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
      children: [
        if (widget.title != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(widget.title!, style: theme.textTheme.headlineSmall),
          ),
          const SizedBox(height: 16.0),
        ],
        SizedBox(
          height: 240,
          child: ScrollConfiguration(
            behavior: _DesktopAndWebScrollBehavior(),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              scrollDirection: Axis.horizontal,
              itemCount: ExerciseType.values.length,
              itemBuilder: (context, index) {
                final type = ExerciseType.values[index];
                final isSelected = _selectedTypes.contains(type);
                return _ExerciseTypeItem(
                  type: type,
                  isSelected: isSelected,
                  onTap: () => _toggleSelection(type),
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

class _ExerciseTypeItem extends StatelessWidget {
  const _ExerciseTypeItem({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final ExerciseType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: 160,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 8),
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
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primaryContainer
                          : colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      type.icon,
                      size: 40,
                      color: isSelected
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  // Selection indicator
                  if (isSelected)
                    Container(
                      width: 24,
                      height: 24,
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
                        size: 14,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
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
      ),
    );
  }
}
