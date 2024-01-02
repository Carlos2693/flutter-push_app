part of 'notification_bloc.dart';

class NotificationState extends Equatable {

  final AuthorizationStatus status;
  // TODO: Crear mi modelo de notificaciones
  final List<PushMessage> notifications;

  const NotificationState({
    this.status = AuthorizationStatus.notDetermined,
    this.notifications = const [],
  });

  NotificationState copyWith({
     AuthorizationStatus? status,
     List<PushMessage>? notifications,
  }) => NotificationState(
    status: status ?? this.status,
    notifications: notifications ?? this.notifications,
  );
  
  @override
  List<Object> get props => [status, notifications];
}
