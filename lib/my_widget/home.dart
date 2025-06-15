import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget list_view({required String text,required IconData icon,required VoidCallback ontap}) {
  return ListTile(
    leading: Icon(
      icon,
      color: Colors.blue,
    ),
    title: Text(
      text,
      style: const TextStyle(fontSize: 18),
    ),
    onTap: ontap,
  );
}
