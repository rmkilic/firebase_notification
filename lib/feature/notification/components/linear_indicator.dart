
import 'package:firebase_notification/product/utilty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_notification/model/notification_model.dart' as notificationmodel;

class LinearIndicatorConsumer extends ConsumerStatefulWidget {
  final notificationmodel.Sonuc item;
  const LinearIndicatorConsumer({required this.item, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LinearIndicatorConsumerState();
}

class _LinearIndicatorConsumerState
    extends ConsumerState<LinearIndicatorConsumer> {
  @override
  Widget build(BuildContext context) {
    Duration _duration = widget.item.duration ??
        Duration(
            seconds: getSpendTime(widget.item) <= responseTime
                ? getSpendTime(widget.item)
                : responseTime);
    return LinearProgressIndicator(
      value: 1 - ((_duration.inSeconds * 100) / (responseTime * 100)),
      color: Colors.red.shade300,
      backgroundColor: Colors.grey.withOpacity(.4),
    );
  }
}
