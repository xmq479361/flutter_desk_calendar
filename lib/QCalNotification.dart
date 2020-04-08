import 'package:flutter/material.dart';
import 'QCalHolder.dart';

class QCalNotification extends Notification {
  QCalHolder model;

  QCalNotification(this.model);

  static void dispatchTo(BuildContext context, QCalHolder model) {
    dispatchFuture(context,model);
  }
  static Future dispatchFuture(BuildContext context, QCalHolder model) async {
    QCalNotification(model).dispatch(context);
  }
}

