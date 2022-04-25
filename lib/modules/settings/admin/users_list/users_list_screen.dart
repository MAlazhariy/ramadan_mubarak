import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ramadan_kareem/models/users_model.dart';
import 'package:ramadan_kareem/modules/settings/admin/add_data/add_user.dart';
import 'package:ramadan_kareem/modules/settings/admin/format_data/format_data.dart';
import 'package:ramadan_kareem/modules/settings/admin/review_data/pending_data_screen.dart';
import 'package:ramadan_kareem/modules/settings/admin/users_list/user_info_screen.dart';
import 'package:ramadan_kareem/shared/components/components/network_check.dart';
import 'package:ramadan_kareem/shared/components/components/push.dart';
import 'package:ramadan_kareem/shared/components/components/snack_bar.dart';
import 'package:ramadan_kareem/shared/components/constants.dart';
import 'package:ramadan_kareem/shared/styles.dart';
import 'package:sizer/sizer.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({Key key}) : super(key: key);

  @override
  State<UsersListScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<UsersListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('قائمة المستخدمين (${userModel.data.length})'),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       setState(() {});
        //     },
        //     icon: const Icon(Icons.refresh),
        //   ),
        // ],
      ),

      // makes keyboard shown over the bottom sheet
      resizeToAvoidBottomInset: false,

      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 40,
          ),
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // New users
              if(pendingNewUsers().isNotEmpty)
                Text(
                'مستخدمين جدد',
                style: Theme.of(context).textTheme.headline1.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                  height: 1.4,
                  color: const Color(0xE639444C),
                  // color: Colors.black38,
                  // letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              for (var user in pendingNewUsers())
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: MaterialButton(
                    onPressed: () {
                      push(context, UserInfoScreen(user: user));
                    },
                    child: Container(
                      color: pinkColor.withAlpha(5),
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// name
                          Text(
                            user.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: pinkColor,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                              fontSize: 13.sp,
                            ),
                          ),
                          const SizedBox(height: 6),

                          /// Document id
                          Text(
                            user.id,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: black1,
                              // height: 1.2,
                              fontWeight: FontWeight.w500,
                              fontSize: 9.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    padding: EdgeInsets.zero,
                    splashColor: pinkColor.withAlpha(7),
                  ),
                ),
              const SizedBox(height: 20),

              // New users
              Text(
                'كل الأعضاء',
                style: Theme.of(context).textTheme.headline1.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                      height: 1.4,
                      color: const Color(0xE639444C),
                      // color: Colors.black38,
                      // letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 10),
              for (var user in userModel.data.reversed)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: MaterialButton(
                    onPressed: () {
                      push(context, UserInfoScreen(user: user));
                    },
                    child: Container(
                      color: pinkColor.withAlpha(5),
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// name
                          Text(
                            user.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: pinkColor,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                              fontSize: 13.sp,
                            ),
                          ),
                          const SizedBox(height: 6),

                          /// Document id
                          Text(
                            user.id,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: black1,
                              // height: 1.2,
                              fontWeight: FontWeight.w500,
                              fontSize: 9.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    padding: EdgeInsets.zero,
                    splashColor: pinkColor.withAlpha(7),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  List<UserDataModel> pendingNewUsers() {
    return userModel.data.where((user) => user.approved == false).toList();
  }

}
