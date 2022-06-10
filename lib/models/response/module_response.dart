import 'package:thepcosprotocol_app/models/module.dart';

class ModuleResponse {
  List<Module>? results;

  ModuleResponse({this.results});

  factory ModuleResponse.fromList(List<dynamic> json) {
    List<Module> modules = [];
    if (json.length > 0) {
      json.forEach((item) {
        modules.add(Module.fromJson(item));
      });
    }
    return ModuleResponse(results: modules);
  }
}

/*
{
  status: OK,
  message: ,
  info: ,
  payload: [
    {moduleID: 1, title: This is a test module, dateCreatedUTC: 2021-03-18T22:25:00}
  ]
}
*/
