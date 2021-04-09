import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//NB: Only include this widget for local build, if you want to test crashlytics

// Toggle this to cause an async error to be thrown during initialization
// and to test that runZonedGuarded() catches the error
final _kShouldTestAsyncErrorOnInit = false;

// Toggle this for testing Crashlytics in your app locally.
final _kTestingCrashlytics = true;

class FirebaseCrashlyticsTester extends StatefulWidget {
  @override
  _FirebaseCrashlyticsTesterState createState() =>
      _FirebaseCrashlyticsTesterState();
}

class _FirebaseCrashlyticsTesterState extends State<FirebaseCrashlyticsTester> {
  Future<void> _testAsyncErrorOnInit() async {
    Future<void>.delayed(const Duration(seconds: 2), () {
      final List<int> list = <int>[];
      print(list[100]);
    });
  }

  Future<void> _initializeFlutterFireFuture;

  // Define an async function to initialize FlutterFire
  Future<void> _initializeFlutterFire() async {
    // Wait for Firebase to initialize
    await Firebase.initializeApp();

    if (_kTestingCrashlytics) {
      // Force enable crashlytics collection enabled if we're testing it.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      // Else only enable it in non-debug builds.
      // You could additionally extend this to allow users to opt-in.
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);
    }

    // Pass all uncaught errors to Crashlytics.
    Function originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      // Forward to original handler.
      originalOnError(errorDetails);
    };

    if (_kShouldTestAsyncErrorOnInit) {
      await _testAsyncErrorOnInit();
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeFlutterFireFuture = _initializeFlutterFire();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeFlutterFireFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            return Center(
              child: Column(
                children: <Widget>[
                  ElevatedButton(
                      child: const Text('Key'),
                      onPressed: () {
                        FirebaseCrashlytics.instance
                            .setCustomKey('example', 'flutterfire');
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Custom Key "example: flutterfire" has been set \n'
                              'Key will appear in Firebase Console once app has crashed and reopened'),
                          duration: Duration(seconds: 5),
                        ));
                      }),
                  ElevatedButton(
                      child: const Text('Log'),
                      onPressed: () {
                        FirebaseCrashlytics.instance
                            .log('This is a log example');
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'The message "This is a log example" has been logged \n'
                              'Message will appear in Firebase Console once app has crashed and reopened'),
                          duration: Duration(seconds: 5),
                        ));
                      }),
                  ElevatedButton(
                      child: const Text('Crash'),
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('App will crash is 5 seconds \n'
                              'Please reopen to send data to Crashlytics'),
                          duration: Duration(seconds: 5),
                        ));

                        // Delay crash for 5 seconds
                        sleep(const Duration(seconds: 5));
                        debugPrint('CRASH NOW!!!!');
                        // Use FirebaseCrashlytics to throw an error. Use this for
                        // confirmation that errors are being correctly reported.
                        FirebaseCrashlytics.instance.crash();
                      }),
                  ElevatedButton(
                      child: const Text('Throw Error'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Thrown error has been caught \n'
                              'Please crash and reopen to send data to Crashlytics'),
                          duration: Duration(seconds: 5),
                        ));

                        // Example of thrown error, it will be caught and sent to
                        // Crashlytics.
                        throw StateError('Uncaught error thrown by app');
                      }),
                  ElevatedButton(
                      child: const Text('Async out of bounds'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Uncaught Exception that is handled by second parameter of runZonedGuarded \n'
                              'Please crash and reopen to send data to Crashlytics'),
                          duration: Duration(seconds: 5),
                        ));

                        // Example of an exception that does not get caught
                        // by `FlutterError.onError` but is caught by
                        // `runZonedGuarded`.
                        runZonedGuarded(() {
                          Future<void>.delayed(const Duration(seconds: 2), () {
                            final List<int> list = <int>[];
                            print(list[100]);
                          });
                        }, FirebaseCrashlytics.instance.recordError);
                      }),
                  ElevatedButton(
                      child: const Text('Record Error'),
                      onPressed: () async {
                        try {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Recorded Error  \n'
                                'Please crash and reopen to send data to Crashlytics'),
                            duration: Duration(seconds: 5),
                          ));
                          throw 'error_example';
                        } catch (e, s) {
                          // "reason" will append the word "thrown" in the
                          // Crashlytics console.
                          await FirebaseCrashlytics.instance
                              .recordError(e, s, reason: 'as an example');
                        }
                      }),
                ],
              ),
            );
            break;
          default:
            return Center(child: Text('Loading'));
        }
      },
    );
  }
}
