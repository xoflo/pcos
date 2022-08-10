import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/view_models/member_view_model.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/dashboard_layout.dart';

class Dashboard extends StatelessWidget {
  Dashboard({
    required this.showYourWhy,
    required this.showLessonReicpes,
    required this.isUsernameUsed,
  });

  final bool showYourWhy;
  final bool showLessonReicpes;
  final bool isUsernameUsed;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => MemberViewModel(),
        child: DashboardLayout(
          showYourWhy: showYourWhy,
          showLessonReicpes: showLessonReicpes,
          isUsernameUsed: isUsernameUsed,
        ),
      );
}
