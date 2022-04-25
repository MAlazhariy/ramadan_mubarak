import 'dart:developer';

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
  UserDocsModel newUsers = userModel;
  UserDocsModel usersUpdate = userModel;

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
              setState(() {
                // UserDocsModel newUsers = userModel;
                // UserDocsModel usersUpdate = userModel;
              });

              snkbar(
                context,
                'screen refreshed',
                seconds: 3,
                // backgroundColor: Colors.green,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
            icon: const Icon(Icons.refresh),
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
              Row(
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
                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: const Color(0xE639444C).withAlpha(150),
                    ),
                    iconSize: 21,
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    onPressed: () {
                      getNotApprovedCollection().then((value) {
                        newUsers = UserDocsModel.fromCollection(value);

                        snkbar(
                          context,
                          'تم جلب الطلبات الجديدة',
                          seconds: 1,
                          backgroundColor: Colors.green,
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        );

                        setState(() {});
                      });
                    },
                  ),
                ],
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
                      ),
                    ),
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
                              // await reject(user);
                              await rejectTest(user);
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
              Row(
                children: [
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
                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: const Color(0xE639444C).withAlpha(150),
                    ),
                    iconSize: 21,
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    onPressed: () {
                      getUpdatedCollection().then((value) {
                        usersUpdate = UserDocsModel.fromCollection(value);

                        snkbar(
                          context,
                          'تم جلب طلبات التعديلات',
                          seconds: 1,
                          backgroundColor: Colors.green,
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        );

                        setState(() {});
                      });
                    },
                  ),
                ],
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
    log('calling pendingNewUsers');
    return newUsers.data.where((user) => user.approved == false).toList();
  }

  List<UserDataModel> pendingUpdates() {
    return usersUpdate.data.where((user) => user.pendingEdit == true).toList();
  }

  Future<void> approve(UserDataModel user) async {
    hasNetwork().then((connected) {
      if (connected) {
        FirebaseFirestore.instance.collection('users').doc(user.id).update({
          'approved': true,
        }).then((_) {
          setState(() {
            if (userModel.data.contains(user)) {
              // change data in variable
              var index = userModel.data.indexOf(user);
              userModel.data[index].approved = true;
              // Save updates in local
              Cache.saveData(userModel.toList());
            }
            if (newUsers.data.contains(user)) {
              var index = newUsers.data.indexOf(user);
              newUsers.data[index].approved = true;
            }
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
        }).catchError((e) {
          log('error when approve: ${e.toString()}');

          snkbar(
            context,
            'error when approve: ${e.toString()}',
            seconds: 8,
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

  Future<void> reject(UserDataModel user) async {
    hasNetwork().then((connected) {
      if (connected) {
        Map<String, dynamic> userMap = user.toMap();
        userMap.remove('time');


        FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .set(userMap)
            .then((_) {
          setState(() {
            if (userModel.data.contains(user)) {
              // remove user from variable if available
              var index = userModel.data.indexOf(user);
              var data = userModel.data;
              data[index].nameUpdate = 'hiiii this is a test from mostafa alazhariy';

              userModel.data[index].nameUpdate = 'hi there';
              log(user.toMap().toString());
              data.removeAt(index);
              userModel.data = data;

              // Save updates in local
              Cache.saveData(userModel.toList());
            }
            if (newUsers.data.contains(user)) {
              var index = newUsers.data.indexOf(user);
              var data = newUsers.data;
              data.removeAt(index);
              newUsers.data = data;
            }
          });

          snkbar(context, '${user.name} rejected',
              seconds: 8,
              backgroundColor: Colors.red,
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              actionLabel: 'UNDO', action: () {
            FirebaseFirestore.instance
                .collection('users')
                .doc(user.id)
                .update(user.toMap())
                .then((value) {
              setState(() {
                if (userModel.data.length == newUsers.length) {
                  // new users == userModel

                  userModel.data.add(user);
                  newUsers.data.add(user);
                  // Save updates in local
                  Cache.saveData(userModel.toList());
                } else {
                  newUsers.data.add(user);
                }
              });
            });
          });
        }).catchError((e) {
          log('error when reject: ${e.toString()}');

          snkbar(
            context,
            'error when reject: ${e.toString()}',
            seconds: 8,
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

  Future<void> rejectTest(UserDataModel user) async {
    hasNetwork().then((connected) {
      if (connected) {
        Map<String, dynamic> userMap = user.toMap();
        log('user map: ${userMap.toString()}');
        userMap.remove('time');
        log('user keys after removing "time" key from "user map": ${user.toMap().keys.toString()}');
        log('--------------------- setState');


        // FirebaseFirestore.instance
        //     .collection('users')
        //     .doc(user.id)
        //     .set(userMap)
        //     .then((_) {
        //   setState(() {
            if (userModel.data.contains(user)) {
              // remove user from variable if available
              var index = userModel.data.indexOf(user);
              var data = userModel.data;
              log('create copy from userModel "data"');
              log('data[$index] = ${data[index].toMap().toString()}');
              log('user = ${user.toMap().toString()}');
              log('--------------------- change data nameUpdate');
              data[index].nameUpdate = '########################################';
              data[index].toMap()['nameUpdate'] = 'hi there how are you?';
              log('data[$index] after changing nameUpdate: ${data[index].toMap().toString()}');
              log('user after changing nameUpdate in data: ${user.toMap().toString()}');
              log('userModel after changing nameUpdate in data: ${userModel.data[index].toMap().toString()}');
              log('newUsers after changing nameUpdate in data: ${newUsers.data[index].toMap().toString()}');
              log('pendingNewUsers() after changing nameUpdate in data: ${pendingNewUsers().first.toMap().toString()}');
              log('---------------------');

              data.removeAt(index);
              userModel.data = data;

              // Save updates in local
              Cache.saveData(userModel.toList());
            }
            if (newUsers.data.contains(user)) {
              var index = newUsers.data.indexOf(user);
              var data = newUsers.data;
              data.removeAt(index);
              newUsers.data = data;
            }
          // });

          snkbar(context, '${user.name} rejected',
              seconds: 8,
              backgroundColor: Colors.red,
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              actionLabel: 'UNDO', action: () {
                // FirebaseFirestore.instance
                //     .collection('users')
                //     .doc(user.id)
                //     .update(user.toMap())
                //     .then((value) {
                  setState(() {
                    if (userModel.data.length == newUsers.length) {
                      // new users == userModel

                      userModel.data.add(user);
                      newUsers.data.add(user);
                      // Save updates in local
                      Cache.saveData(userModel.toList());
                    } else {
                      newUsers.data.add(user);
                    }
                  });
                // });
              });
        // }).catchError((e) {
        //   log('error when reject: ${e.toString()}');
        //
        //   snkbar(
        //     context,
        //     'error when reject: ${e.toString()}',
        //     seconds: 8,
        //     backgroundColor: Colors.red,
        //     textStyle: const TextStyle(
        //       color: Colors.white,
        //       fontSize: 13,
        //       fontWeight: FontWeight.w600,
        //     ),
        //   );
        // });
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
    hasNetwork().then((connected) {
      if (connected) {
        FirebaseFirestore.instance.collection('users').doc(user.id).update({
          'name': user.nameUpdate,
          'doaa': user.doaaUpdate,
          // 'device id': deviceId,
          'approved': true,
          // 'time': time,
          'nameUpdate': '',
          'doaaUpdate': '',
          'pendingEdit': false,
        }).then((_) {
          setState(() {
            if (userModel.data.contains(user)) {
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
            }
            if (usersUpdate.data.contains(user)) {
              var index = usersUpdate.data.indexOf(user);
              usersUpdate.data[index].name = user.nameUpdate;
              usersUpdate.data[index].doaa = user.doaaUpdate;
              usersUpdate.data[index].approved = true;

              usersUpdate.data[index].nameUpdate = '';
              usersUpdate.data[index].doaaUpdate = '';
              usersUpdate.data[index].pendingEdit = false;
            }
          });

          snkbar(
            context,
            '${user.name} updates approved',
            seconds: 1,
            backgroundColor: Colors.green,
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          );
        }).catchError((e) {
          log('error when approveUpdates: ${e.toString()}');

          snkbar(
            context,
            'error when approveUpdates: ${e.toString()}',
            seconds: 8,
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

  Future<void> rejectUpdates(UserDataModel user) async {

    hasNetwork().then((connected) {
      if (connected) {
        FirebaseFirestore.instance.collection('users').doc(user.id).update({
          // 'name': user.nameUpdate,
          // 'doaa': user.doaaUpdate,
          // 'device id': deviceId,
          // 'approved': false,
          // 'time': time,
          'nameUpdate': '',
          'doaaUpdate': '',
          'pendingEdit': false,
        }).then((_) {
          setState(() {
            if (userModel.data.contains(user)) {
              // Save updates to variable
              var index = userModel.data.indexOf(user);

              // userModel.data[index].nameUpdate = '';
              usersUpdate.data[index].doaaUpdate = '12345';
              userModel.data[index].doaaUpdate = '123';
              userModel.data[index].pendingEdit = false;

              // Save updates in local
              Cache.saveData(userModel.toList());
            }
            if (usersUpdate.data.contains(user)) {
              var index = usersUpdate.data.indexOf(user);

              usersUpdate.data[index].nameUpdate = '123';
              usersUpdate.data[index].doaaUpdate = '';
              usersUpdate.data[index].pendingEdit = false;
            }

          });

          snkbar(context, '${user.name} updates rejected',
              seconds: 6,
              backgroundColor: Colors.red,
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              actionLabel: 'UNDO', action: () {
                log('action tapped -> user.pendingEdit = ${user.pendingEdit}');
                log('action tapped -> user.pendingEdit = ${user.pendingEdit}');
            FirebaseFirestore.instance
                .collection('users')
                .doc(user.id)
                .set(user.toMap())
                .then((value) {
              log('after set firebase func. -> user.pendingEdit = ${user.pendingEdit}');
              setState(() {
                if (userModel.data.length == usersUpdate.length) {
                  var index = userModel.data.indexOf(user);

                  userModel.data[index].nameUpdate = user.nameUpdate;
                  userModel.data[index].doaaUpdate = user.doaaUpdate;
                  userModel.data[index].pendingEdit = user.pendingEdit;

                  // Save updates in local
                  Cache.saveData(userModel.toList());
                }

                var index = usersUpdate.data.indexOf(user);

                usersUpdate.data[index].nameUpdate = user.nameUpdate;
                usersUpdate.data[index].doaaUpdate = user.doaaUpdate;
                usersUpdate.data[index].pendingEdit = user.pendingEdit;
              });
            });
          });
        }).catchError((e) {
          log('error when rejectUpdates: ${e.toString()}');

          snkbar(
            context,
            'error when rejectUpdates: ${e.toString()}',
            seconds: 8,
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
}
