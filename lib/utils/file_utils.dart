import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

Future<void> copyAssetToLocal(String assetFilename) async {
  try {
    var content = await rootBundle.load("assets/$assetFilename");
    final directory = await getApplicationSupportDirectory();
    var file = File("${directory.path}/$assetFilename");
    file.writeAsBytesSync(content.buffer.asUint8List());
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<String> getFileUrl(String fileName) async {
  await copyAssetToLocal(fileName);
  final directory = await getApplicationSupportDirectory();
  return "${directory.path}/$fileName";
}