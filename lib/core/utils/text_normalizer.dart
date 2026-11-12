/// Shared normalization so the form's "unchanged" check and the data source's
/// diff agree on what counts as a change (e.g. `null` vs `""` description).
abstract final class TextNormalizer {
  static String title(String raw) => raw.trim();

  static String? description(String? raw) {
    final trimmed = raw?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}
