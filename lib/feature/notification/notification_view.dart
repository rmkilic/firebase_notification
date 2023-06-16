import 'dart:async';



import 'package:firebase_notification/feature/notification/components/countdown_widget.dart';
import 'package:firebase_notification/model/notification_model.dart' as notificationmodel;
import 'package:firebase_notification/product/constant/cons_color.dart';
import 'package:firebase_notification/product/constant/cons_route.dart';
import 'package:firebase_notification/product/constant/page_padding.dart';
import 'package:firebase_notification/product/enums/enum_notification_state.dart';
import 'package:firebase_notification/product/utilty.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MessageArguman {
  notificationmodel.Sonuc message;
//Function(notificationmodel.Sonuc message, NotificationState state, bool goNotificationList) ?islem;
  MessageArguman({
    required this.message,
  });
// required this.islem});
}

MessageArguman argument = MessageArguman(message: notificationmodel.Sonuc());

class NotificationView extends ConsumerStatefulWidget {
  final MessageArguman args;
  const NotificationView(this.args, {super.key});

  @override
  ConsumerState<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends ConsumerState<NotificationView> {
  @override
  void initState() {
    super.initState();
    activeMessage = widget.args.message;
  }

  @override
  void dispose() {
    activeMessage = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: _body(),
    );
  }

  _appbar() {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
          widget.args.message.durum == NotificationState.waiting.state
              ? "Bildirim Onayı "
              : widget.args.message.durum == NotificationState.done.state
                  ? "Onaylandı"
                  : widget.args.message.durum == NotificationState.denied.state
                      ? "Reddedildi"
                      : widget.args.message.durum == NotificationState.timedOut.state
                      ? "Zaman Aşımı"
                      : "Bilgi Mesajı",
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: Colors.white)),
      backgroundColor:
          (widget.args.message.durum == NotificationState.waiting.state || widget.args.message.durum == NotificationState.done.state)
              ? ConsColor.notifGreen
              : widget.args.message.durum == NotificationState.info.state
                  ? ConsColor.notifBlue
                  : ConsColor.notifRed,
    );
  }

  _body() {
    return Padding(
      padding: const PagePadding.pagepadding(),
      child: Column(
        children: [
          Text(
            "${widget.args.message.subeadi ?? ' '} ${(widget.args.message.kasakodu != null && widget.args.message.kasakodu!.isNotEmpty) ? "${widget.args.message.kasakodu} nolu KASA" : ''}\n ${widget.args.message.mesaj}",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: ConsColor.notifTitle),
          ),
          SizedBox(height: screenHeight(context) * .1),
          Text(
              DateFormat('HH:mm dd/MM/yyyy')
                  .format(widget.args.message.mesajtarihi ?? DateTime.now()),
              style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: screenHeight(context) * .15),
          Expanded(
              flex: 3,
              child:
              widget.args.message.durum == NotificationState.info.state 
              ? const SizedBox()
              : CountdownWidget(
                  message: widget.args.message,
                  timeOutFunc: () async{
                  /*   if (widget.args.message.durum ==
                        NotificationState.waiting.state) {
                      widget.args.message.durum =
                          NotificationState.timedOut.state;
                      debugPrint("[Notification View] TIME OUT  GUID : ${widget.args.message.guid} ");
                      ref.read(countdownNotifierProvider.notifier).addNotification(widget.args.message);
                      await sqfliteUpdateMessageTables(model: widget.args.message);                          
                      await updateNotificationStatus(guid: widget.args.message.guid!, durum: widget.args.message.durum!);
                      await _pressButton(notifState: NotificationState.timedOut);

                      setState(() {});
                    } */
                  },
                  isTimedOut: widget.args.message.durum ==
                      NotificationState.timedOut.state)),
          SizedBox(height: screenHeight(context) * .15),
          Expanded(flex: 2, child: _buttonRow())
        ],
      ),
    );
  }

  Column _buttonRow() {
    double height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _notifButton(
            bordercolor: Colors.white,
            title: "Onay",
            onTap: _isPreview
                ? () {}
                : () async {                    
                    await _pressButton(notifState: NotificationState.done);
                  },
            backgroundcolor: _isPreview 
                ? ConsColor.notifOnay.withOpacity(.2)
                : ConsColor.notifOnay,
            height: height < 600 ? height * .07 : 48),
        _notifButton(
            bordercolor: _isPreview 
                ? ConsColor.notifOnay
                : ConsColor.notifTimedOutCountTime,
            title: _isPreview ? "Geri" : "İptal",
            onTap: () async {
              if (_isPreview) {
                Navigator.of(context).pop();
              } else {
                await _pressButton( notifState: NotificationState.denied);
              }
            },
            backgroundcolor: Colors.white,
            height: height < 600 ? height * .07 : 48)
      ],
    );
  }

  Future<void> _pressButton(
      {required NotificationState notifState}) async {
     /*    //Zaman aşımı olduğunda countdown içerisinde yapıyorum burda yapmaya gerek yok.
        if(widget.args.message.durum != NotificationState.timedOut)
        {
          widget.args.message.durum = notifState.state;
          ref.read(countdownNotifierProvider.notifier).addNotification(widget.args.message);
          //  ref.read(gerisayimNotifier.notifier).removeCount(guid: widget.args.message.guid!);
          await sqfliteUpdateMessageTables(model: widget.args.message);
          await updateNotificationStatus(guid: widget.args.message.guid!, durum: widget.args.message.durum!);
        }
        //foreground 'da olan mesajları ekleyebilmek için burada işlem yapmamız lazım.
        await sqfliteReadMessageTables(durum: NotificationState.waiting.state).then((value)async{
          for(var message in value)
          {
            message.durum = lowPriority.any((element) => element == message.mesajtipi.toString()) 
            ? NotificationState.info.state 
            : getSpendTime(message) > responseTime
            ? NotificationState.timedOut.state
            : NotificationState.waiting.state; 
          ref.read(countdownNotifierProvider.notifier).addNotification(message);
            if(message.durum != NotificationState.waiting.state)
            {
                await sqfliteUpdateMessageTables(model: message);
                await updateNotificationStatus(guid: message.guid!, durum: message.durum!);
       
            }
          }
        });     */ 
    Navigator.of(context).pushNamed(ConsRoute.notificationList);
        
  }
    
  

  _notifButton(
      {required Color bordercolor,
      Color backgroundcolor = Colors.white,
      required String title,
      required Function onTap,
      double height = 48}) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: bordercolor),
            borderRadius: BorderRadius.circular(10.0),
            color: backgroundcolor),
        width: double.infinity,
        height: height,
        child: Center(
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: bordercolor),
          ),
        ),
      ),
      onTap: () async {
        await onTap();
      },
    );
  }

  bool get _isPreview {
    if (widget.args.message.durum == NotificationState.waiting.state) {
      return false;
    } else {
      return true;
    }
  }
}
