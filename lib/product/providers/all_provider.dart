
import 'package:firebase_notification/model/notification_model.dart' as notificationmodel;
import 'package:firebase_notification/product/enums/enum_notification_state.dart';
import 'package:firebase_notification/product/providers/notification_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final notificationFilter =
    StateProvider<NotificationState>((ref) => NotificationState.waiting);

//final selectedDayFilter = StateProvider<DateTime>((ref) => DateTime.now(),);
final countdownNotifierProvider =
    StateNotifierProvider<NotificationNotifier, List<notificationmodel.Sonuc>>(
        (ref) => NotificationNotifier());


final filteredNotificationList = Provider<List<notificationmodel.Sonuc>>((ref) {
  final filter = ref.watch(notificationFilter);
  final todoList = ref.watch(countdownNotifierProvider);


      
  switch (filter) {
    case NotificationState.waiting:
      return todoList
          .where((element) => element.durum == NotificationState.waiting.state )
          .toList();
    case NotificationState.done:
      return todoList
          .where((element) => element.durum == NotificationState.done.state )
          .toList();
    case NotificationState.denied:
      return todoList
          .where((element) => element.durum == NotificationState.denied.state )
          .toList();
    case NotificationState.timedOut:
      return todoList
          .where((element) => element.durum == NotificationState.timedOut.state  )
          .toList();
    case NotificationState.info:
      return todoList
          .where((element) => element.durum == NotificationState.info.state)
          .toList();
  }
});
