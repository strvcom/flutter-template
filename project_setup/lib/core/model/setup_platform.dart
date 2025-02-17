enum SetupPlatform {
  android,
  ios,
  web,
  windows,
  macos,
  linux;

  static List<SetupPlatform> all() => SetupPlatform.values.toList();
}
