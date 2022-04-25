import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ramadan_kareem/models/users_model.dart';
import 'package:ramadan_kareem/shared/cache_helper/cache_helper.dart';
import 'package:ramadan_kareem/shared/components/components/network_check.dart';
import 'package:ramadan_kareem/shared/components/components/snack_bar.dart';
import 'package:ramadan_kareem/shared/components/constants.dart';
import 'package:sizer/sizer.dart';

Future<void> formatData(BuildContext context) async {
  hasNetwork().then((connected) {
    if (connected) {
      for (var user in userModel.data
          .where((user) => user.approved == null || user.pendingEdit == null)) {
        log('user ${user.name} needs to refreshed ' + user.toString());

        FirebaseFirestore.instance
            .collection('users')
            .doc(user.deviceId)
            .update({
          // 'name': name,
          // 'doaa': doaa,
          // 'device id': deviceId,
          'approved': false,
          // 'time': time,
          'nameUpdate': '',
          'doaaUpdate': '',
          'pendingEdit': false,
        }).then((_) {

          snkbar(
            context,
            '${user.name} formatted',
            seconds: 1,
            backgroundColor: Colors.green,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          );
        }).catchError((error) {
          log('error when format users ' + error.toString());

          snkbar(
            context,
            error.toString(),
            backgroundColor: Colors.red,
          );
        });
      }

      snkbar(context, 'تم');
    } else {
      snkbar(
        context,
        'أنت غير متصل بالإنترنت !',
        seconds: 1,
        backgroundColor: Colors.red,
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      );
    }
  });
}
