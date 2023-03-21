import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ramadan_kareem/providers/auth_provider.dart';
import 'package:ramadan_kareem/providers/field_doaa_provider.dart';
import 'package:ramadan_kareem/utils/resources/assets_manger.dart';
import 'package:ramadan_kareem/utils/resources/color_manger.dart';
import 'package:ramadan_kareem/utils/resources/dimensions_manager.dart';
import 'package:ramadan_kareem/utils/resources/text_styles_manager.dart';
import 'package:ramadan_kareem/utils/routes.dart';
import 'package:ramadan_kareem/view/screens/home/home_screen.dart';
import 'package:ramadan_kareem/view/base/internet_consumer_builder.dart';
import 'package:ramadan_kareem/view/base/main_button.dart';
import 'package:ramadan_kareem/ztrash/shared/cache_helper/cache_helper.dart';
import 'package:ramadan_kareem/ztrash/shared/components/constants.dart';
import 'package:ramadan_kareem/view/screens/login/done_screen.dart';
import 'package:ramadan_kareem/helpers/dismiss_keyboard.dart';
import 'package:ramadan_kareem/helpers/network_check.dart';
import 'package:ramadan_kareem/helpers/push_and_finish.dart';
import 'package:ramadan_kareem/view/base/snack_bar.dart';
import 'package:ramadan_kareem/view/base/custom_text_form.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var nameCtrl = TextEditingController();
  var doaaCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();

  Future<void> _submitLogin(AuthProvider authProvider) async {
    dismissKeyboard(context);

    if (!formKey.currentState!.validate()) {
      return;
    }

    final responseModel = await authProvider.login(
      name: nameCtrl.text.trim(),
      doaa: doaaCtrl.text.trim(),
    );

    if (responseModel.isSuccess) {
      return _navigate();
    } else {
      if (!mounted) return;
      SnkBar.showError(context, responseModel.message ?? 'حدث خطأ، يرجى المحاولة مرة أخرى لاحقًا');
    }
  }

  Future<void> _navigate() async {
    if (!CacheHelper.isNotificationsDone()) {
      // Go to DoneScreen
      pushAndFinish(context, const DoneScreen());
    } else {
      // Go to HomeScreen
      Navigator.pushNamedAndRemoveUntil(context, Routes.getDashboardScreen(), (route) => false);
    }
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.restoreSystemUIOverlays();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      body: InternetConsumerBuilder(
        builder: (context, internetProvider) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                height: 15.h,
                child: SvgPicture.asset(
                  ImageRes.svg.appBar,
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              Expanded(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      top: 20.sp,
                      start: 20.sp,
                      end: 20.sp,
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'مرحبًا',
                            style: Theme.of(context).textTheme.headline1?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 65,
                                  color: const Color(0xE639444C),
                                  // letterSpacing: 1.2,
                                ),
                          ),
                          SizedBox(height: 15.sp),
                          Text(
                            'قم بتسجيل الدخول للمتابعة\nاكتب اسمك الثنائي الذي تحب أن يدعو لك الآخرين به، ثم اكتب الدعاء بصيغة الغائب.',
                            style: Theme.of(context).textTheme.headline2?.copyWith(
                                  color: Colors.black38,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w400,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 30.sp),

                          Consumer<FieldDoaaProvider>(
                            builder: (context, doaaProvider, _) {
                              const arabicDiacritics = 'ًٌٍَُِّْ';

                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  /// name
                                  CustomTextForm(
                                    controller: nameCtrl,
                                    validator: (value) {
                                      return value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null;
                                    },
                                    keyboardType: TextInputType.name,
                                    inputAction: TextInputAction.next,
                                    hintText: 'الاسم ثنائي',
                                    prefixIcon: Icon(
                                      Icons.account_circle_outlined,
                                      color: doaaProvider.isInNameField ? kPrimarySemiLightColor : kLightGreyColor,
                                      size: 19.sp,
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp('[\u0600-\u06FF\\s]+')),
                                    ],
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
                          SizedBox(height: 20.sp),

                          // login button
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, _) {
                              if (authProvider.isLoading) {
                                return const Center(child: CircularProgressIndicator.adaptive());
                              }

                              return MainButton(
                                onPressed: () async {
                                  await _submitLogin(authProvider);
                                },
                                title: 'تسجيل الدخول',
                                fontSize: 19.5,
                                fit: false,
                                flat: false,
                              );
                            },
                          ),

                          const SizedBox(height: AppPadding.p5),
                          TextButton(
                            onPressed: () {
                              _navigate();
                            },
                            child: Text(
                              'متابعة دون تسجيل الدخول',
                              style: kMediumFontStyle,
                            ),
                          ),
                          SizedBox(height: 20.sp),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
