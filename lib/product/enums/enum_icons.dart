import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum IconEnums {  
  done,
  reply,
  clear,
  timedOut,
  waiting,
  info,
  notificationList,
}

extension IconEnumsExtension on IconEnums {
  IconData get icon {
    return switch (this) {
      IconEnums.done => Icons.done,
      IconEnums.reply => Icons.reply_all_outlined,
      IconEnums.notificationList => FontAwesomeIcons.envelope,
      IconEnums.clear => Icons.clear,
      IconEnums.timedOut => Icons.update_disabled,
      IconEnums.waiting => Icons.alarm,
      IconEnums.info => Icons.info_outline
    };
  }
}
