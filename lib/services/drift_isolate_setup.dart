import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

LazyDatabase createNativeDriftConnection(String fileName) {
  return LazyDatabase(() async {
    final bool desktop =
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS;
    final dir = desktop
        ? await getApplicationSupportDirectory()
        : await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, fileName));
    return NativeDatabase.createInBackground(file);
  });
}
