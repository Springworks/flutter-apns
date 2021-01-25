import 'package:flutter_apns/src/connector.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebasePushConnector extends PushConnector {
  final firebaseMessaging = FirebaseMessaging.instance;
  final firebasePushConnector = FirebasePushConnector();

  @override
  final isDisabledByUser = ValueNotifier(false);

  @override
  void configure({onMessage, onLaunch, onResume, onBackgroundMessage}) {

    firebasePushConnector.configure(
      onMessage: onMessage,
      onLaunch: onLaunch,
      onResume: onResume,
      onBackgroundMessage: onBackgroundMessage,
    );

    firebaseMessaging.onTokenRefresh.listen((value) {
      token.value = value;
    });
  }

  @override
  final token = ValueNotifier(null);

  @override
  void requestNotificationPermissions() {
    firebaseMessaging.requestPermission();
  }

  @override
  String get providerType => 'GCM';

  @override
  Future<void> unregister() async {
    await firebaseMessaging.setAutoInitEnabled(false);
    await firebaseMessaging.deleteInstanceID();

    token.value = null;
  }
}
