import '../../../../core/error/failures.dart';
import '../../../../core/utils/text_normalizer.dart';

/// Business rule shared by create and update: a title is required.
abstract final class TaskInputValidator {
  static const String titleRequired = 'Title is required.';

  static void validateTitle(String title) {
    if (TextNormalizer.title(title).isEmpty) {
      throw const InvalidInputFailure(titleRequired);
    }
  }
}
