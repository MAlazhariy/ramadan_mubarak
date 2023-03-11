import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ramadan_kareem/ztrash/users_model.dart';
import 'package:ramadan_kareem/shared/cache_helper/cache_helper.dart';
import 'package:ramadan_kareem/helpers/dismiss_keyboard.dart';
import 'package:ramadan_kareem/helpers/network_check.dart';
import 'package:ramadan_kareem/view/widgets/snack_bar.dart';
import 'package:ramadan_kareem/view/widgets/custom_text_form.dart';
import 'package:ramadan_kareem/shared/components/constants.dart';
import 'package:ramadan_kareem/shared/styles.dart';
import 'package:sizer/sizer.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserDataModel user;

  @override
  State<UserInfoScreen> createState() => _PendingDataScreenState();
}

class _PendingDataScreenState extends State<UserInfoScreen> {
  var nameCtrl = TextEditingController();
  var doaaCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();

  // String timeFormatted;

  @override
  void initState() {
    super.initState();

    nameCtrl.text = widget.user.name;
    doaaCtrl.text = widget.user.doaa;
    // timeFormatted = DateTime.fromMicrosecondsSinceEpoch(widget.user.time, isUtc: true).toLocal().toString().split('.').first ?? '';
    // if(timeFormatted.isNotEmpty) {
    //   // timeFormatted = timeFormatted.substring(0, timeFormatted.length-3);
    // }

    hasNetwork().then((connected) {
      if (!connected) {
        SnkBar(
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
        title: Text(widget.user.id),
      ),

      // makes keyboard shown over the bottom sheet
      resizeToAvoidBottomInset: false,

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 14,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),

                    Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// name
                          CustomTextForm(
                            controller: nameCtrl,
                            labelText: 'الاسم',
                            validator: (value) {
                              if (value?.isEmpty??true) {
                                return 'هذا الحقل يجب ألا يكون فارغاً';
                              }
                            },
                            onChanged: (value) {
                              setState(() {});
                            },
                            keyboardType: TextInputType.name,
                            inputAction: TextInputAction.next,
                            hintText: 'تعديل الاسم',
                            prefixIcon: Icon(
                              Icons.account_circle_outlined,
                              size: 19.sp,
                            ),
                          ),

                          SizedBox(height: 15.sp),

                          /// doaa
                          CustomTextForm(
                            controller: doaaCtrl,
                            labelText: 'الدعاء',
                            validator: (value) {
                              if (value?.isEmpty??true) {
                                return 'هذا الحقل يجب ألا يكون فارغاً';
                              }
                            },
                            onChanged: (value) {
                              setState(() {});
                            },
                            keyboardType: TextInputType.text,
                            inputAction: TextInputAction.none,
                            maxLines: 6,
                            hintText: 'تعديل الدعاء',
                            prefixIcon: Icon(
                              Icons.article_outlined,
                              size: 19.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    // device id
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'device_id',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: black1,
                              height: 1.2,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            widget.user.deviceId ?? '',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: black1,
                              height: 1.2,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    // time
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'time',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: black1,
                              height: 1.2,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            widget.user.time.toString(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: black1,
                              height: 1.2,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 1),
                        Builder(
                          builder: (context){
                            DateTime time = DateTime.fromMicrosecondsSinceEpoch(widget.user.time, isUtc: true).toLocal();
                            String fTime = '${time.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')} - ${time.year.toString().substring(0,4)}/${time.month.toString().padLeft(2,'0')}/${time.day.toString().padLeft(2,'0')}  ';

                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                fTime,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.grey,
                                  // height: 1.2,
                                  fontSize: 10.sp,
                                  // fontWeight: FontWeight.w300,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    // approved
                    if (!widget.user.approved)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'approved',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: black1,
                                height: 1.2,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 7),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              widget.user.approved.toString(),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.red,
                                height: 1.2,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    // updates
                    if (widget.user.pendingEdit)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // pending update
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  'pending update',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: black1,
                                    height: 1.2,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 7),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  widget.user.pendingEdit.toString(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.green,
                                    height: 1.2,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                          // name update
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  'name update',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: black1,
                                    height: 1.2,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 7),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  widget.user.nameUpdate.toString(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.green,
                                    height: 1.2,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                          // doaa update
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  'doaa update',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: black1,
                                    height: 1.2,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 7),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  widget.user.doaaUpdate.toString(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.green,
                                    height: 1.2,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ],
                      ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            Align(
              alignment: AlignmentDirectional.center,
              // ignore: deprecated_member_use
              child: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
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
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 50,
                    ),
                    width: 80.w,
                    child: Text(
                      'رجوع',
                      style: Theme.of(context).textTheme.headline2?.copyWith(
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

            // Save button
            if (nameCtrl.text != widget.user.name ||
                doaaCtrl.text != widget.user.doaa)
              TextButton(
                child: const Text('حفظ التغييرات'),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    dismissKeyboard(context);

                    await changeData(
                      newName: nameCtrl.text,
                      newDoaa: doaaCtrl.text,
                    );

                    Navigator.pop(context);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> changeData({
    required String newName,
    required String newDoaa,
  }) async {
    hasNetwork().then((connected) {
      if (connected) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.id)
            .update({
          'name': newName,
          'doaa': newDoaa,
          'approved': true,
        }).then((_) {
          setState(() {
            var index = userModel!.data.indexOf(widget.user);
            userModel?.data[index].name = newName;
            userModel?.data[index].doaa = newDoaa;
            userModel?.data[index].approved = true;
            // Save updates in local
            Cache.saveData(userModel!.toList());
          });

          SnkBar(
            context,
            '${widget.user.name} changed',
            seconds: 1,
            backgroundColor: Colors.green,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          );

          Navigator.pop(context);
        }).onError((error, stackTrace) {
          log('error when changeData in user edit screen ' + error.toString());
          SnkBar(
            context,
            error.toString(),
            backgroundColor: Colors.red,
          );
        });
      } else {
        SnkBar(
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
