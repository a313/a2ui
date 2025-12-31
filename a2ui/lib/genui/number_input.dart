import 'package:a2ui/ds/ds_number_input.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A number input widget with increment/decrement buttons and direct text input.',
  properties: {
    'label': S.string(description: 'The label for the number input.'),
    'value': A2uiSchemas.stringReference(
      description: 'The current value bound to the data model (as string).',
    ),
    'min': S.integer(description: 'The minimum allowed value (optional).'),
    'max': S.integer(description: 'The maximum allowed value (optional).'),
    'initialValue': S.integer(
      description:
          'The initial value to display (optional, defaults to min or 0).',
    ),
  },
  required: ['label', 'value'],
);

extension type _NumberInputData.fromMap(Map<String, Object?> _json) {
  factory _NumberInputData({
    required String label,
    required JsonMap value,
    int? min,
    int? max,
    int? initialValue,
  }) => _NumberInputData.fromMap({
    'label': label,
    'value': value,
    if (min != null) 'min': min,
    if (max != null) 'max': max,
    if (initialValue != null) 'initialValue': initialValue,
  });

  String get label => _json['label'] as String;
  JsonMap? get value => _json['value'] as JsonMap?;
  int? get min => _json['min'] as int?;
  int? get max => _json['max'] as int?;
  int? get initialValue => _json['initialValue'] as int?;
}

final numberInput = CatalogItem(
  name: 'NumberInput',
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": {
            "NumberInput": {
              "label": "Số lượng bài tập",
              "value": {
                "path": "/exerciseCount"
              },
              "min": 1,
              "max": 20,
              "initialValue": 5
            }
          }
        }
      ]
    ''',
    () => '''
      [
        {
          "id": "root",
          "component": {
            "NumberInput": {
              "label": "Số người",
              "value": {
                "path": "/guestCount"
              },
              "min": 1,
              "initialValue": 2
            }
          }
        }
      ]
    ''',
  ],
  widgetBuilder: (context) {
    final data = _NumberInputData.fromMap(context.data as Map<String, Object?>);

    final JsonMap? valueRef = data.value;
    final path = valueRef?['path'] as String?;
    final ValueNotifier<String?> notifier = context.dataContext
        .subscribeToString(valueRef);

    // Set initial value if provided and current value is null
    if (path != null && notifier.value == null && data.initialValue != null) {
      context.dataContext.update(DataPath(path), data.initialValue.toString());
    }

    return ValueListenableBuilder<String?>(
      valueListenable: notifier,
      builder: (builderContext, currentValue, child) {
        final intValue =
            int.tryParse(currentValue ?? '') ??
            data.initialValue ??
            data.min ??
            0;
        return NumberInput(
          label: data.label,
          value: intValue,
          min: data.min,
          max: data.max,
          onChanged: (newValue) {
            if (path != null) {
              context.dataContext.update(DataPath(path), newValue.toString());
            }
          },
        );
      },
    );
  },
);

class NumberInput extends StatelessWidget {
  const NumberInput({
    super.key,
    required this.label,
    required this.value,
    this.min,
    this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int? min;
  final int? max;
  final void Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        DsNumberInput(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }
}
