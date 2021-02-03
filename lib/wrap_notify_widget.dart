import 'package:flutter/material.dart';


class WrapNotifyWidget extends StatelessWidget {
  final Widget child;
  final  NotificationListenerCallback<ScrollNotification> onNotification;
  const WrapNotifyWidget({Key key, this.child, this.onNotification}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return NotificationListener(child: child,
      onNotification:onNotification,
    );
  }
}
