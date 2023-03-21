import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ramadan_kareem/helpers/notification_ready_funcs.dart';
import 'package:ramadan_kareem/helpers/push_to.dart';
import 'package:ramadan_kareem/view/screens/settings/update_data_screen.dart';
import 'package:ramadan_kareem/view/base/custom_dialog.dart';
import 'package:ramadan_kareem/view/base/dialog_buttons.dart';
import 'package:ramadan_kareem/ztrash/shared/components/constants.dart';
import 'package:ramadan_kareem/ztrash/shared/styles.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot<Map<String, dynamic>>? lastDoc;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.sp,
          vertical: 10.sp,
        ),
        child: Column(
          children: [
            // screen design
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// تعديل الدعاء أو الاسم
                    if (deviceId != null && (deviceId?.isNotEmpty ?? false))
                      ListTile(
                        title: Text(
                          'تعديل الاسم أو الدعاء',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                            color: greyColor,
                            // color: pinkColor,
                          ),
                        ),
                        // subtitle: Text(
                        //   'اضغط لتعديل الاسم أو الدعاء',
                        //   style: TextStyle(
                        //     fontSize: 9.sp,
                        //     fontWeight: FontWeight.w500,
                        //     // height: 1.5,
                        //     color: greyColor.withAlpha(130),
                        //   ),
                        // ),
                        onTap: () {
                          pushTo(context, const UpdateUserDataScreen());
                        },
                        leading: const Icon(
                          Icons.edit_outlined,
                          color: greyColor,
                          // color: pinkColor,
                        ),
                      ),

                    const Divider(thickness: 1),

                    /// إعادة ضبط الإشعارات
                    ListTile(
                      onTap: () async {
                        readyShowScheduledNotification(context);
                      },
                      title: Text(
                        'إعادة ضبط الإشعارات',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          color: greyColor,
                        ),
                      ),
                      leading: const Icon(Icons.notification_important_outlined),
                    ),

                    /// التواصل مع المبرمج
                    ListTile(
                      title: Text(
                        'تواصل مع المبرمج',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          color: greyColor,
                        ),
                      ),
                      onTap: () async {
                        await launch(
                          mailUs(),
                        );
                      },
                      leading: const Icon(Icons.email_outlined),
                    ),

                    /// عن التطبيق
                    ListTile(
                      title: Text(
                        'عن التطبيق',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          color: greyColor,
                        ),
                      ),
                      onTap: () {
                        showCustomDialog(
                          context: context,
                          title: 'عن التطبيق',
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'رمضان مبارك هو تطبيق بيخلينا ندعي لبعض وبيفكرنا قبل الفطار 🤲',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                  color: greyColor,
                                ),
                              ),

                              SizedBox(height: 10.sp),
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  'فكرة التطبيق بسيطة جداً',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                    color: greyColor,
                                  ),
                                ),
                              ),

                              SizedBox(height: 5.sp),
                              Text(
                                'لما نفتح التطبيق هنلاقي ناس ممكن ما نكونش عارفينهم، هندعيلهم بظهر الغيب، والملك هيرد "ولك بمثل" فيكون دعاءنا أقرب للإجابة لينا وللمدعو ليه، زي ما قال سيدنا النبي ﷺ، واحنا كمان اسمنا بيكون ظاهر للمستخدمين التانيين وبيدعولنا هما كمان 💙',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                  color: greyColor,
                                ),
                              ),

                              // SizedBox(height: 10.sp),
                              // Align(
                              //   alignment: AlignmentDirectional.centerStart,
                              //   child: Text(
                              //     'شكراً للقارئ أحمد صقر على صوت الإشعارات',
                              //     style: TextStyle(
                              //       fontSize: 9.sp,
                              //       fontWeight: FontWeight.w500,
                              //       height: 1.5,
                              //       color: greyColor,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          buttons: [
                            DialogButton(
                              title: 'رجوع',
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                      leading: const Icon(Icons.info_outline),
                    ),

                    /// مشاركة التطبيق
                    // if (allowedDeviceIDs.contains(deviceId))
                    ListTile(
                      title: Text(
                        'مشاركة التطبيق',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          color: greyColor,
                        ),
                      ),
                      onTap: () async {
                        await Share.share(
                          'رمضان مبارك 🌙💙\nرمضان مبارك هو تطبيق بيخلينا ندعي لبعض وبيفكرنا قبل الفطار 🤲\nلما تنزل التطبيق وتفتحه هتلاقي ناس ممكن ما تكونش عارفهم بس هتدعيلهم بظهر الغيب والملك هيرد عليك "ولك بمثل" فيكون دعاءك أقرب للإجابة ليك وللمدعو ليه، زي ما قال سيدنا النبي ﷺ 💙\nتقدر تنضم لينا وتنزل التطبيق من الرابط ده: https://play.google.com/store/apps/details?id=malazhariy.ramadan_kareem',
                          subject: 'رمضان مبارك 🌙', // subject for emails only
                        );
                      },
                      leading: const Icon(Icons.share_outlined),
                      // leading: const Icon(Icons.favorite_border),
                    ),

                    /// صفحة الإشراف
                    if (deviceId == '027e5a15c8257dff' || // My xiaomi
                        deviceId == '3a9a32a9d64d9dcf' || // My xiaomi برضو
                        deviceId == 'd592267254ebbd0e') // my emulator
                      ListTile(
                        title: Text(
                          'صفحة الإشراف',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                            color: greyColor,
                          ),
                        ),
                        onTap: () {
                          //
                        },
                        leading: const Icon(Icons.admin_panel_settings),
                      ),

                    // pagination
                    ListTile(
                      title: Text(
                        'pagination',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          color: greyColor,
                        ),
                      ),
                      onTap: () async {
                        /// get limitation
                        // try{
                        //   DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance.collection('users').doc('2d5d084e1babf51d').get();
                        //   log('We have got document "${doc.id} - ${doc.data()['name']}"');
                        //
                        //   const int limitation = 20;
                        //   int dataSize = 0;
                        //
                        //   QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance.collection('users').orderBy('time').startAfterDocument(doc).limit(limitation).get();
                        //   log('--- size = ${data.size}');
                        //   dataSize = data.size;
                        //   data.docs.forEach((user) {
                        //     log('name: ${user['name']}');
                        //   });
                        //   if(dataSize < limitation){
                        //     final int remainingDataSize = limitation - dataSize;
                        //     log('---- getting remaining $remainingDataSize data from Firebase');
                        //     QuerySnapshot<Map<String, dynamic>> remainData = await FirebaseFirestore.instance.collection('users').orderBy('time').limit(remainingDataSize).get();
                        //     dataSize += remainData.size;
                        //     log('--- total size = $dataSize');
                        //     remainData.docs.forEach((user) {
                        //       log('name: ${user['name']}');
                        //     });
                        //   }
                        //
                        // } catch(e){
                        //   log('إلحق يزميلي إيرور: $e');
                        // }

                        /// get nested limitation
                        try {
                          if (lastDoc == null) {
                            // 15
                            // 18
                            await FirebaseFirestore.instance.collection('users').orderBy('time').limit(1).get().then((value) {
                              lastDoc = value.docs.first;
                            });
                          }
                          log('last document: id:"${lastDoc?.id}, name:${lastDoc?.data()?['name']}"');

                          const int limit = 20;
                          int _dataSize = 0;

                          QuerySnapshot<Map<String, dynamic>> data =
                              await FirebaseFirestore.instance.collection('users').orderBy('time').startAfterDocument(lastDoc!).limit(limit).get();
                          log('--- size = ${data.size}');
                          _dataSize = data.size;
                          data.docs.forEach((user) {
                            log('name: ${user['name']}');
                          });

                          if (_dataSize >= limit) {
                            lastDoc = data.docs.last;
                          } else {
                            final int remainingDataSize = limit - _dataSize;
                            log('---- getting remaining $remainingDataSize data from Firebase');
                            QuerySnapshot<Map<String, dynamic>> remainData =
                                await FirebaseFirestore.instance.collection('users').orderBy('time').limit(remainingDataSize).get();
                            _dataSize += remainData.size;
                            log('--- total size = $_dataSize');
                            remainData.docs.forEach((user) {
                              log('name: ${user['name']}');
                            });

                            lastDoc = remainData.docs.last;
                          }
                        } catch (e) {
                          log('إلحق يزميلي إيرور: $e');
                        }
                      },
                      leading: const Icon(Icons.warning_amber),
                      // leading: const Icon(Icons.favorite_border),
                    ),

                    // pagination test
                    ListTile(
                      title: Text(
                        'pagination TEST',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          color: greyColor,
                        ),
                      ),
                      onTap: () async {
                        /// get limitation
                        // try{
                        //   DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance.collection('users').doc('2d5d084e1babf51d').get();
                        //   log('We have got document "${doc.id} - ${doc.data()['name']}"');
                        //
                        //   const int limitation = 20;
                        //   int dataSize = 0;
                        //
                        //   QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance.collection('users').orderBy('time').startAfterDocument(doc).limit(limitation).get();
                        //   log('--- size = ${data.size}');
                        //   dataSize = data.size;
                        //   data.docs.forEach((user) {
                        //     log('name: ${user['name']}');
                        //   });
                        //   if(dataSize < limitation){
                        //     final int remainingDataSize = limitation - dataSize;
                        //     log('---- getting remaining $remainingDataSize data from Firebase');
                        //     QuerySnapshot<Map<String, dynamic>> remainData = await FirebaseFirestore.instance.collection('users').orderBy('time').limit(remainingDataSize).get();
                        //     dataSize += remainData.size;
                        //     log('--- total size = $dataSize');
                        //     remainData.docs.forEach((user) {
                        //       log('name: ${user['name']}');
                        //     });
                        //   }
                        //
                        // } catch(e){
                        //   log('إلحق يزميلي إيرور: $e');
                        // }

                        /// get nested limitation
                        try {
                          if (lastDoc == null) {
                            // 15
                            await FirebaseFirestore.instance
                                .collection('users')
                                .orderBy('time')
                                .where('time', isGreaterThan: 1678485205532487)
                                .limit(5)
                                .get()
                                .then((value) {
                              debugPrint('value length: ${value.docs.length}');
                              if (value.docs.isNotEmpty) {
                                lastDoc = value.docs.last;
                              }

                              value.docs.forEach((user) {
                                log('name: ${user['name']}');
                              });
                            });
                          }
                          log('last document: id:"${lastDoc?.id}, name:${lastDoc?.data()?['name']}"');

                          //   const int limit = 20;
                          //   int _dataSize = 0;
                          //
                          //   QuerySnapshot<Map<String, dynamic>> data =
                          //   await FirebaseFirestore.instance.collection('users').orderBy('time').startAfterDocument(lastDoc!).limit(limit).get();
                          //   log('--- size = ${data.size}');
                          //   _dataSize = data.size;
                          //   data.docs.forEach((user) {
                          //     log('name: ${user['name']}');
                          //   });
                          //
                          //   if (_dataSize >= limit) {
                          //     lastDoc = data.docs.last;
                          //   } else {
                          //     final int remainingDataSize = limit - _dataSize;
                          //     log('---- getting remaining $remainingDataSize data from Firebase');
                          //     QuerySnapshot<Map<String, dynamic>> remainData =
                          //     await FirebaseFirestore.instance.collection('users').orderBy('time').limit(remainingDataSize).get();
                          //     _dataSize += remainData.size;
                          //     log('--- total size = $_dataSize');
                          //     remainData.docs.forEach((user) {
                          //       log('name: ${user['name']}');
                          //     });
                          //
                          //     lastDoc = remainData.docs.last;
                          //   }
                        } catch (e) {
                          log('إلحق يزميلي إيرور: $e');
                        }
                      },
                      leading: const Icon(Icons.warning_amber),
                      // leading: const Icon(Icons.favorite_border),
                    ),

                    // get count
                    ListTile(
                      title: Text(
                        'get count',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          color: greyColor,
                        ),
                      ),
                      onTap: () async {
                        await FirebaseFirestore.instance.collection('users').orderBy('time').count().get().then((value) {
                          var count = value.count;
                          debugPrint('count is: $count');
                        });
                      },
                      leading: const Icon(Icons.warning_amber),
                      // leading: const Icon(Icons.favorite_border),
                    ),
                  ],
                ),
              ),
            ),

            // back button
            // Align(
            //   alignment: AlignmentDirectional.center,
            //   child: MaterialButton(
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //     padding: const EdgeInsets.all(0),
            //     shape: const StadiumBorder(),
            //     highlightElevation: 5,
            //     highlightColor: pinkColor.withAlpha(50),
            //     child: Ink(
            //       decoration: BoxDecoration(
            //         color: pinkColor,
            //         borderRadius: BorderRadius.circular(15.sp),
            //       ),
            //       child: Container(
            //         padding: const EdgeInsets.symmetric(
            //           vertical: 15,
            //           horizontal: 50,
            //         ),
            //         width: 50.w,
            //         child: Text(
            //           'رجوع',
            //           style: Theme.of(context).textTheme.headline2?.copyWith(
            //                 color: Colors.white,
            //                 fontSize: 13.sp,
            //                 fontWeight: FontWeight.w600,
            //               ),
            //           textAlign: TextAlign.center,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

String mailUs({
  String subject = '',
  String body = '',
}) {
  const String email = 'malazhariy.ramadankareem@gmail.com';
  return 'mailto:$email?subject=$subject&body=$body';
}

int counter = 0;
