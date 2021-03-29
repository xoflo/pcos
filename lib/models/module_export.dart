import 'package:thepcosprotocol_app/models/lesson_export_list.dart';
import 'package:thepcosprotocol_app/models/module.dart';
import 'package:thepcosprotocol_app/models/lesson_export.dart';
import 'package:flutter/foundation.dart';

class ModuleExport {
  final Module module;
  final List<LessonExport> lessons;

  ModuleExport({
    this.module,
    this.lessons,
  });

  factory ModuleExport.fromJson(Map<String, dynamic> json) {
    debugPrint("module=${json['module']}");
    return ModuleExport(
      module: Module.fromJson(json['module']),
      lessons: LessonExportList.fromList(json['lessons']).results,
    );
  }
}
