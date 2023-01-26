import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ramadan_kareem/models/users_model.dart';
import 'package:ramadan_kareem/shared/cache_helper/cache_helper.dart';
import 'package:ramadan_kareem/shared/components/components/dismiss_keyboard.dart';
import 'package:ramadan_kareem/shared/components/components/network_check.dart';
import 'package:ramadan_kareem/shared/components/components/snack_bar.dart';
import 'package:ramadan_kareem/shared/components/components/white_text_form.dart';
import 'package:ramadan_kareem/shared/components/constants.dart';
import 'package:ramadan_kareem/shared/styles.dart';
import 'package:sizer/sizer.dart';

class UserEditUpdatesScreen extends StatefulWidget {
  const UserEditUpdatesScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserDataModel user;

  @override
  State<UserEditUpdatesScreen> createState() => _PendingDataScreenState();
}

class _PendingDataScreenState extends State<UserEditUpdatesScreen> {
  var nameCtrl = TextEditingController();
  var doaaCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    nameCtrl.text = widget.user.nameUpdate;
    doaaCtrl.text = widget.user.doaaUpdate;

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
        title: Text('تعديلات المستخدم ${widget.user.name}'),
      ),

      // makes keyboard shown over the bottom sheet
      resizeToAvoidBottomInset: false,

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 40,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// name
                    WhiteTextForm(
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
                    WhiteTextForm(
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
                      maxLines: 5,
                      hintText: 'تعديل الدعاء',
                      prefixIcon: Icon(
                        Icons.article_outlined,
                        size: 19.sp,
                      ),
                    ),
                  ],
                ),
              ),

              // name before
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'الاسم قبل التعديل:',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: black1,
                    height: 1.2,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 7),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  widget.user.name,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: black1,
                    height: 1.2,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // doaa before
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'الدعاء قبل التعديل:',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: black1,
                    height: 1.2,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 7),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  widget.user.doaa,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: black1,
                    height: 1.2,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Save button
              if (nameCtrl.text != widget.user.name ||
                  doaaCtrl.text != widget.user.doaa)
                Align(
                  alignment: AlignmentDirectional.center,
                  // ignore: deprecated_member_use
                  child: MaterialButton(
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
                    padding: const EdgeInsets.all(0),
                    shape: const StadiumBorder(),
                    highlightElevation: 5,
                    highlightColor: pinkColor.withAlpha(50),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15.sp),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 50,
                        ),
                        width: 80.w,
                        child: Text(
                          'تعديل وحفظ',
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

              TextButton(
                child: const Text('رجوع، وعدم الحفظ'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
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
            .doc(widget.user.deviceId)
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

          snkbar(
            context,
            '${widget.user.name} approved',
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
          snkbar(
            context,
            error.toString(),
            backgroundColor: Colors.red,
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
