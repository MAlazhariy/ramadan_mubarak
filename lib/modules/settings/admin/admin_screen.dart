import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ramadan_kareem/models/users_model.dart';
import 'package:ramadan_kareem/modules/settings/admin/add_data/add_user.dart';
import 'package:ramadan_kareem/modules/settings/admin/format_data/format_data.dart';
import 'package:ramadan_kareem/modules/settings/admin/review_data/pending_data_screen.dart';
import 'package:ramadan_kareem/modules/settings/admin/users_list/users_list_screen.dart';
import 'package:ramadan_kareem/shared/components/components/network_check.dart';
import 'package:ramadan_kareem/shared/components/components/push.dart';
import 'package:ramadan_kareem/shared/components/components/snack_bar.dart';
import 'package:ramadan_kareem/shared/components/constants.dart';
import 'package:ramadan_kareem/shared/styles.dart';
import 'package:sizer/sizer.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  void initState() {
    super.initState();

    hasNetwork().then((connected) {
      if (!connected) {
        snkbar(
          context,
          'أنت غير متصل بالإنترنت',
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
        title: const Text('صفحة الإشراف'),
      ),

      // makes keyboard shown over the bottom sheet
      resizeToAvoidBottomInset: false,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 40,
          ),
          child: Column(
            children: [

              // pending data
              // Align(
              //   alignment: AlignmentDirectional.center,
              //   child: MaterialButton(
              //     onPressed: () {
              //       push(context, const PendingDataScreen());
              //     },
              //     padding: const EdgeInsets.all(0),
              //     shape: const StadiumBorder(),
              //     highlightElevation: 5,
              //     highlightColor: pinkColor.withAlpha(50),
              //     child: Ink(
              //       decoration: BoxDecoration(
              //         color: greyColor,
              //         borderRadius: BorderRadius.circular(15.sp),
              //       ),
              //       child: Container(
              //         padding: const EdgeInsetsDirectional.only(
              //           top: 15,
              //           bottom: 16,
              //           start: 50,
              //           end: 15,
              //         ),
              //         width: 70.w,
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             const Icon(
              //               Icons.pending_actions,
              //               color: Colors.white,
              //             ),
              //             const SizedBox(width: 10),
              //             Text(
              //               'مراجعة البيانات',
              //               style:
              //                   Theme.of(context).textTheme.headline2?.copyWith(
              //                         color: Colors.white,
              //                         fontSize: 13.sp,
              //                         fontWeight: FontWeight.w600,
              //                         height: 1.3,
              //                       ),
              //               textAlign: TextAlign.center,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // check pending data button
              const SizedBox(height: 20),

              // Show all users
              Align(
                alignment: AlignmentDirectional.center,
                child: MaterialButton(
                  onPressed: () async {
                    push(context, const UsersListScreen());
                  },
                  padding: const EdgeInsets.all(0),
                  shape: const StadiumBorder(),
                  highlightElevation: 5,
                  highlightColor: pinkColor.withAlpha(50),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: greyColor,
                      borderRadius: BorderRadius.circular(15.sp),
                    ),
                    child: Container(
                      padding: const EdgeInsetsDirectional.only(
                        top: 15,
                        bottom: 16,
                        start: 50,
                        end: 15,
                      ),
                      width: 70.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.supervised_user_circle_outlined,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'عرض المستخدمين',
                            style:
                            Theme.of(context).textTheme.headline2?.copyWith(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Add a new user
              Align(
                alignment: AlignmentDirectional.center,
                child: MaterialButton(
                  onPressed: () {
                    push(context, const AddNewUserScreen());
                  },
                  padding: const EdgeInsets.all(0),
                  shape: const StadiumBorder(),
                  highlightElevation: 5,
                  highlightColor: pinkColor.withAlpha(50),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: greyColor,
                      borderRadius: BorderRadius.circular(15.sp),
                    ),
                    child: Container(
                      padding: const EdgeInsetsDirectional.only(
                        top: 15,
                        bottom: 16,
                        start: 50,
                        end: 15,
                      ),
                      width: 70.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.person_add_alt,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'إضافة مستخدم',
                            style:
                                Theme.of(context).textTheme.headline2?.copyWith(
                                      color: Colors.white,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Divider(height: 1, thickness: 1, indent: 20, endIndent: 20),
              const SizedBox(height: 20),

              // Handling users fields
              Align(
                alignment: AlignmentDirectional.center,
                child: MaterialButton(
                  onPressed: () async {
                    await formatData(context);
                  },
                  padding: const EdgeInsets.all(0),
                  shape: const StadiumBorder(),
                  highlightElevation: 5,
                  highlightColor: pinkColor.withAlpha(50),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: greyColor,
                      borderRadius: BorderRadius.circular(15.sp),
                    ),
                    child: Container(
                      padding: const EdgeInsetsDirectional.only(
                        top: 15,
                        bottom: 16,
                        start: 50,
                        end: 15,
                      ),
                      width: 70.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.published_with_changes,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'تهيئة البيانات',
                            style:
                            Theme.of(context).textTheme.headline2?.copyWith(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Reload data
              Align(
                alignment: AlignmentDirectional.center,
                child: MaterialButton(
                  onPressed: () async {
                    hasNetwork().then((value) async {
                      if(value){
                        await initGetAndSaveData().then((_) {

                          snkbar(
                            context,
                            'تم تحميل جميع البيانات: ${userModel?.length}',
                            seconds: 3,
                            backgroundColor: Colors.green,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          );

                        });
                      } else {
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

                  },
                  padding: const EdgeInsets.all(0),
                  shape: const StadiumBorder(),
                  highlightElevation: 5,
                  highlightColor: pinkColor.withAlpha(50),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: greyColor,
                      borderRadius: BorderRadius.circular(15.sp),
                    ),
                    child: Container(
                      padding: const EdgeInsetsDirectional.only(
                        top: 15,
                        bottom: 16,
                        start: 50,
                        end: 15,
                      ),
                      width: 70.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.cloud_download_outlined,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'تحميل البيانات',
                            style:
                            Theme.of(context).textTheme.headline2?.copyWith(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
