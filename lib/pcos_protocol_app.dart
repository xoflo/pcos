import 'package:flutter/material.dart';

import 'package:thepcosprotocol_app/widgets/app_body.dart';
import 'package:thepcosprotocol_app/widgets/app_body_large.dart';

class PCOSProtocolApp extends StatelessWidget {
  //NB: By setting this number high, will always show tabbed layout
  //    If we choose to have a different menu approach for iPads reduce
  //    number to say 600/700
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return screenSize.width < 10000 ? AppBody() : AppBodyLarge();
  }
}