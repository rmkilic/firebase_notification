
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:clear_all_notifications/clear_all_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_notification/feature/notification/notification_view.dart';
import 'package:firebase_notification/product/constant/cons_route.dart';
import 'package:firebase_notification/product/enums/enum_notification_state.dart';
import 'package:firebase_notification/product/enums/enum_shared_prefs.dart';
import 'package:firebase_notification/product/navigation_service.dart';
import 'package:firebase_notification/product/utilty.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_notification/model/notification_model.dart' as notificationmodel;

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
      // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
    
      _handleMessage(initialMessage);
    
    }
 
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

    Future<void> _handleMessage(RemoteMessage ?message) async {
      print("[ Firebase ] - BACKGROUND MESSAGE : OPENED APP ");
      if (message != null) {
      print("[ Firebase ] - TERMINATE MESSAGE : OPENED APP");
      firebaseBackgroundMessageCheck();
    notificationmodel.Sonuc _message = notificationmodel.Sonuc.fromJson(message.data);
       
              ClearAllNotifications.clear();
      await NavigationService.instance.navigateTo(ConsRoute.notification,
          navigateArguments: MessageArguman(
            message: _message,
          ));
      }

  }
    Future firebaseBackgroundMessageCheck() async {
    List<String> _backgroundMessageList = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    _backgroundMessageList =
        prefs.getStringList(SharedPrefsEnums.backgroundMessageList.name) ?? [];
    if (_backgroundMessageList.isNotEmpty) {
      print(" [ Firebase ]  BACKGROUND MESSAGE LENGTH : ${_backgroundMessageList.length}");
      /* for (var guid in _backgroundMessageList) {
        notificationmodel.Sonuc? _apiMessage =  await NotificationRepository().getData(guid);
        if (_apiMessage != null) {
          if (lowPriority
              .any((element) => element == _apiMessage.mesajtipi.toString())) {
            _apiMessage.durum = NotificationState.info.state;
          } else {
            _apiMessage.durum = getSpendTime(_apiMessage) < responseTime
                ? NotificationState.waiting.state
                : NotificationState.timedOut.state;
          }

       
          if(_backgroundMessageList.indexWhere((element) => element == guid) == (_backgroundMessageList.length -1))
          {
            prefs.setStringList(SharedPrefsEnums.backgroundMessageList.name, []);
          }
        }
      } */
    }
  }

  void initState() {
    super.initState();

    setupInteractedMessage();
  }





  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("notif"),/* 
            Lottie.asset('assets/lottie/lottie_message_plane.json'),
            _splashText() */
          ],
        ),
      ),
    );
  }
}



_splashText()
{
  const colorizeColors = [
  Colors.indigo,
  Colors.grey,
  Colors.indigo,
  Colors.blueAccent,
];

const colorizeTextStyle = TextStyle(
  fontSize: 50.0,
  fontFamily: 'Horizon',
);

return SizedBox(
  width: double.infinity,
  child:  Center(
    child: AnimatedTextKit(
      animatedTexts: [
        ColorizeAnimatedText(
          'Notification',
          textStyle: colorizeTextStyle,
          colors: colorizeColors,
        ),
      ]),
  )
);

}

