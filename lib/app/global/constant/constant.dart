class Constant {
  static final List<String> excludeAndroidDir = [
    "Android/data",
    "Android/media",
    "Android/obb",
    "/.",
    "com.",
    "android.",
    "System Volume Information",
  ];

  static final List<String> excludeLinuxDir = [
    "/.",
  ];
}
