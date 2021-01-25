import 'package:flutter_apns/apns.dart';
import 'package:flutter_apns/src/connector.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebasePushConnector extends PushConnector {
  final firebaseMessaging = FirebaseMessaging.instance;
  // final firebasePushConnector = FirebasePushConnector();

  @override
  final isDisabledByUser = ValueNotifier(false);

  @override
  void configure({onMessage, onLaunch, onResume, onBackgroundMessage}) {
    /*firebaseMessaging.configure(
      onMessage: onMessage,
      onLaunch: onLaunch,
      onResume: onResume,
      onBackgroundMessage: onBackgroundMessage,
    );*/

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      onLaunch(message.data);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      onMessage(message.data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onResume(message.data);
    });

    FirebaseMessaging.onBackgroundMessage((message) => onBackgroundMessage(message.data));

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
