import 'package:firebase_notification/model/notification_model.dart' as notificationmodel;
import 'package:flutter/material.dart';


notificationmodel.Sonuc? activeMessage;
int responseTime = 30; // Notification Response Time

int getSpendTime(notificationmodel.Sonuc message) =>
    DateTime.now().difference(message.mesajtarihi!).inSeconds;

List<String> lowPriority = [
  "999",
  "998"
]; //onay gerektirmeyen bildirim mesaj tipleri.

 double  screenHeight(BuildContext context)
 {
  return  MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom;
 }