import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ramadan_kareem/helpers/dismiss_keyboard.dart';
import 'package:ramadan_kareem/helpers/network_check.dart';
import 'package:ramadan_kareem/providers/field_doaa_provider.dart';
import 'package:ramadan_kareem/providers/profile_provider.dart';
import 'package:ramadan_kareem/utils/resources/color_manger.dart';
import 'package:ramadan_kareem/utils/resources/dimensions_manager.dart';
import 'package:ramadan_kareem/utils/resources/text_styles_manager.dart';
import 'package:ramadan_kareem/view/base/internet_consumer_builder.dart';
import 'package:ramadan_kareem/view/base/main_button.dart';
import 'package:ramadan_kareem/view/base/snack_bar.dart';
import 'package:ramadan_kareem/view/base/custom_text_form.dart';
import 'package:ramadan_kareem/ztrash/shared/components/constants.dart';
import 'package:ramadan_kareem/ztrash/shared/styles.dart';
import 'package:sizer/sizer.dart';

class UpdateUserDataScreen extends StatefulWidget {
  const UpdateUserDataScreen({Key? key}) : super(key: key);

  @override
  State<UpdateUserDataScreen> createState() => _UpdateUserDataScreenState();
}

class _UpdateUserDataScreenState extends State<UpdateUserDataScreen> {
  var nameCtrl = TextEditingController();
  var doaaCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<ProfileProvider>(context, listen: false).getUserIfNotExists();
      if (!mounted) return;
      final user = Provider.of<ProfileProvider>(context, listen: false).userDetails;
      setState(() {
        nameCtrl.text = user?.name ?? '';
        doaaCtrl.text = user?.doaa ?? '';
        Provider.of<FieldDoaaProvider>(context, listen: false).initDoaaLength(doaaCtrl.text);
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    Provider.of<FieldDoaaProvider>(context, listen: false).clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool activated = (nameCtrl.text != Provider.of<ProfileProvider>(context, listen: false).userDetails?.name) ||
        (doaaCtrl.text != Provider.of<ProfileProvider>(context, listen: false).userDetails?.doaa);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل البيانات'),
      ),

      // makes keyboard shown over the bottom sheet
      resizeToAvoidBottomInset: true,

      body: InternetConsumerBuilder(
        builder: (context, internetProvider) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p25,
              vertical: AppPadding.p16,
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Consumer<FieldDoaaProvider>(
                        builder: (context, doaaProvider, _) {
                          const arabicDiacritics = 'ًٌٍَُِّْ';

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // name
                              CustomTextForm(
                                controller: nameCtrl,
                                validator: (value) {
                                  return value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null;
                                },
                                keyboardType: TextInputType.name,
                                inputAction: TextInputAction.next,
                                hintText: 'تعديل الاسم',
                                labelText: 'الاسم',
                                prefixIcon: Icon(
                                  Icons.account_circle_outlined,
                                  color: doaaProvider.isInNameField ? kPrimarySemiLightColor : kLightGreyColor,
                                  size: 19.sp,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp('[\u0600-\u06FF\\s]+')),
                                ],
                                onChanged: (value) {
                                  setState(() {});
                                },
                                onTap: () {
                                  doaaProvider.onTapField(isName: true);
                                },
                              ),
                              SizedBox(height: 15.sp),
                              // doaa
                              CustomTextForm(
                                controller: doaaCtrl,
                                validator: (value) {
                                  return value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null;
                                },
                                keyboardType: TextInputType.multiline,
                                maxLines: 6,
                                labelText: 'الدعاء',
                                hintText: 'اكتب الدعاء باللغة العريبة بصيغة الغائب، مثال: "اللهم اغفر له"',
                                prefixIcon: Icon(
                                  Icons.article_outlined,
                                  color: doaaProvider.isInDoaaField ? kPrimarySemiLightColor : kLightGreyColor,
                                  size: 19.sp,
                                ),
                                maxLength: doaaProvider.maxDoaaLength,
                                counterText: '',
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp('[\u0600-\u06FF$arabicDiacritics\\s]*'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {});
                                  doaaProvider.onChangeDoaaLength(value.length);
                                },
                                onTap: () {
                                  doaaProvider.onTapField(isName: false);
                                },
                              ),
                              if (doaaProvider.isInDoaaField)
                                Container(
                                  alignment: AlignmentDirectional.centerEnd,
                                  padding: const EdgeInsetsDirectional.only(
                                    end: AppPadding.p30 - 3,
                                    top: AppPadding.p5,
                                  ),
                                  child: Text(
                                    '${doaaProvider.doaaLength}/${doaaProvider.maxDoaaLength}',
                                    // style: const TextStyle(
                                    //   color: kPrimarySemiLightColor,
                                    //   fontWeight: FontWeight.w600,
                                    // ),
                                    style: kBoldFontStyle.copyWith(
                                      color: kPrimarySemiLightColor,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      // child: Column(
                      //   mainAxisSize: MainAxisSize.min,
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     // /// name
                      //     // CustomTextForm(
                      //     //   controller: nameCtrl,
                      //     //   labelText: 'الاسم',
                      //     //   validator: (value) {
                      //     //     if (value?.isEmpty ?? true) {
                      //     //       return 'هذا الحقل يجب ألا يكون فارغاً';
                      //     //     }
                      //     //     return null;
                      //     //   },
                      //     //   onChanged: (value) {
                      //     //     setState(() {});
                      //     //   },
                      //     //   keyboardType: TextInputType.name,
                      //     //   inputAction: TextInputAction.next,
                      //     //   hintText: 'تعديل الاسم',
                      //     //   prefixIcon: Icon(
                      //     //     Icons.account_circle_outlined,
                      //     //     size: 19.sp,
                      //     //   ),
                      //     // ),
                      //     //
                      //     // SizedBox(
                      //     //   height: 15.sp
                      //     // ),
                      //     //
                      //     // /// doaa
                      //     // CustomTextForm(
                      //     //   controller: doaaCtrl,
                      //     //   labelText: 'الدعاء',
                      //     //   validator: (value) {
                      //     //     if (value?.isEmpty ?? true) {
                      //     //       return 'هذا الحقل يجب ألا يكون فارغاً';
                      //     //     }
                      //     //   },
                      //     //   onChanged: (value) {
                      //     //     setState(() {});
                      //     //   },
                      //     //   keyboardType: TextInputType.text,
                      //     //   inputAction: TextInputAction.none,
                      //     //   maxLines: 5,
                      //     //   hintText: 'تعديل الدعاء',
                      //     //   prefixIcon: Icon(
                      //     //     Icons.article_outlined,
                      //     //     size: 19.sp,
                      //     //   ),
                      //     // ),
                      //
                      //     Consumer<FieldDoaaProvider>(
                      //       builder: (context, doaaProvider, _) {
                      //         const arabicDiacritics = 'ًٌٍَُِّْ';
                      //
                      //         return Column(
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: [
                      //             // name
                      //             CustomTextForm(
                      //               controller: nameCtrl,
                      //               validator: (value) {
                      //                 return value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null;
                      //               },
                      //               keyboardType: TextInputType.name,
                      //               inputAction: TextInputAction.next,
                      //               hintText: 'تعديل الاسم',
                      //               labelText: 'الاسم',
                      //               prefixIcon: Icon(
                      //                 Icons.account_circle_outlined,
                      //                 color: doaaProvider.isInNameField ? kPrimarySemiLightColor : kLightGreyColor,
                      //                 size: 19.sp,
                      //               ),
                      //               inputFormatters: [
                      //                 FilteringTextInputFormatter.allow(RegExp('[\u0600-\u06FF\\s]+')),
                      //               ],
                      //               onChanged: (value) {
                      //                 setState(() {});
                      //               },
                      //               onTap: () {
                      //                 doaaProvider.onTapField(isName: true);
                      //               },
                      //             ),
                      //             SizedBox(height: 15.sp),
                      //             // doaa
                      //             CustomTextForm(
                      //               controller: doaaCtrl,
                      //               validator: (value) {
                      //                 return value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null;
                      //               },
                      //               keyboardType: TextInputType.multiline,
                      //               maxLines: 6,
                      //               labelText: 'الدعاء',
                      //               hintText: 'اكتب الدعاء باللغة العريبة بصيغة الغائب، مثال: "اللهم اغفر له"',
                      //               prefixIcon: Icon(
                      //                 Icons.article_outlined,
                      //                 color: doaaProvider.isInDoaaField ? kPrimarySemiLightColor : kLightGreyColor,
                      //                 size: 19.sp,
                      //               ),
                      //               maxLength: doaaProvider.maxDoaaLength,
                      //               counterText: '',
                      //               inputFormatters: [
                      //                 FilteringTextInputFormatter.allow(
                      //                   RegExp('[\u0600-\u06FF$arabicDiacritics\\s]*'),
                      //                 ),
                      //               ],
                      //               onChanged: (value) {
                      //                 setState(() {});
                      //                 doaaProvider.onChangeDoaaLength(value.length);
                      //               },
                      //               onTap: () {
                      //                 doaaProvider.onTapField(isName: false);
                      //               },
                      //             ),
                      //             if (doaaProvider.isInDoaaField)
                      //               Container(
                      //                 alignment: AlignmentDirectional.centerEnd,
                      //                 padding: const EdgeInsetsDirectional.only(
                      //                   end: AppPadding.p30 - 3,
                      //                   top: AppPadding.p5,
                      //                 ),
                      //                 child: Text(
                      //                   '${doaaProvider.doaaLength}/${doaaProvider.maxDoaaLength}',
                      //                   // style: const TextStyle(
                      //                   //   color: kPrimarySemiLightColor,
                      //                   //   fontWeight: FontWeight.w600,
                      //                   // ),
                      //                   style: kBoldFontStyle.copyWith(
                      //                     color: kPrimarySemiLightColor,
                      //                   ),
                      //                 ),
                      //               ),
                      //           ],
                      //         );
                      //       },
                      //     ),
                      //   ],
                      // ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSize.s12),

                // Save button
                Consumer<ProfileProvider>(
                  builder: (context, profileProvider, _) {
                    if (profileProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator.adaptive());
                    }

                    return MainButton(
                      onPressed: activated
                          ? () async {
                              if (formKey.currentState!.validate()) {
                                dismissKeyboard(context);

                                final response = await profileProvider.updateUser(
                                  name: nameCtrl.text,
                                  doaa: doaaCtrl.text,
                                );
                                if (response.isSuccess && mounted) {
                                  SnkBar.showSuccess(context, 'تم حفظ التعديلات بنجاح، وبانتظار مراجعة المبرمج.');

                                  Navigator.pop(context);
                                } else {
                                  log('error when changeData ${response.message ?? ''}');
                                  SnkBar.showError(context, response.message ?? '');
                                }
                              }
                            }
                          : null,
                      title: 'تعديل',
                    );
                  },
                ),
                // MainButton(
                //   onPressed: () async {
                //     if (formKey.currentState!.validate()) {
                //       dismissKeyboard(context);
                //
                //       await changeData(
                //         newName: nameCtrl.text,
                //         newDoaa: doaaCtrl.text,
                //       );
                //     }
                //   },
                //   outlined: true,
                //   fit: false,
                //   title: 'رجوع',
                // ),

                TextButton(
                  child: const Text('رجوع، وعدم الحفظ'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> changeData({
    required String newName,
    required String newDoaa,
  }) async {
    hasNetwork().then((connected) {
      if (connected) {
        FirebaseFirestore.instance.collection('users').doc(deviceId).update({
          'nameUpdate': newName,
          'doaaUpdate': newDoaa,
          'pendingEdit': true,
        }).then((_) {
          // try {
          //   var user =
          //       userModel?.data.where((user) => user.deviceId == deviceId).first;
          //
          //   // Save updates to variable
          //   var index = userModel?.data.indexOf(user);
          //   userModel?.data[index].name = newName;
          //   userModel?.data[index].doaa = newDoaa;
          //   userModel?.data.elementAt(index).approved = true;
          //
          //   // Save updates in local
          //   Cache.saveData(userModel.toList());
          // } catch (e) {
          //   log('try catch error in when edit data: ' + e.toString());
          // }

          SnkBar.showSuccess(context, 'تم حفظ التعديلات بنجاح، وبانتظار مراجعة المبرمج.');

          if (mounted) {
            Navigator.pop(context);
          }
        }).onError((error, stackTrace) {
          log('error when changeData ' + error.toString());
          SnkBar.show(
            context,
            message: error.toString(),
            backgroundColor: Colors.red,
          );
        });
      } else {
        SnkBar.show(
          context,
          message: 'أنت غير متصل بالإنترنت، يرجى الاتصال بالإنترنت ثم إعادة المحاولة مرة أخرى',
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
}
