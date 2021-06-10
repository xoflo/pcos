import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:thepcosprotocol_app/main_dev.dart' as app;
import 'package:thepcosprotocol_app/constants/widget_keys.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  debugPrint("**********RUNNING TESTS 1");
  /*testWidgets("failing test example", (WidgetTester tester) async {
    expect(2 + 2, equals(5));
  });*/

  group('end-to-end test', () {
    //enableFlutterDriverExtension();
    testWidgets('login to app and confirm on Dashboard',
            (WidgetTester tester) async {
          await app.main();
          await tester.pumpAndSettle();
          debugPrint("**********RUNNING TESTS 2");
          //Find the email/username input
          final Finder userName = find.byKey(Key(WidgetKeys.SignInUsernameEmail));

          await tester.enterText(userName, "andyfrost50");
        });
  });
}
