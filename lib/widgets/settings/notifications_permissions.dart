import 'package:flutter/material.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';

class NotificationsPermissions extends StatelessWidget {
  final PermissionStatus notificationPermissions;
  final Function requestNotificationPermission;

  NotificationsPermissions({
    @required this.notificationPermissions,
    @required this.requestNotificationPermission,
  });

  Widget getNotificationPermissions(BuildContext context) {
    switch (notificationPermissions) {
      case PermissionStatus.granted:
        return Container();
      case PermissionStatus.unknown:
      case PermissionStatus.provisional:
      case PermissionStatus.denied:
        return Column(
          children: [
            Text(S.of(context).notificationPermissionsNeedToAllowText),
            ColorButton(
              isUpdating: false,
              label: S.of(context).notificationPermissionsAllowButton,
              onTap: () {
                requestNotificationPermission();
              },
            )
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return getNotificationPermissions(context);
  }
}
