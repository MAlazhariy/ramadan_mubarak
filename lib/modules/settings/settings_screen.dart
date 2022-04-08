import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:ramadan_kareem/shared/cache_helper/cache_helper.dart';
import 'package:ramadan_kareem/shared/components/components/custom_dialog/custom_dialog.dart';
import 'package:ramadan_kareem/shared/components/components/custom_dialog/dialog_buttons.dart';
import 'package:ramadan_kareem/shared/components/components/description_text.dart';
import 'package:ramadan_kareem/shared/components/components/doaa_text.dart';
import 'package:ramadan_kareem/shared/styles.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    Key key,
    this.isShareAllowed = false,
  }) : super(key: key);

  final bool isShareAllowed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('الإعدادات'),
        ),
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
                    ListTile(
                      onTap: () async {
                        String id = await getId();

                        await launch(
                          mailUs(
                              subject: 'تعديل الدعاء أو الاسم',
                              body: 'سلام عليكم، '
                                  'هذا هو الرقم التعريفي الخاص بي: $id،  '
                                  'أنا أريد تغيير ..'
                              // '(من فضلك لا تحذفه)\n'
                              ),
                        );
                      },
                      title: Text(
                        'تعديل الدعاء أو الاسم',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          color: greyColor,
                        ),
                      ),
                      subtitle: Text(
                        'اضغط للتواصل مع المبرمج لتعديل الدعاء أو الاسم',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          // height: 1.5,
                          color: greyColor.withAlpha(150),
                        ),
                      ),
                      leading: const Icon(Icons.edit_outlined),
                    ),

                    /// التواصل مع المبرمج
                    ListTile(
                      onTap: () async {
                        await launch(
                          mailUs(
                            subject: 'أريد التواصل مع المبرمج',
                          ),
                        );
                      },
                      title: Text(
                        'تواصل مع المبرمج',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          color: greyColor,
                        ),
                      ),
                      // subtitle: Text(
                      //   'اضغط للتواصل مع المبرمج',
                      //   style: TextStyle(
                      //     fontSize: 10.sp,
                      //     fontWeight: FontWeight.w500,
                      //     // height: 1.5,
                      //     color: greyColor.withAlpha(150),
                      //   ),
                      // ),
                      leading: const Icon(Icons.email_outlined),
                    ),

                    /// مشاركة التطبيق
                    if (isShareAllowed)
                      ListTile(
                        onTap: () async {
                          await Share.share(
                            'رمضان مبارك 🌙💙\nرمضان مبارك هو تطبيق بيخلينا ندعي لبعض وبيفكرنا قبل الفطار 🤲\nلما تنزل التطبيق وتفتحه هتلاقي ناس ممكن ما تكونش عارفهم بس هتدعيلهم بظهر الغيب والملك هيرد عليك "ولك بمثل" فيكون دعاءك أقرب للإجابة ليك وللمدعو ليه، زي ما قال سيدنا النبي ﷺ 💙\nتقدر تنضم لينا وتنزل التطبيق من الرابط ده: https://play.google.com/store/apps/details?id=malazhariy.ramadan_kareem',
                            subject:
                                'رمضان مبارك 🌙', // subject for emails only
                          );
                        },
                        title: Text(
                          'مشاركة التطبيق مع صديق',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            color: greyColor,
                          ),
                        ),
                        // subtitle: Text(
                        //   'اضغط للتواصل مع المبرمج',
                        //   style: TextStyle(
                        //     fontSize: 10.sp,
                        //     fontWeight: FontWeight.w500,
                        //     // height: 1.5,
                        //     color: greyColor.withAlpha(150),
                        //   ),
                        // ),
                        leading: const Icon(Icons.share_outlined),
                      ),

                    /// عن التطبيق
                    ListTile(
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

                      title: Text(
                        'عن التطبيق',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          color: greyColor,
                        ),
                      ),
                      // subtitle: Text(
                      //   'اضغط للتواصل مع المبرمج',
                      //   style: TextStyle(
                      //     fontSize: 10.sp,
                      //     fontWeight: FontWeight.w500,
                      //     // height: 1.5,
                      //     color: greyColor.withAlpha(150),
                      //   ),
                      // ),
                      leading: const Icon(Icons.info_outline),
                    ),
                  ],
                ),
              ),
            ),

            // back button
            Align(
              alignment: AlignmentDirectional.center,
              child: RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: const EdgeInsets.all(0),
                shape: const StadiumBorder(),
                highlightElevation: 5,
                highlightColor: pinkColor.withAlpha(50),
                child: Ink(
                  decoration: BoxDecoration(
                    // gradient: const LinearGradient(
                    //   colors: [
                    //     Color(0XFFFF4AA3),
                    //     Color(0XFFF8B556),
                    //   ],
                    //   begin: Alignment.centerRight,
                    //   end: Alignment.centerLeft,
                    // ),
                    color: pinkColor,
                    borderRadius: BorderRadius.circular(15.sp),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 50,
                    ),
                    width: 50.w,
                    child: Text(
                      'رجوع',
                      style: Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String> getId() async {
  try {
    return await PlatformDeviceId.getDeviceId;
  } catch (e) {
    return 'UNKNOWN ID -> time: ${Cache.getUserLoginTime()}';
  }
}

Future share() async {
  String id = await getId();
  return Container();
}

String mailUs({
  @required String subject,
  String body = '',
}) {
  const String email = 'malazhariy.ramadankareem@gmail.com';
  return 'mailto:$email?subject=$subject&body=$body';
}
