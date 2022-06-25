class ExcludeDir {
    static final excludeAndroidDir = <String>[
    "Android/data",
    "Android/media",
    "Android/obb",
    "/.",
    "com.",
    "android.",
    "System Volume Information",
  ];

  static final excludeLinuxDir = <String>[
    "/.",
    "sysroot",
    "usr",
    "sdk",
    "Sdk",
    "build",
  ];
}