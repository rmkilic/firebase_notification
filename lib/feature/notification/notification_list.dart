import 'dart:async';

import 'package:firebase_notification/feature/notification/components/linear_indicator.dart';
import 'package:firebase_notification/feature/notification/notification_view.dart';
import 'package:firebase_notification/product/constant/cons_color.dart';
import 'package:firebase_notification/product/constant/cons_route.dart';
import 'package:firebase_notification/product/enums/enum_icons.dart';
import 'package:firebase_notification/product/enums/enum_notification_state.dart';
import 'package:firebase_notification/product/providers/all_provider.dart';
import 'package:firebase_notification/product/utilty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_notification/model/notification_model.dart' as notificationmodel;
import 'package:intl/intl.dart';




class NotificationList extends ConsumerStatefulWidget {
  const NotificationList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationListState();
}

class _NotificationListState extends ConsumerState<NotificationList> {
 // var _currentFilter = NotificationState.waiting;

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed(ConsRoute.splashView);
    return true;
  }

  @override
  void initState() {

    super.initState();
    activeMessage = null;
  }

  @override
  Widget build(BuildContext context) {
   // _currentFilter = ref.watch(notificationFilter);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: _appbar(),
        body: _body(),
      ),
    );
  }

  AppBar _appbar() => AppBar(
        backgroundColor: ConsColor.menubar,
        centerTitle: true,

        automaticallyImplyLeading: false,
       
        title: const Text("Notification Log"),        
      );

  Column _body() {
  //  List<notificationmodel.Sonuc> _liste = ref.watch(filteredNotificationList);
//_liste.sort(((b, a) => a.mesajtarihi!.compareTo(b.mesajtarihi!)));
    return Column(
      children: [
        //topMenu(),
       Text("Liste")
      ],
    );
  }
/* 
  topMenu() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        elevation: 10.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            
            Container(
              height: 40.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white54),
              child: Row(
                children: [
                  _topMenuItem(
                      onPressed: () {
                        ref.read(notificationFilter.notifier).state =
                            NotificationState.waiting;
                      },
                      icon: IconEnums.waiting.icon,
                      isActive: _currentFilter == NotificationState.waiting),
                  _dist(),
                  _topMenuItem(
                      onPressed: () {
                        ref.read(notificationFilter.notifier).state =
                            NotificationState.done;
                      },
                      icon: IconEnums.done.icon,
                      isActive: _currentFilter == NotificationState.done),
                  _dist(),
                  _topMenuItem(
                      onPressed: () {
                        ref.read(notificationFilter.notifier).state =
                            NotificationState.denied;
                      },
                      icon: IconEnums.clear.icon,
                      isActive: _currentFilter == NotificationState.denied),
                  _dist(),
                  _topMenuItem(
                      onPressed: () {
                        ref.read(notificationFilter.notifier).state =
                            NotificationState.timedOut;
                      },
                      icon: IconEnums.timedOut.icon,
                      isActive: _currentFilter == NotificationState.timedOut),
                  _dist(),
                  _topMenuItem(
                      onPressed: () {
                        ref.read(notificationFilter.notifier).state =
                            NotificationState.info;
                      },
                      icon: IconEnums.info.icon,
                      isActive: _currentFilter == NotificationState.info),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
 */

/* 

  Padding _dist() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        height: double.infinity,
        width: .8,
        color: Colors.black38,
      ),
    );
  }

  _topMenuItem(
      {required void Function()? onPressed,
      required IconData icon,
      String? labelText,
      required bool isActive}) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: Icon(
          icon,
          color: isActive ? ConsColor.menubar : Colors.black54,
        ),
      ),
    );
  }

  Widget listItem(notificationmodel.Sonuc item) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: InkWell(
        child: Card(
          elevation: 20.0,
          child: Column(
            children: [
              item.durum != NotificationState.waiting.state
                  ? Container()
                  : SizedBox(
                      height: 8.0,
                      width: double.infinity,
                      child: LinearIndicatorConsumer(item: item)),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: _listtile(item),
              ),
              item.durum != NotificationState.waiting.state
                  ? Container()
                  : _buttonRow(item)
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(ConsRoute.notification,
              arguments: MessageArguman(message: item));
        },
      ),
    );
  }

  Widget _buttonRow(notificationmodel.Sonuc item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _button(
              labelText: "",
              icon: IconEnums.clear.icon,
              onPressed: () async {
                await _buttonPress(item, notifState: NotificationState.denied);
              },
              bgColor: ConsColor.notifTimedOutCountDown),
          SizedBox(
            width: 20.0,
          ),
          _button(
              labelText: "",
              icon: IconEnums.done.icon,
              onPressed: () async {
                await _buttonPress(item, notifState: NotificationState.done);
              },
              bgColor: ConsColor.notifOnay),
        ],
      ),
    );
  }

  Future _buttonPress(notificationmodel.Sonuc item,
      {required NotificationState notifState}) async {
    item.durum = notifState.state;
    ref.read(countdownNotifierProvider.notifier).addNotification(item);

  }

  _button(
      {required void Function()? onPressed,
      required IconData icon,
      String? labelText,
      required Color bgColor}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Icon(icon),
      style: ElevatedButton.styleFrom(backgroundColor: bgColor),
    );
  }

  ListTile _listtile(notificationmodel.Sonuc item) {
    return ListTile(
      title: Text(
          "${item.kimden ?? ""} ${item.kasakodu != null ? "${item.kasakodu} Nolu Kasa" : ""}"),
      subtitle: SizedBox(
        width: double.infinity,
        child: Text(
          "${item.mesaj}",
          style: TextStyle(fontSize: 14.0, color: Colors.blueGrey.shade700),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: item.durum != NotificationState.waiting.state
          ? Text(DateFormat("HH:mm").format(item.mesajtarihi!))
          : null,
    );
  }
 */}
