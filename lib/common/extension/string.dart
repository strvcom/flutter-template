extension StringExtension on String? {
  bool get isNullOrEmpty {
    return this == null || this!.isEmpty;
  }
}
