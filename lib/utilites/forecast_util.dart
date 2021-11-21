import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Util {
  static String getFormattedDate(DateTime dateTime) {
    return DateFormat('EEEE, MMM d, y').format(dateTime);
  }

  static getItem(BuildContext context, IconData iconData, int value, String units) {
    final Color color = Colors.white;
    return Column(
      children: <Widget>[
        Icon(iconData, color: color, size: 28.0),
        SizedBox(height: 5.0),
        Text(
          '$value',
          style: TextStyle(fontSize: 20.0, color: color),
        ),
        SizedBox(height: 5.0),
        Text(
          '$units',
          style: TextStyle(fontSize: 15.0, color: color),
        ),
      ],
    );
  }
}