// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

inputDecoration(hintText, labelText, {suffixIcon}) {
  return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      suffixIcon: suffixIcon);
}

inputHintText(item) {
  return Text(
    item,
    style: const TextStyle(
      fontSize: 14,
    ),
  );
}

final inputFieldPadding =
    EdgeInsets.only(bottom: 5, top: 10, right: 15, left: 15);

final dropDownDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(10),
);

final inputBorder =
    OutlineInputBorder(borderRadius: new BorderRadius.circular(5.0));
