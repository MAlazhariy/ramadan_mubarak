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

class UserEditScreen extends StatefulWidget {
  const UserEditScreen({
    Key key,
    @required this.user,
  }) : super(key: key);

  final UserDataModel user;

  @override
  State<UserEditScreen> createState() => _PendingDataScreenState();
}

class _PendingDataScreenState extends State<UserEditScreen> {
  var nameCtrl = TextEditingController();
  var doaaCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    nameCtrl.text = widget.user.name;
    doaaCtrl.text = widget.user.doaa;

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
        title: Text('تعديل المستخدم ${widget.user.name}'),
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
                        // setState(() {});
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
                        // setState(() {});
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
              if (nameCtrl.text != widget.user.name ||
                  doaaCtrl.text != widget.user.doaa ||
                  true)
                Align(
                  alignment: AlignmentDirectional.center,
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        dismissKeyboard(context);

                        await changeData(
                          updatedName: nameCtrl.text,
                          updatedDoaa: doaaCtrl.text,
                        );
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
                          'موافقة وحفظ',
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
    @required String updatedName,
    @required String updatedDoaa,
  }) async {
    hasNetwork().then((connected) {
      if (connected) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.id)
            .update({
          'name': updatedName,
          'doaa': updatedDoaa,
          'approved': true,
          'nameUpdate': '',
          'doaaUpdate': '',
          'pendingEdit': false,
        }).then((_) {
          if (userModel.data.contains(widget.user)) {
            int index = userModel.data.indexOf(widget.user);

            userModel.data[index].name = updatedName;
            userModel.data[index].doaa = updatedDoaa;
            userModel.data[index].approved = true;

            userModel.data[index].nameUpdate = '';
            userModel.data[index].doaaUpdate = '';
            userModel.data[index].pendingEdit = false;
            // Save updates in local
            Cache.saveData(userModel.toList());
          }

          snkbar(
            context,
            '${widget.user.name} edited & approved',
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
