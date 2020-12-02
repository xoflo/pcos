import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/app.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';

void main() {
  FlavorConfig(flavor: Flavor.STAGING,
      color: Colors.green,
      values: FlavorValues(baseUrl: "")
  );

  runApp(MyApp());
}