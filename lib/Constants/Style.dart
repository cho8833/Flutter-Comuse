import 'package:flutter/material.dart';

class Style {
  static const listChapterText = TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );
  static const listNameText = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );
  static const containerDeco = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(5)),
    boxShadow: [
      BoxShadow(blurRadius: 3.0, spreadRadius: 1.0, color: Colors.grey)
  ]);
}
