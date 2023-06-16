
import 'package:firebase_notification/model/notification_model.dart' as notificationmodel;


import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_notification/product/constant/cons_color.dart';
import 'package:firebase_notification/product/enums/enum_notification_state.dart';
import 'package:firebase_notification/product/utilty.dart';
import 'package:flutter/material.dart';

class CountdownWidget extends StatefulWidget {

  final notificationmodel.Sonuc message;
  final VoidCallback timeOutFunc;
  final bool isTimedOut;

  const CountdownWidget(
      {Key? key,
      required this.message,
      required this.timeOutFunc,
      this.isTimedOut = false})
      : super(key: key);

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  @override
  void initState() {
    super.initState();
  }

  final CountDownController controllerCountDown = CountDownController();
  int get _getDuration {
    int _tempTime =
        DateTime.now().difference(widget.message.mesajtarihi!).inSeconds;
    int _duration = widget.message.durum == NotificationState.waiting.state
        ? _tempTime < responseTime
            ? (responseTime - _tempTime)
            : 0
        : 0;
    return _duration;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: CircularCountDownTimer(
        duration: _getDuration,
        initialDuration: 0,
        controller: controllerCountDown,
        width: double.infinity,
        height: double.infinity,
        ringColor: Colors.grey[300]!,
        ringGradient:
            LinearGradient(colors: [Colors.green, Colors.green.shade300]),
        fillColor: widget.isTimedOut
            ? ConsColor.notifTimedOutCountDown
            : Colors.grey.shade300,
        fillGradient: null,
        backgroundColor: null,
        backgroundGradient: null,
        strokeWidth: 10.0,
        strokeCap: StrokeCap.round,
        textStyle: Theme.of(context).textTheme.headlineLarge!.copyWith(
            color: widget.isTimedOut
                ? ConsColor.notifTimedOutCountTime
                : ConsColor.notifCountdown),
        textFormat: CountdownTextFormat.S,
        isReverse: true,
        isReverseAnimation: false,
        isTimerTextShown: true,
        autoStart: true,
        onComplete: widget.timeOutFunc,
      )),
    );
  }
}
