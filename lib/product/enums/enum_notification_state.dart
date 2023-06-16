enum NotificationState { waiting, done, denied, timedOut, info }

extension NotifcationStateExt on NotificationState {
  String get state {
    switch (this) {
      case NotificationState.done:
        return 'O';
      case NotificationState.denied:
        return 'R';
      case NotificationState.timedOut:
        return 'Z';
      case NotificationState.info:
        return 'I';
      default:
        return 'B';
    }
  }
}
