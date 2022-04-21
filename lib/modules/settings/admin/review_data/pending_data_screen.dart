import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ramadan_kareem/models/users_model.dart';
import 'package:ramadan_kareem/modules/settings/admin/review_data/user_edit_screen.dart';
import 'package:ramadan_kareem/modules/settings/admin/review_data/user_edit_updates_screen.dart';
import 'package:ramadan_kareem/shared/cache_helper/cache_helper.dart';
import 'package:ramadan_kareem/shared/components/components/network_check.dart';
import 'package:ramadan_kareem/shared/components/components/push.dart';
import 'package:ramadan_kareem/shared/components/components/snack_bar.dart';
import 'package:ramadan_kareem/shared/components/constants.dart';
import 'package:ramadan_kareem/shared/network/firebase_funcs.dart';
import 'package:ramadan_kareem/shared/styles.dart';
import 'package:sizer/sizer.dart';

class PendingDataScreen extends StatefulWidget {
  const PendingDataScreen({Key key}) : super(key: key);

  @override
  State<PendingDataScreen> createState() => _PendingDataScreenState();
}

class _PendingDataScreenState extends State<PendingDataScreen> {
  @override
  void initState() {
    super.initState();

    hasNetwork().then((connected) {
      if (!connected) {
        snkbar(
          context,
          'أنت غير متصل بالإنترنت !',
          seconds: 4,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مراجعة البيانات'),
        actions: [
          IconButton(
            onPressed: () {
              getNotApprovedCollection().then((value) {
                userModel = UserDocsModel.fromCollection(value);

                setState(() {});
              });
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              getUpdatedCollection().then((value) {
                userModel = UserDocsModel.fromCollection(value);

                setState(() {});
              });
            },
            icon: const Icon(Icons.system_update_alt_outlined),
          ),
        ],
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
              Text(
                'طلبات جديدة',
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(thickness: 1),
                    // user details
                    Container(
                        color: pinkColor.withAlpha(15),
                        width: double.maxFinite,
                        padding: const EdgeInsets.symmetric(
                          vertical: 7,
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
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(
                              height: 6.sp,
                            ),

                            /// doaa
                            Text(
                              user.doaa,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: black1,
                                height: 1.2,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        )),
                    // buttons
                    Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            onPressed: () async {
                              await approve(user);
                            },
                            child: Text(
                              'موافقة',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 3,
                            ),
                            color: Colors.green,
                            shape: const StadiumBorder(),
                            highlightColor: pinkColor.withAlpha(50),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              push(context, UserEditScreen(user: user));
                            },
                            color: Colors.grey,
                            child: Text(
                              'تعديل',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 3,
                            ),
                            shape: const StadiumBorder(),
                            highlightColor: pinkColor.withAlpha(50),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: MaterialButton(
                            onPressed: () async {
                              await reject(user);
                            },
                            color: Colors.red,
                            child: Text(
                              'رفض',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 3,
                            ),
                            shape: const StadiumBorder(),
                            highlightColor: pinkColor.withAlpha(50),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              Text(
                'طلبات التعديلات',
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
              for (var user in pendingUpdates())
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(thickness: 1),
                    // user details
                    Container(
                        color: pinkColor.withAlpha(15),
                        width: double.maxFinite,
                        padding: const EdgeInsets.symmetric(
                          vertical: 7,
                          horizontal: 0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /// name
                            Text(
                              user.nameUpdate,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: pinkColor,
                                height: 1.1,
                                fontWeight: FontWeight.w800,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(
                              height: 6.sp,
                            ),

                            /// doaa
                            Text(
                              user.doaaUpdate,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: black1,
                                height: 1.2,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        )),
                    // buttons
                    Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            onPressed: () async {
                              await approveUpdates(user);
                            },
                            child: Text(
                              'موافقة',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 3,
                            ),
                            color: Colors.green,
                            shape: const StadiumBorder(),
                            highlightColor: pinkColor.withAlpha(50),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              push(context, UserEditUpdatesScreen(user: user));
                            },
                            color: Colors.grey,
                            child: Text(
                              'تعديل',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 3,
                            ),
                            shape: const StadiumBorder(),
                            highlightColor: pinkColor.withAlpha(50),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: MaterialButton(
                            onPressed: () async {
                              await rejectUpdates(user);
                            },
                            color: Colors.red,
                            child: Text(
                              'رفض',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 3,
                            ),
                            shape: const StadiumBorder(),
                            highlightColor: pinkColor.withAlpha(50),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<UserDataModel> pendingNewUsers() {
    return userModel.data.where((user) => user.approved == false).toList();
  }

  List<UserDataModel> pendingUpdates() {
    return userModel.data.where((user) => user.pendingEdit == true).toList();
  }

  Future<void> approve(UserDataModel user) async {

    hasNetwork().then((connected){
      if (connected) {

        FirebaseFirestore.instance.collection('users').doc(user.deviceId).update({
          'approved': true,
        }).then((_) {
          setState(() {
            var index = userModel.data.indexOf(user);
            userModel.data[index].approved = true;
            // Save updates in local
            Cache.saveData(userModel.toList());
          });

          snkbar(
            context,
            '${user.name} approved successfully',
            seconds: 1,
            backgroundColor: Colors.green,
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          );
        });

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

  Future<void> reject(UserDataModel user) async {

    hasNetwork().then((connected){
      if (connected) {

        FirebaseFirestore.instance.collection('users').doc(user.deviceId).update({
          'approved': false,
          'time': null,
        }).then((_) {
          setState(() {
            var index = userModel.data.indexOf(user);
            userModel.data[index].time = null;
          });

          snkbar(
            context,
            '${user.name} rejected',
            seconds: 1,
            backgroundColor: Colors.red,
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          );
        });

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

  Future<void> approveUpdates(UserDataModel user) async {


    hasNetwork().then((connected){
      if (connected) {

        FirebaseFirestore.instance.collection('users').doc(deviceId).update({
          'name': user.nameUpdate,
          'doaa': user.doaaUpdate,
          // 'device id': deviceId,
          'approved': true,
          // 'time': time,
          'nameUpdate': '',
          'doaaUpdate': '',
          'pendingEdit': false,
        }).then((_) {
          // Save updates to variable
          var index = userModel.data.indexOf(user);
          userModel.data[index].name = user.nameUpdate;
          userModel.data[index].doaa = user.doaaUpdate;
          userModel.data[index].approved = true;

          userModel.data[index].nameUpdate = '';
          userModel.data[index].doaaUpdate = '';
          userModel.data[index].pendingEdit = false;

          // Save updates in local
          Cache.saveData(userModel.toList());
          setState(() {});

          snkbar(
            context,
            '${user.name} approved successfully',
            seconds: 1,
            backgroundColor: Colors.green,
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          );

        }).catchError((e){});

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

  Future<void> rejectUpdates(UserDataModel user) async {

    hasNetwork().then((connected){
      if (connected) {

        FirebaseFirestore.instance.collection('users').doc(deviceId).update({
          // 'name': user.nameUpdate,
          // 'doaa': user.doaaUpdate,
          // 'device id': deviceId,
          // 'approved': false,
          // 'time': time,
          'nameUpdate': '',
          'doaaUpdate': '',
          'pendingEdit': false,
        }).then((_) {
          // Save updates to variable
          var index = userModel.data.indexOf(user);
          userModel.data[index].name = user.nameUpdate;
          userModel.data[index].doaa = user.doaaUpdate;

          userModel.data[index].nameUpdate = '';
          userModel.data[index].doaaUpdate = '';
          userModel.data[index].pendingEdit = false;

          // Save updates in local
          Cache.saveData(userModel.toList());
          setState(() {});

          snkbar(
            context,
            '${user.name} approved successfully',
            seconds: 1,
            backgroundColor: Colors.green,
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          );

        }).catchError((e){});

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
}
