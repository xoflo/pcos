import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class Global {
  static final FirebaseAnalytics analytics = FirebaseAnalytics();
  static final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
}
