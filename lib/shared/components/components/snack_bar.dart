import 'package:flutter/material.dart';

void snkbar(BuildContext context, String msg){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)));
}
