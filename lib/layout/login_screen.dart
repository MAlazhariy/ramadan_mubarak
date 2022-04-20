// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:ramadan_kareem/layout/home_screen.dart';
import 'package:ramadan_kareem/models/users_model.dart';
import 'package:ramadan_kareem/modules/notifications_permission_screen.dart';
import 'package:ramadan_kareem/shared/cache_helper/cache_helper.dart';
import 'package:ramadan_kareem/shared/components/components/custom_dialog/custom_dialog.dart';
import 'package:ramadan_kareem/shared/components/components/custom_dialog/dialog_buttons.dart';
import 'package:ramadan_kareem/shared/components/components/dismiss_keyboard.dart';
import 'package:ramadan_kareem/shared/components/components/network_check.dart';
import 'package:ramadan_kareem/shared/components/components/push_and_finish.dart';
import 'package:ramadan_kareem/shared/components/components/snack_bar.dart';
import 'package:ramadan_kareem/shared/components/components/white_text_form.dart';
import 'package:ramadan_kareem/shared/components/constants.dart';
import 'package:ramadan_kareem/shared/network/firebase_funcs.dart';
import 'package:sizer/sizer.dart';

enum Field {
  // ignore: constant_identifier_names
  NAME,
  DOAA,
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var nameCtrl = TextEditingController();
  var doaaCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();
  Field _field;
  bool passwordIsShown = false;
  bool loading = false;

  // var doc = await FirebaseFirestore.instance.collection('users').doc(deviceId).get();

  Future<void> login({
    @required String name,
    @required String doaa,
  }) async {
    setState(() {
      loading = true;
    });

    await hasNetwork().then((hasNetwork) async {
      if (hasNetwork) {
        var doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(deviceId)
            .get();

        int time = DateTime.now().toUtc().microsecondsSinceEpoch;
        log(doc.id);

        // todo: remove comment
        // doc.set({
        //   'name': name,
        //   'doaa': doaa,
        //   'device id': id,
        //   'approved': false,
        //   'time': time,
        //   'nameUpdate': '',
        //   'doaaUpdate': '',
        //   'pendingEdit': false,
        // }).then((value) {
        //   setState(() {
        //     loading = false;
        //   });
        //
        //   Cache.hasLoggedIn();
        //   Cache.setUserLoginInfo(
        //     name: name,
        //     doaa: doaa,
        //     time: time,
        //     docId: doc.id,
        //   );
        //
        //   pushAndFinish(context, const HomeScreen());
        // }).catchError((error) {
        //   setState(() {
        //     loading = false;
        //   });
        //   log(error.toString());
        //   snkbar(context, error.toString());
        // });

      } else {
        snkbar(context, 'برجاء التحقق من شبكة الإنترنت');
        loading = false;
      }
    });
  }

  void changeData({
    @required String newName,
    @required String newDoaa,
  }) async {
    FirebaseFirestore.instance.collection('users').doc(deviceId).update({
      'nameUpdate': newName,
      'doaaUpdate': newDoaa,
      'pendingEdit': true,
    }).then((value) {
      // todo: change edited in our userModel
      // for (var element in localData) {
      //   if (element['device id'] == deviceId) {
      //     element.update('name', (value) => newName);
      //     element.update('doaa', (value) => newDoaa);
      //
      //     log('new name : ${element['name']}');
      //     log('new doaa : ${element['doaa']}');
      //     break;
      //   }
      // }

      log('change done');
    });
  }

  void approve(UserDataModel user) async {
    FirebaseFirestore.instance.collection('users').doc(user.id).update({
      'name': user.nameUpdate,
      'doaa': user.doaaUpdate,
      'nameUpdate': '',
      'doaaUpdate': '',
      'pendingEdit': false,
    }).then((value) {
      // todo: change edited in our userModel
      // for (var element in localData) {
      //   if (element['device id'] == deviceId) {
      //     element.update('name', (value) => newName);
      //     element.update('doaa', (value) => newDoaa);
      //
      //     log('new name : ${element['name']}');
      //     log('new doaa : ${element['doaa']}');
      //     break;
      //   }
      // }

      log('${user.nameUpdate} approved successfully');
    });
  }

