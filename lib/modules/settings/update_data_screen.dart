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

class UpdateUserDataScreen extends StatefulWidget {
  const UpdateUserDataScreen({Key key}) : super(key: key);

  @override
  State<UpdateUserDataScreen> createState() => _UpdateUserDataScreenState();
}

class _UpdateUserDataScreenState extends State<UpdateUserDataScreen> {
  var nameCtrl = TextEditingController();
  var doaaCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();

  var users = userModel.data.where((user) => user.deviceId == deviceId);

  @override
  void initState() {
    super.initState();

    hasNetwork().then((connected) {
      if (!connected) {
        snkbar(
          context,
          'أنت غير متصل بالإنترنت، يرجى الاتصال بالإنترنت ثم إعادة المحاولة مرة أخرى',
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

    setState(() {
      if (users.isNotEmpty) {
        nameCtrl.text = users.first.name;
        doaaCtrl.text = users.first.doaa;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل البيانات'),
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
                      validator: (String value) {
                        if (value.isEmpty) {
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

                    SizedBox(
                      height: 15.sp,
                    ),

                    /// doaa
                    WhiteTextForm(
                      controller: doaaCtrl,
                      labelText: 'الدعاء',
                      validator: (String value) {
                        if (value.isEmpty) {
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

              const SizedBox(height: 40),

              // Save button
              if (users.isEmpty ||
                  nameCtrl.text != users.first.name ||
                  doaaCtrl.text != users.first.doaa)
                Align(
                  alignment: AlignmentDirectional.center,
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        dismissKeyboard(context);

                        await changeData(
                          newName: nameCtrl.text,
                          newDoaa: doaaCtrl.text,
                        );

                      }
                    },
                    padding: const EdgeInsets.all(0),
                    shape: const StadiumBorder(),
                    highlightElevation: 5,
                    highlightColor: pinkColor.withAlpha(50),
                    child: Ink(
                      decoration: BoxDecoration(
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
                          'حفظ',
                          style: Theme.of(context).textTheme.headline2.copyWith(
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
    @required String newName,
    @required String newDoaa,
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
          //       userModel.data.where((user) => user.deviceId == deviceId).first;
          //
          //   // Save updates to variable
          //   var index = userModel.data.indexOf(user);
          //   userModel.data[index].name = newName;
          //   userModel.data[index].doaa = newDoaa;
          //   userModel.data.elementAt(index).approved = true;
          //
          //   // Save updates in local
          //   Cache.saveData(userModel.toList());
          // } catch (e) {
          //   log('try catch error in when edit data: ' + e.toString());
          // }

          snkbar(
            context,
            'تم حفظ التعديلات بنجاح، وبانتظار مراجعة المبرمج.',
            seconds: 3,
            backgroundColor: Colors.green,
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          );

          if(mounted){
            Navigator.pop(context);
          }

        }).onError((error, stackTrace) {
          log('error when changeData ' + error.toString());
          snkbar(
            context,
            error.toString(),
            backgroundColor: Colors.red,
          );
        });
      } else {
        snkbar(
          context,
          'أنت غير متصل بالإنترنت، يرجى الاتصال بالإنترنت ثم إعادة المحاولة مرة أخرى',
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
