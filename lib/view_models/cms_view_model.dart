import 'package:thepcosprotocol_app/models/cms.dart';

class CMSViewModel {
  final CMS cms;

  CMSViewModel({this.cms});

  String get body {
    return this.cms.body;
  }
}