  void edit() async {
    // var collection = await getCollection();
    //
    // for (var doc in collection.docs) {
    //   FirebaseFirestore.instance.collection('users').doc(doc.id).update({
    //     'doaaUpdate': '',
    //     'nameUpdate': '',
    //     'pendingEdit': false,
    //   });
    // }
    List local = Cache.getData();
    log(userModel.data[0].name);

    // log(Cache.getData().toString());

    // userModel.data.where((user) => user.pendingEdit).forEach((user) {
    //   log('There\'s a user have an updates to review and these are the details..');
    //   log('old name = ${user.name}');
    //   log('new name = ${user.nameUpdate}');
    //
    //   log('old doaa = ${user.doaa}');
    //   log('new doaa = ${user.doaaUpdate}');
    //   log('is binding = ${user.pendingEdit}');
    //
    //   log('approving changes');
    //   approve(user);
    // });

    /// 6:10
    // FirebaseFirestore.instance.collection('users').get().then((value) {
    //   var data = value;
    //   log(data.docs.length.toString());
    //   for (var data in data.docs) {
    //     log(data.data()['name']);
    //   }
    // });

    ///6:00
    // FirebaseFirestore.instance
    //     .collection('users').get().then((value) {
    //   log(value.docs.length.toString());
    // });

    /// 5:46
    // FirebaseFirestore.instance
    //     .collection('users').get().then((value) {
    //       log(value.docs.length.toString());
    // });

    // 5:41
    // FirebaseFirestore.instance
    //         .collection('users').get().then((value) {
    //           log(value.docs.length.toString());
    //     });

    //     .orderBy('time')
    //     .firestore.
    //     .get()
    //     .then((value) {
    //       log(value.docs.length.toString());
    //   for (var element in value.docs) {
    //     log(element.data()['name'].toString());
    //   }
    // });
    // log(size.toString());

    // log(data.length.toString());
    // log(data.toString());

    //   for(var item in data){
    //     final String id = item['device id'];
    //
    //     FirebaseFirestore.instance.collection('users').doc(id).update({
    //       'doaaUpdate': '',
    //       'nameUpdate': '',
    //       'updateApproved': false,
    //       'pendingEdit': true,
    //     });
    // }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              height: 25.h,
              child: SvgPicture.asset(
                'assets/images/appbar.svg',
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
            ),
            Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.all(20.sp),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحبًا',
                      style: Theme.of(context).textTheme.headline1.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 85,
                            color: const Color(0xE639444C),
                            // letterSpacing: 1.2,
                          ),
                    ),
                    SizedBox(
                      height: 12.sp,
                    ),
                    Text(
                      'يرجى تسجيل الدخول للمتابعة',
                      style: Theme.of(context).textTheme.headline2.copyWith(
                            color: Colors.black38,
                            fontSize: 19.5,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    SizedBox(
                      height: 30.sp,
                    ),

                    /// name
                    WhiteTextForm(
                      controller: nameCtrl,
                      validator: (String value) {
                        return value.isEmpty ? 'هذا الحقل مطلوب' : null;
                      },
                      keyboardType: TextInputType.name,
                      inputAction: TextInputAction.next,
                      hintText: 'الاسم ثنائي',
                      prefixIcon: Icon(
                        Icons.account_circle_outlined,
                        color: _field == Field.NAME
                            ? const Color(0x7CFF0028)
                            : const Color(0x7C323F48),
                        size: 19.sp,
                      ),
                      // onChanged: (value) {
                      // },
                      onTap: () {
                        setState(() {
                          _field = Field.NAME;
                        });
                      },
                    ),
                    SizedBox(
                      height: 15.sp,
                    ),
                    // doaa
                    WhiteTextForm(
                      controller: doaaCtrl,
                      validator: (String value) {
                        return value.isEmpty ? 'هذا الحقل مطلوب' : null;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 6,
                      hintText:
                          'اكتب دعاءك المفضل بصيغة الغائب، مثال: "اللهم اغفر له"',
                      prefixIcon: Icon(
                        Icons.article_outlined,
                        color: _field == Field.DOAA
                            ? const Color(0x7CFF0028)
                            : const Color(0x7C323F48),
                        size: 19.sp,
                      ),
                      // onChanged: (value) {
                      //
                      // },
                      onTap: () {
                        setState(() {
                          _field = Field.DOAA;
                        });
                      },
                    ),

                    SizedBox(
                      height: 20.sp,
                    ),
                    // button
                    Align(
                      alignment: AlignmentDirectional.center,
                      child: RaisedButton(
                        // todo: login button
                        onPressed: () async {
                          setState(() {});
                          dismissKeyboard(context);

                          if (formKey.currentState.validate()) {
                            log('login pressed');

                            // changeData(
                            //   newName: nameCtrl.text,
                            //   newDoaa: doaaCtrl.text,
                            // );

                            edit();

                            // await login(
                            //   name: nameCtrl.text,
                            //   doaa: doaaCtrl.text,
                            // );

                            // todo: remove comment
                            // if (!Cache.isNotificationsDone() || true) {
                            //   pushAndFinish(
                            //     context,
                            //     const NotificationsPermissionScreen(),
                            //   );
                            // }

                            // showCustomDialog(
                            //   context: context,
                            //   title:
                            //       'سيتم إرسال طلبك للمسؤولين وحالما يتم الموافقة عليه سيظهر للمستخدمين الآخرين',
                            //   content: Column(
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: [
                            //       const Text(
                            //         'سيظهر دعاءك بهذا الشكل للمستخدمين الآخرين'
                            //       ),
                            //       Container(
                            //         decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(7.sp),
                            //           color: Colors.pink.withAlpha(13),
                            //         ),
                            //         width: double.maxFinite,
                            //         padding: EdgeInsets.symmetric(
                            //           horizontal: 15.sp,
                            //           vertical: 20.sp,
                            //         ),
                            //         child: Column(
                            //           mainAxisSize: MainAxisSize.min,
                            //           crossAxisAlignment: CrossAxisAlignment.start,
                            //           children: [
                            //             Text(
                            //               nameCtrl.text,
                            //               style: TextStyle(
                            //                 fontSize: 20.sp,
                            //                 fontWeight: FontWeight.w800,
                            //               ),
                            //             ),
                            //             SizedBox(height: 5.sp),
                            //             Text(
                            //               doaaCtrl.text,
                            //               style: TextStyle(
                            //                 fontSize: 15.sp,
                            //                 fontWeight: FontWeight.w500,
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            //   buttons: [
                            //     if (!loading)
                            //       DialogButton(
                            //         title: 'تأكيد',
                            //         onPressed: () async {
                            //           await hasNetwork().then((value) async {
                            //             if (value) {
                            //               String id;
                            //               try {
                            //                 id = await PlatformDeviceId
                            //                     .getDeviceId;
                            //               } catch (e) {}
                            //               ;
                            //
                            //               login(
                            //                 name: nameCtrl.text,
                            //                 doaa: doaaCtrl.text,
                            //                 id: id,
                            //               );
                            //             } else {
                            //               snkbar(context,
                            //                   'برجاء التحقق من شبكة الإنترنت');
                            //               loading = false;
                            //               Navigator.pop(context);
                            //             }
                            //           });
                            //         },
                            //         isBold: true,
                            //       ),
                            //     if (loading) const CircularProgressIndicator(),
                            //     if (!loading)
                            //       DialogButton(
                            //         title: 'رجوع',
                            //         onPressed: () {
                            //           Navigator.pop(context);
                            //         },
                            //         isBold: false,
                            //       ),
                            //   ],
                            // );
                          }
                        },
                        padding: const EdgeInsets.all(0),
                        shape: const StadiumBorder(),
                        highlightElevation: 5,
                        highlightColor: const Color(0x7CFF0028).withAlpha(50),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0XFFFF4AA3),
                                Color(0XFFF8B556),
                              ],
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 50,
                            ),
                            child: Text(
                              'تسجيل الدخول',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(
                                    color: Colors.white,
                                    fontSize: 19.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    /* password*/
                    // Stack(
                    //   alignment: AlignmentDirectional.topEnd,
                    //   children: [
                    //     WhiteTextForm(
                    //       controller: passwordController,
                    //       prefixIcon: Icon(
                    //         passwordIsShown
                    //             ? Icons.lock_open_outlined
                    //             : Icons.lock_outline,
                    //         color: _field==Field.PASSWORD ? const Color(0x7CFF0028) : const Color(0x7C323F48),
                    //         size: 22.5,
                    //       ),
                    //       hintText: 'كلمة السر',
                    //       inputAction: TextInputAction.done,
                    //       keyboardType: TextInputType.number,
                    //       obscureText: !passwordIsShown,
                    //       suffix: Text(
                    //         passwordSuffix,
                    //         style: const TextStyle(
                    //           color: Colors.transparent,
                    //         ),
                    //       ),
                    //       validator: (String value)
                    //       {
                    //         return (value.isEmpty)
                    //             ? 'هذا الحقل مطلوب'
                    //             : (value.length <= 3) ? 'ايه يعم الباسورد ده؟! متكتب باسورد عدل!' : null ;
                    //       },
                    //       onChanged: (value)
                    //       {
                    //         setState(() {});
                    //         if (passwordController.text.isEmpty) {
                    //           _field = null;
                    //         } else {
                    //           _field = Field.PASSWORD;
                    //         }
                    //       },
                    //       // onFieldSubmitted: (value)
                    //       // {
                    //       //   setState(() {
                    //       //     passwordIsShown = false;
                    //       //   });
                    //       //   if(formKey.currentState.validate())
                    //       //   {
                    //       //     // cubit.signIn(
                    //       //     //   email: emailController.text,
                    //       //     //   password: passwordController.text,
                    //       //     //   lang: 'ar',
                    //       //     // );
                    //       //   }
                    //       // },
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsetsDirectional.only(
                    //         end: 2.5,
                    //         top: 3.0,
                    //       ),
                    //       // ignore: deprecated_member_use
                    //       child: RaisedButton(
                    //         onPressed: (){
                    //           // hide or show password
                    //           setState(() {
                    //             passwordIsShown = !passwordIsShown;
                    //           });
                    //         },
                    //         color: const Color(0x7CFF0028).withAlpha(19),
                    //         highlightColor: const Color(0x7CFF0028).withAlpha(5),
                    //         splashColor: const Color(0x7CFF0028).withAlpha(25),
                    //         padding: const EdgeInsets.all(0),
                    //         shape: const RoundedRectangleBorder(
                    //           borderRadius: BorderRadiusDirectional.only(
                    //             topEnd: Radius.circular(50),
                    //             bottomEnd: Radius.circular(50),
                    //           ),
                    //         ),
                    //         elevation: 0,
                    //         focusElevation: 0,
                    //         highlightElevation: 0,
                    //         child: Container(
                    //           alignment: Alignment.center,
                    //           width: 60,
                    //           height: 53.5,
                    //           decoration: const BoxDecoration(
                    //             // color: Colors.red,
                    //             borderRadius: BorderRadiusDirectional.only(
                    //               topEnd: Radius.circular(50),
                    //               bottomEnd: Radius.circular(50),
                    //             ),
                    //           ),
                    //           child:  Text(
                    //             passwordSuffix,
                    //             style: const TextStyle(
                    //               color: Color(0x7CFF0028),
                    //               fontWeight: FontWeight.bold,
                    //               fontSize: 17,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    /* Register button */
                    // SizedBox(height: 10.sp),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     const Text(
                    //       'Don\'t have an account?',
                    //       style: TextStyle(
                    //         color: Color(0x7C323F48),
                    //         fontSize: 15,
                    //         fontWeight: FontWeight.w500,
                    //       ),
                    //     ),
                    //     const SizedBox(width: 2.5),
                    //     GestureDetector(
                    //       onTap: (){
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => const RegisterScreen(),
                    //           ),
                    //         );
                    //       },
                    //       child: const Text(
                    //         'Create',
                    //         style: TextStyle(
                    //           // color: Colors.grey[600],
                    //           color: Color(0x7CFF0028),
                    //           fontSize: 15,
                    //           fontWeight: FontWeight.w700,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
