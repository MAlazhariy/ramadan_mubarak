// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:ramadan_kareem/view/screens/home/home_screen.dart';
import 'package:ramadan_kareem/ztrash/shared/components/constants.dart';
import 'package:ramadan_kareem/ztrash/users_model.dart';
import 'package:ramadan_kareem/view/screens/login/done_screen.dart';
import 'package:ramadan_kareem/shared/cache_helper/cache_helper.dart';
import 'package:ramadan_kareem/view/widgets/custom_dialog.dart';
import 'package:ramadan_kareem/view/widgets/dialog_buttons.dart';
import 'package:ramadan_kareem/helpers/dismiss_keyboard.dart';
import 'package:ramadan_kareem/helpers/network_check.dart';
import 'package:ramadan_kareem/helpers/push_and_finish.dart';
import 'package:ramadan_kareem/view/widgets/snack_bar.dart';
import 'package:ramadan_kareem/view/widgets/custom_text_form.dart';
import 'package:ramadan_kareem/shared/components/constants.dart';
import 'package:ramadan_kareem/shared/network/firebase_funcs.dart';
import 'package:sizer/sizer.dart';

enum Field {
  // ignore: constant_identifier_names
  NAME,
  DOAA,
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var nameCtrl = TextEditingController();
  var doaaCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();
  Field? _field;

  // bool passwordIsShown = false;
  bool loading = false;

  Future<void> login({
    required String name,
    required String doaa,
  }) async {
    setState(() {
      loading = true;
    });

    await hasNetwork().then((hasNetwork) async {
      if (hasNetwork) {
        int time = DateTime.now().toUtc().microsecondsSinceEpoch;

        FirebaseFirestore.instance.collection('users').doc(deviceId).set({
          'name': name,
          'doaa': doaa,
          'device_id': deviceId,
          'approved': false,
          'time': time,
          'nameUpdate': '',
          'doaaUpdate': '',
          'pendingEdit': false,
        }).then((_) {
          setState(() {
            loading = false;
          });

          Cache.hasLoggedIn();

          Cache.setUserLoginInfo(
            name: name,
            doaa: doaa,
            time: time,
            docId: deviceId??name,
          );

          userModel?.data.add(UserDataModel.fromMap({
            'name': name,
            'doaa': doaa,
            'device_id': deviceId,
            'approved': true,
            'time': time,
            'nameUpdate': '',
            'doaaUpdate': '',
            'pendingEdit': false,
          }));

          if (!Cache.isNotificationsDone()) {
            // Go to DoneScreen
            pushAndFinish(context, const DoneScreen());
          } else {
            // Go to HomeScreen
            pushAndFinish(context, const HomeScreen());
          }
        }).catchError((error) {
          setState(() {
            loading = false;
          });
          log(error.toString());
          SnkBar(context, error.toString());
        });
      } else {
        SnkBar(
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
        loading = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loading = false;
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
                      style: Theme.of(context).textTheme.headline1?.copyWith(
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
                      style: Theme.of(context).textTheme.headline2?.copyWith(
                            color: Colors.black38,
                            fontSize: 19.5,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    SizedBox(
                      height: 30.sp,
                    ),

                    /// name
                    CustomTextForm(
                      controller: nameCtrl,
                      validator: (value) {
                        return value?.isEmpty??true ? 'هذا الحقل مطلوب' : null;
                      },
                      keyboardType: TextInputType.name,
                      inputAction: TextInputAction.next,
                      hintText: 'الاسم ثنائي',
                      prefixIcon: Icon(
                        Icons.account_circle_outlined,
                        color: _field == Field.NAME ? const Color(0x7CFF0028) : const Color(0x7C323F48),
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

                    /// doaa
                    CustomTextForm(
                      controller: doaaCtrl,
                      validator: (value) {
                        return value?.isEmpty??true ? 'هذا الحقل مطلوب' : null;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 6,
                      hintText: 'اكتب دعاءك المفضل بصيغة الغائب، مثال: "اللهم اغفر له"',
                      prefixIcon: Icon(
                        Icons.article_outlined,
                        color: _field == Field.DOAA ? const Color(0x7CFF0028) : const Color(0x7C323F48),
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
                      child: MaterialButton(
                        onPressed: () async {
                          setState(() {});
                          dismissKeyboard(context);

                          if (formKey.currentState!.validate()) {
                            await login(
                              name: nameCtrl.text,
                              doaa: doaaCtrl.text,
                            );
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
                              style: Theme.of(context).textTheme.headline2?.copyWith(
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
                    //       validator: (value)
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
                    //       //   if(formKey.currentState!.validate())
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
                    //       child: MaterialButton(
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
