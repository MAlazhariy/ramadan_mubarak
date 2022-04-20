import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ramadan_kareem/models/users_model.dart';
import 'package:ramadan_kareem/shared/components/components/snack_bar.dart';
import 'package:ramadan_kareem/shared/components/constants.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  void approveUpdates(UserDataModel user) async {
    FirebaseFirestore.instance.collection('users').doc(user.deviceId).update({
      'name': user.nameUpdate,
      'doaa': user.doaaUpdate,
      'nameUpdate': '',
      'doaaUpdate': '',
      'pendingEdit': false,
    }).then((_) {

      setState((){
        var index = userModel.data.indexOf(user);
        userModel.data[index].name = user.nameUpdate;
        userModel.data[index].doaa = user.doaaUpdate;
        userModel.data[index].pendingEdit = false;
      });

      snkbar(
        context,
        '${user.name} approved successfully',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
