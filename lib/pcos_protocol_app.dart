import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/flavor_banner.dart';

class PCOSProtocolApp extends StatelessWidget {
  //This is where we check device size and show relevant layout widget

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The PCOS Protocol',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FlavorBanner(
        child: Scaffold(
          appBar: AppBar(
            title: Text("App Title"),
          ),
          body: Text("This is the app"),
        ),
      ),
    );
  }
}
