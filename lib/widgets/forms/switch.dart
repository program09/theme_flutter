import 'package:flutter/material.dart';

Widget switchUI({required bool value, required Function onChecked}) {
  return Switch(value: value, onChanged: (value) => onChecked(value));
}
