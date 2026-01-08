import 'package:genui/genui.dart';

/// Helper function to safely update a value in the DataContext.
///
/// The genui package's DataModel._updateValue throws an error when trying to
/// update a list at an index that's more than 1 position beyond the current
/// length. This helper ensures that all intermediate list elements exist
/// before performing the update.
///
/// For example, if the path is `/questions/4/userAnswer` but the questions
/// list only has 1 element, this function will first fill elements 1, 2, 3
/// with empty maps before updating element 4.
void safeUpdateDataContext(
  DataContext dataContext,
  DataPath path,
  Object? value,
) {
  final segments = path.segments;
  if (segments.isEmpty) {
    dataContext.update(path, value);
    return;
  }

  // Build up the path and ensure each list has enough elements
  final pathBuilder = <String>[];

  for (var i = 0; i < segments.length - 1; i++) {
    final segment = segments[i];
    final nextSegment = segments[i + 1];

    pathBuilder.add(segment);

    // Check if next segment is a numeric index
    final nextIndex = int.tryParse(nextSegment);
    if (nextIndex != null && nextIndex > 0) {
      // Get the current list at this path
      final currentPath = DataPath('/${pathBuilder.join('/')}');
      final currentList = dataContext.getValue<List<Object?>>(currentPath);

      if (currentList != null && currentList.length <= nextIndex) {
        // Fill in missing elements with empty maps
        for (var j = currentList.length; j < nextIndex; j++) {
          final fillPath = DataPath('/${pathBuilder.join('/')}/$j');
          dataContext.update(fillPath, <String, Object?>{});
        }
      }
    }
  }

  // Now perform the actual update
  dataContext.update(path, value);
}
