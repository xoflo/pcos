import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/utils/string_utils.dart';

enum Flavor { DEV, STAGING, PROD }

class FlavorValues {
  FlavorValues({
    @required this.baseUrl,
    @required this.oneSignalAppID,
    @required this.questionnaireUrl,
    @required this.blobStorageUrl,
    @required this.intercomIds,
  });
  final String baseUrl;
  final String oneSignalAppID;
  final String questionnaireUrl;
  final String blobStorageUrl;
  final List<String> intercomIds;
  //Add other flavor specific values, e.g database name
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final Color color;
  final FlavorValues values;
  static FlavorConfig _instance;

  factory FlavorConfig(
      {@required Flavor flavor,
      Color color: Colors.blue,
      @required FlavorValues values}) {
    _instance ??= FlavorConfig._internal(
        flavor, StringUtils.enumName(flavor.toString()), color, values);
    return _instance;
  }

  FlavorConfig._internal(this.flavor, this.name, this.color, this.values);
  static FlavorConfig get instance {
    return _instance;
  }

  static bool isDev() => _instance.flavor == Flavor.DEV;
  static bool isStaging() => _instance.flavor == Flavor.STAGING;
  static bool isProd() => _instance.flavor == Flavor.PROD;
}
