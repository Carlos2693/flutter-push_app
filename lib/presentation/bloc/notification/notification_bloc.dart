import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:push_app/domain/entity/push_message.dart';
import 'package:push_app/firebase_options.dart';
import 'package:push_app/local_notification/local_notification.dart';

part 'notification_event.dart';
part 'notification_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationBloc() : super(const NotificationState()) {
    on<NotificationStatusChanged>(_notificationStatusChanged);

    on<NotificationReceived>(_onPushMessageReceived);

    // Verificar estado de las notificaciones
    _initialStatusCheck();
    // Listener para notificaciones en Foreground
    _onForegroundMessage();
  }

  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _notificationStatusChanged(NotificationStatusChanged event, Emitter<NotificationState> emit) {
    emit(
      state.copyWith(
        status: event.status
      )
    );
    _getFCMToken();
  }

  void _onPushMessageReceived(NotificationReceived event, Emitter<NotificationState> emit) {
    emit(
      state.copyWith(
        notifications: [event.pushMessage, ...state.notifications,],
      )
    );
  }

  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(NotificationStatusChanged(settings.authorizationStatus));
  }

  void _getFCMToken() async {
    if (state.status != AuthorizationStatus.authorized) return;

    final token = await messaging.getToken();
    print(token);
  }

  void handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) return;

    final notification = PushMessage(
      messageId: message.messageId
        ?.replaceAll(':', '').replaceAll('%', '')
        ?? '',
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid
        ? message.notification!.android?.imageUrl
        : message.notification!.apple?.imageUrl,
    );

    add(NotificationReceived(notification));
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    // Solicitar permiso a las local notifications
    await requestPermissionLocalNotification();

    add(NotificationStatusChanged(settings.authorizationStatus));
  }

  PushMessage? getMessageId(String pushMessageId) {
    final exist = state.notifications.any((element) => element.messageId == pushMessageId);
    if (!exist) return null;

    return state.notifications.firstWhere((element) => element.messageId == pushMessageId);
  }
}
