import 'package:flutter/material.dart';

Widget switchUI({required bool value, required Function onChanged}) {
  return Switch(value: value, onChanged: (value) => onChanged(value));
}
