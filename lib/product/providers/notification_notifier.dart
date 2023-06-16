import 'dart:async';

import 'package:firebase_notification/product/enums/enum_notification_state.dart';
import 'package:firebase_notification/product/utilty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_notification/model/notification_model.dart' as notificationmodel;

class NotificationNotifier
    extends StateNotifier<List<notificationmodel.Sonuc>> {
  NotificationNotifier([List<notificationmodel.Sonuc>? initialList])
      : super(initialList ?? []);

  void addNotification(notificationmodel.Sonuc message) {
    try {
      if (state.any((element) => element.guid == message.guid)) {
        _updateNotif(message);
      } else {
        _addNotification(message);
      }
    } catch (e) {
      debugPrint("[NOTIFICATION-NOTIFIER] ADD NOTIF CATCH :$e ");
    }
  }

  void checkedDay()
  {
        state = [
      for (var item in state)
        if( item.mesajtarihi!.day == DateTime.now().day && item.mesajtarihi!.month == DateTime.now().month &&  item.mesajtarihi!.year == DateTime.now().year)
          item

       
    ];
  }

  void _addNotification(notificationmodel.Sonuc message) {
    state = [...state, message];
    if (message.durum == NotificationState.waiting.state) {
      message.geriSayimBaslangici = getSpendTime(message);
      message.duration = Duration(seconds: getSpendTime(message));
      _startTimer2(message);
    }
  }

  void _updateNotif(notificationmodel.Sonuc message) {
    //_startTimer2(message);
    state = [
      for (var item in state)


        if (message.guid == item.guid) message else item
    ];
    if (state
        .where((element) => element.durum == NotificationState.waiting.state)
        .toList()
        .isEmpty) {
      clearStream();
    }
  }

  notificationmodel.Sonuc _getTimedOut(notificationmodel.Sonuc item) {
    item.durum = NotificationState.timedOut.state;
    return item;
  }

  void clearAll() {
    state = [];
    clearStream();
  }

  void clearStream() {
    _subList.clear();
    _myStreamList.clear();
  }

  List<Stream> _myStreamList = [];
  List<StreamSubscription> _subList = [];

  _startTimer2(notificationmodel.Sonuc model) {
    Stream<int> _stream =
        Stream<int>.periodic(const Duration(seconds: 1), (spendTime) {
      debugPrint(
          "[NOTIFICATION_NOTIFIER - STOPWATCH] ${model.mesaj} : $spendTime : DURUM : [${model.durum}]");
      return spendTime;
    }).takeWhile((element) =>
            ((element + (model.geriSayimBaslangici ?? 0)) <= responseTime) &&
            model.durum == NotificationState.waiting.state);
    StreamSubscription _sub = _stream.listen((event) {
      model.duration =
          Duration(seconds: event + (model.geriSayimBaslangici ?? 0));
      state = [
        for (var item in state)
        
        
          if (item.guid != model.guid)
            item
          else
            _getCheckTimeOut(
                model,
                _myStreamList.indexWhere((element) => element == _stream),
                event)
      ];
    });

    _myStreamList.add(_stream);
    _subList.add(_sub);
  }

  notificationmodel.Sonuc _getCheckTimeOut(
      notificationmodel.Sonuc model, int subIndex, int event) {
    if (model.durum != NotificationState.waiting.state) {
      if (subIndex > -1) {
        _subList[subIndex].cancel();
        _subList.removeAt(subIndex);
        _myStreamList.removeAt(subIndex);
      }
    }
    if (model.duration!.inSeconds == responseTime) {
      model.duration = Duration(seconds: responseTime);
      model.durum = NotificationState.timedOut.state;
      if (subIndex > -1) {
        _subList[subIndex].cancel();
        _subList.removeAt(subIndex);
        _myStreamList.removeAt(subIndex);
      }
    }
    return model;
  }
}
