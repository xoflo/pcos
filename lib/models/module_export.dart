import 'package:thepcosprotocol_app/models/lesson_export_list.dart';
import 'package:thepcosprotocol_app/models/module.dart';
import 'package:thepcosprotocol_app/models/lesson_export.dart';

class ModuleExport {
  final Module? module;
  final List<LessonExport>? lessons;

  ModuleExport({
    this.module,
    this.lessons,
  });

  factory ModuleExport.fromJson(Map<String, dynamic> json) {
    return ModuleExport(
      module: Module.fromJson(json['module']),
      lessons: LessonExportList.fromList(json['lessons']).results,
    );
  }
}
