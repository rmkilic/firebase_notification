import 'package:clear_all_notifications/clear_all_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_notification/feature/notification/notification_list.dart';
import 'package:firebase_notification/feature/notification/notification_view.dart';
import 'package:firebase_notification/feature/splash/splas_view.dart';
import 'package:firebase_notification/firebase_options.dart';
import 'package:firebase_notification/product/constant/cons_route.dart';
import 'package:firebase_notification/product/enums/enum_shared_prefs.dart';
import 'package:firebase_notification/product/navigation_service.dart';
import 'package:firebase_notification/product/utilty.dart';
import 'package:flutter/material.dart';
import 'package:firebase_notification/model/notification_model.dart' as notificationmodel;
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("[ Firebase ] BACKGROUND");
      final sharedPrefrences = await SharedPreferences.getInstance(); 
    await sharedPrefrences.reload();

    List<String> _backgroundMessageList = sharedPrefrences.getStringList(SharedPrefsEnums.backgroundMessageList.name) ?? [];
    _backgroundMessageList.add(message.data["guid"]);
    sharedPrefrences.setStringList(SharedPrefsEnums.backgroundMessageList.name, _backgroundMessageList);   
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;

NotificationSettings settings = await messaging.requestPermission(
  alert: true,
  announcement: false,
  badge: true,
  carPlay: false,
  criticalAlert: false,
  provisional: false,
  sound: true,
);

print('[ Firebase ] - PERMISSION: ${settings.authorizationStatus}');
 await messaging.getToken().then((token) {
  print("[ Firebase ] - TOKEN : $token");

 },);

 FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  print('[ Firebase ] - FOREGROUND : ${message.notification!.title}');
    notificationmodel.Sonuc _message = notificationmodel.Sonuc.fromJson(message.data);
        if (activeMessage == null &&
        !(lowPriority.any(
            (element) => element == message.data["mesajtipi"].toString()))) {
              ClearAllNotifications.clear();
      await NavigationService.instance.navigateTo(ConsRoute.notification,
          navigateArguments: MessageArguman(
            message: _message,
          ));
    }

  
});

FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}








class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FCM Notification',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: ConsRoute.splashView,
        navigatorKey: NavigationService.instance.navigationKey,
        routes: {
          ConsRoute.splashView: (context) => const SplashView(),          
          ConsRoute.notification: (context) => NotificationView(ModalRoute.of(context)!.settings.arguments as MessageArguman),
          ConsRoute.notificationList: (context) => const NotificationList(),
        },
    );
  }
}

