// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:ramadan_kareem/layout/home_screen.dart';
import 'package:ramadan_kareem/shared/cache_helper/cache_helper.dart';
import 'package:ramadan_kareem/shared/components/components/custom_dialog/custom_dialog.dart';
import 'package:ramadan_kareem/shared/components/components/custom_dialog/dialog_buttons.dart';
import 'package:ramadan_kareem/shared/components/components/dismiss_keyboard.dart';
import 'package:ramadan_kareem/shared/components/components/network_check.dart';
import 'package:ramadan_kareem/shared/components/components/snack_bar.dart';
import 'package:ramadan_kareem/shared/components/components/white_text_form.dart';
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
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController doaaCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();
  Field _field;
  bool passwordIsShown = false;
  bool loading = false;

  void login({
    @required String name,
    @required String doaa,
    String id,
  }) {
    setState(() {
      loading = true;
    });

    var docValue;
    if(id == null){
      docValue = name;
    } else {
      docValue = id;
    }

    FirebaseFirestore.instance.collection('users').doc(docValue).set({
      'name': name,
      'doaa': doaa,
      'device id': id,
      'time': DateTime.now().toUtc().microsecondsSinceEpoch,
    }).then((value) {
      setState(() {
        loading = false;
      });

      Cache.hasLoggedIn();
      Cache.setUserLoginInfo(
        name: name,
        doaa: doaa,
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const Directionality(
            textDirection: TextDirection.rtl,
            child: HomeScreen(),
          ),
        ),
        (route) => false,
      );
    }).catchError((error) {
      setState(() {
        loading = false;
      });
      print(error.toString());
      snkbar(context, error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    if(Cache.isLogin) return const HomeScreen();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return Scaffold(
      body: Column(
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
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
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
                        // helper:
                        //     _field == Field.DOAA && doaaCtrl.text.isEmpty
                        //         ? 'اكتب الدعاء بصيغة الغائب، على سبيل المثال: لا تكتب "اللهم اغفر لي" واكتب بدلاً من ذلك: "اللهم اغفر له وارحمه"'
                        //         : null,
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

                      /// gender
                      // Row(
                      //   children: [
                      //     // male
                      //     Expanded(
                      //       child: OutlinedButton(
                      //         style: OutlinedButton.styleFrom(
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(15.sp),
                      //           ),
                      //           // side: BorderSide(width: 2, color: Colors.pink, style: BorderStyle.solid),
                      //           side: false
                      //               ? BorderSide.none
                      //               : BorderSide(
                      //                   color: Colors.pink,
                      //                   width: 1.2.sp,
                      //                 ),
                      //           backgroundColor: isMale == true
                      //               ? Colors.pink.withAlpha(50)
                      //               : Colors.transparent,
                      //         ),
                      //         child: Padding(
                      //           padding: EdgeInsets.all(15.sp),
                      //           child: Column(
                      //             mainAxisSize: MainAxisSize.min,
                      //             crossAxisAlignment: CrossAxisAlignment.center,
                      //             children: [
                      //               Icon(
                      //                 Icons.male,
                      //                 size: 35.sp,
                      //               ),
                      //               SizedBox(
                      //                 height: 4.sp,
                      //               ),
                      //               Text('ذكر',
                      //                   style: TextStyle(fontSize: 25.sp)),
                      //             ],
                      //           ),
                      //         ),
                      //         onPressed: () {
                      //           setState(() {
                      //             isMale = true;
                      //           });
                      //         },
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 10.sp,
                      //     ),
                      //     // female
                      //     Expanded(
                      //       child: OutlinedButton(
                      //         style: OutlinedButton.styleFrom(
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(15.sp),
                      //           ),
                      //           // side: BorderSide(width: 2, color: Colors.pink, style: BorderStyle.solid),
                      //           side: false
                      //               ? BorderSide.none
                      //               : BorderSide(
                      //                   color: Colors.pink,
                      //                   width: 1.sp,
                      //                 ),
                      //           backgroundColor: isMale == false
                      //               ? Colors.pink.withAlpha(50)
                      //               : Colors.transparent,
                      //         ),
                      //         child: Padding(
                      //           padding: EdgeInsets.all(15.sp),
                      //           child: Column(
                      //             mainAxisSize: MainAxisSize.min,
                      //             crossAxisAlignment: CrossAxisAlignment.center,
                      //             children: [
                      //               Icon(
                      //                 Icons.female,
                      //                 size: 35.sp,
                      //               ),
                      //               SizedBox(
                      //                 height: 4.sp,
                      //               ),
                      //               Text('أنثى',
                      //                   style: TextStyle(fontSize: 25.sp)),
                      //             ],
                      //           ),
                      //         ),
                      //         onPressed: () {
                      //           setState(() {
                      //             isMale = false;
                      //           });
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 20.sp,
                      ),
                      // button
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {});
                            dismissKeyboard(context);

                            // if (isMale == null) {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //       const SnackBar(
                            //           content: Text(
                            //               'يرجى اختيار النوع (ذكر/أنثى)')));
                            // }

                            if (formKey.currentState.validate()) {
                              showCustomDialog(
                                context: context,
                                title:
                                    'سيظهر دعاءك بهذا الشكل للمستخدمين الآخرين',
                                content: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.sp),
                                    color: Colors.pink.withAlpha(13),
                                  ),
                                  width: double.maxFinite,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15.sp,
                                    vertical: 20.sp,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        nameCtrl.text,
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      SizedBox(height: 5.sp),
                                      Text(
                                        doaaCtrl.text,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                buttons: [
                                  if (!loading)
                                    DialogButton(
                                      title: 'تأكيد',
                                      onPressed: () async {
                                        await hasNetwork().then((value) async {
                                          if (value) {

                                            String id;
                                            try{
                                              id = await PlatformDeviceId.getDeviceId;
                                            } catch (e){};

                                            login(
                                              name: nameCtrl.text,
                                              doaa: doaaCtrl.text,
                                              id: id,
                                            );
                                          } else {
                                            snkbar(context,
                                                'برجاء التحقق من شبكة الإنترنت');
                                            loading = false;
                                            Navigator.pop(context);
                                          }
                                        });
                                      },
                                      isBold: true,
                                    ),
                                  if (loading)
                                    const CircularProgressIndicator(),
                                  if (!loading)
                                    DialogButton(
                                      title: 'رجوع',
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      isBold: false,
                                    ),
                                ],
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
            ),
          ),
        ],
      ),
    );
  }
}
