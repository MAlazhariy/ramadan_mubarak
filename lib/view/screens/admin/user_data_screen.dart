import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ramadan_kareem/data/model/user_details_model.dart';
import 'package:ramadan_kareem/helpers/date_time_helper.dart';
import 'package:ramadan_kareem/providers/admin_provider.dart';
import 'package:ramadan_kareem/providers/field_doaa_provider.dart';
import 'package:ramadan_kareem/utils/app_string_keys.dart';
import 'package:ramadan_kareem/utils/resources/color_manger.dart';
import 'package:ramadan_kareem/utils/resources/dimensions_manager.dart';
import 'package:ramadan_kareem/utils/resources/text_styles_manager.dart';
import 'package:ramadan_kareem/view/base/internet_consumer_builder.dart';
import 'package:ramadan_kareem/view/base/main_button.dart';
import 'package:ramadan_kareem/view/base/custom_text_form.dart';
import 'package:ramadan_kareem/view/base/snack_bar.dart';
import 'package:ramadan_kareem/view/screens/admin/base/custom_checkbox.dart';
import 'package:sizer/sizer.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({
    Key? key,
    required this.user,
    this.sendNotification = true,
  }) : super(key: key);

  final UserDetails user;
  final bool sendNotification;

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  var nameCtrl = TextEditingController();
  var doaaCtrl = TextEditingController();
  var notifTitleCtrl = TextEditingController();
  var notifBodyCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();
  late bool sendNotification;
  bool isApprovedNotification = true;
  bool isAdmin = false;
  late final isEdit;

  @override
  void initState() {
    sendNotification = widget.sendNotification;
    isEdit = widget.user.doaaUpdate.isNotEmpty;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!mounted) return;
      setState(() {
        nameCtrl.text = widget.user.nameUpdate.isNotEmpty ? widget.user.nameUpdate : widget.user.name;
        doaaCtrl.text = widget.user.doaaUpdate.isNotEmpty ? widget.user.doaaUpdate : widget.user.doaa;
        setNotificationDefTitle();
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

  void setNotificationDefTitle() {
    if (isEdit) {
      notifTitleCtrl.text = isApprovedNotification ? AppStrings.defaultApproveUpdateFCMTitle : AppStrings.defaultRejectUpdateFCMTitle;
      notifBodyCtrl.text = isApprovedNotification ? AppStrings.defaultApproveUpdateFCMBody : AppStrings.defaultRejectUpdateFCMBody;
    } else {
      notifTitleCtrl.text = isApprovedNotification ? AppStrings.defaultApproveFCMTitle : AppStrings.defaultRejectFCMTitle;
      notifBodyCtrl.text = isApprovedNotification ? AppStrings.defaultApproveFCMBody : AppStrings.defaultRejectFCMBody;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name),
      ),

      // makes keyboard shown over the bottom sheet
      resizeToAvoidBottomInset: true,

      body: InternetConsumerBuilder(
        builder: (context, internetProvider) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p25,
              vertical: AppPadding.p20,
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Consumer<FieldDoaaProvider>(
                        builder: (context, doaaProvider, _) {
                          // const arabicDiacritics = 'ًٌٍَُِّْ';

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // name
                              CustomTextForm(
                                controller: nameCtrl,
                                validator: (value) {
                                  return value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null;
                                },
                                keyboardType: TextInputType.name,
                                inputAction: TextInputAction.next,
                                labelText: 'الاسم',
                                prefixIcon: Icon(
                                  Icons.account_circle_outlined,
                                  color: doaaProvider.isInNameField ? kPrimarySemiLightColor : kLightGreyColor,
                                  size: 19.sp,
                                ),
                                // inputFormatters: [
                                //   FilteringTextInputFormatter.allow(RegExp('[\u0600-\u06FF\\s]+')),
                                // ],
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
                                prefixIcon: Icon(
                                  Icons.article_outlined,
                                  color: doaaProvider.isInDoaaField ? kPrimarySemiLightColor : kLightGreyColor,
                                  size: 19.sp,
                                ),
                                // maxLength: doaaProvider.maxDoaaLength,
                                counterText: '',
                                // inputFormatters: [
                                //   FilteringTextInputFormatter.allow(
                                //     RegExp('[\u0600-\u06FF$arabicDiacritics\\s]*'),
                                //   ),
                                // ],
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

                              const Divider(),
                              // date time
                              Padding(
                                padding: const EdgeInsets.only(bottom: AppSize.s5),
                                child: Text(
                                  widget.user.time.toCustomString,
                                  locale: const Locale('ar'),
                                  textDirection: TextDirection.rtl,
                                  style: kRegularFontStyle.copyWith(
                                    fontSize: 10.sp,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              // is alive
                              Consumer<AdminProvider>(
                                builder: (context, adminProvider, _) {
                                  return CustomCheckbox(
                                    title: 'على قيد الحياة',
                                    value: widget.user.isAlive,
                                    onChanged: (value) {
                                      widget.user.isAlive = value ?? true;
                                      Provider.of<AdminProvider>(context, listen: false).notify();
                                    },
                                  );
                                },
                              ),
                              CustomCheckbox(
                                title: 'مشرف',
                                value: isAdmin,
                                onChanged: (value) {
                                  setState(() {
                                    isAdmin = value ?? false;
                                  });
                                },
                              ),
                              CustomCheckbox(
                                title: 'إرسال إشعار',
                                value: sendNotification,
                                onChanged: (value) {
                                  setState(() {
                                    sendNotification = value ?? true;
                                  });
                                },
                              ),
                              if (sendNotification)
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomCheckbox(
                                        title: 'إشعار قبول',
                                        value: isApprovedNotification,
                                        onChanged: (value) {
                                          isApprovedNotification = value ?? true;
                                          setNotificationDefTitle();
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: CustomCheckbox(
                                        title: 'إشعار رفض',
                                        value: !isApprovedNotification,
                                        onChanged: (value) {
                                          isApprovedNotification = value == false;
                                          setNotificationDefTitle();
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: AppSize.s10),

                              if (sendNotification)
                                // notification title
                                Padding(
                                  padding: const EdgeInsets.only(bottom: AppSize.s18),
                                  child: CustomTextForm(
                                    controller: notifTitleCtrl,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 6,
                                    labelText: 'عنوان الإشعار',
                                    prefixIcon: Icon(
                                      Icons.title,
                                      size: 19.sp,
                                    ),
                                  ),
                                ),
                              if (sendNotification)
                                // notification body
                                Padding(
                                  padding: const EdgeInsets.only(bottom: AppSize.s12),
                                  child: CustomTextForm(
                                    controller: notifBodyCtrl,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 6,
                                    labelText: 'وصف الإشعار',
                                    prefixIcon: Icon(
                                      Icons.description_outlined,
                                      size: 19.sp,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSize.s12),

                // buttons
                if (!isEdit)
                  Consumer<AdminProvider>(
                    builder: (context, adminProvider, _) {
                      if (adminProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator.adaptive());
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: MainButton(
                              title: 'قبول',
                              color: kCorrectColor,
                              flat: true,
                              fit: true,
                              outlined: false,
                              horizontalContentPadding: 0,
                              onPressed: () async {
                                final nTitle = notifTitleCtrl.text.isNotEmpty && isApprovedNotification ? notifTitleCtrl.text : null;
                                final nBody = notifBodyCtrl.text.isNotEmpty && isApprovedNotification ? notifBodyCtrl.text : null;

                                await adminProvider
                                    .approveNewUser(
                                  user: widget.user,
                                  sendNotification: sendNotification,
                                  name: nameCtrl.text,
                                  doaa: doaaCtrl.text,
                                  isAdmin: isAdmin,
                                  notificationTitle: nTitle,
                                  notificationBody: nBody,
                                )
                                    .then((response) {
                                  if (response.isSuccess) {
                                    SnkBar.showSuccess(
                                      context,
                                      'تم قبول ${widget.user.name}',
                                      milliseconds: 500,
                                    );
                                  } else {
                                    SnkBar.showError(
                                      context,
                                      response.message ?? 'حدثت مشكلة',
                                    );
                                  }
                                });

                                if (!mounted) return;
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          const SizedBox(width: AppSize.s8),
                          Expanded(
                            child: MainButton(
                              title: 'رفض',
                              color: kWrongColor,
                              flat: true,
                              fit: true,
                              outlined: true,
                              horizontalContentPadding: 0,
                              onPressed: () async {
                                final nTitle = notifTitleCtrl.text.isNotEmpty && !isApprovedNotification ? notifTitleCtrl.text : null;
                                final nBody = notifBodyCtrl.text.isNotEmpty && !isApprovedNotification ? notifBodyCtrl.text : null;

                                debugPrint('user data: ${widget.user.toJson()}');

                                await adminProvider
                                    .rejectNewUser(
                                  user: widget.user,
                                  sendNotification: sendNotification,
                                  name: nameCtrl.text,
                                  doaa: doaaCtrl.text,
                                  isAdmin: isAdmin,
                                  notificationBody: nBody,
                                  notificationTitle: nTitle,
                                )
                                    .then((response) {
                                  if (response.isSuccess) {
                                    SnkBar.showSuccess(
                                      context,
                                      'تم رفض ${widget.user.name}',
                                      milliseconds: 500,
                                    );
                                  } else {
                                    SnkBar.showError(
                                      context,
                                      response.message ?? 'حدثت مشكلة',
                                    );
                                  }
                                });

                                if (!mounted) return;
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                if (isEdit)
                  Consumer<AdminProvider>(
                    builder: (context, adminProvider, _) {
                      if (adminProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator.adaptive());
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: MainButton(
                              title: 'تعديل',
                              color: kCorrectColor,
                              flat: true,
                              fit: true,
                              outlined: false,
                              horizontalContentPadding: 0,
                              onPressed: () async {
                                final nTitle = notifTitleCtrl.text.isNotEmpty && isApprovedNotification ? notifTitleCtrl.text : null;
                                final nBody = notifBodyCtrl.text.isNotEmpty && isApprovedNotification ? notifBodyCtrl.text : null;

                                await adminProvider
                                    .approveUserEdits(
                                  user: widget.user,
                                  sendNotification: sendNotification,
                                  name: nameCtrl.text,
                                  doaa: doaaCtrl.text,
                                  isAdmin: isAdmin,
                                  notificationTitle: nTitle,
                                  notificationBody: nBody,
                                )
                                    .then((response) {
                                  if (response.isSuccess) {
                                    SnkBar.showSuccess(
                                      context,
                                      'تم قبول تعديل ${widget.user.name}',
                                      milliseconds: 500,
                                    );
                                  } else {
                                    SnkBar.showError(
                                      context,
                                      response.message ?? 'حدثت مشكلة',
                                    );
                                  }
                                });

                                if (!mounted) return;
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          const SizedBox(width: AppSize.s8),
                          Expanded(
                            child: MainButton(
                              title: 'رفض',
                              color: kWrongColor,
                              flat: true,
                              fit: true,
                              outlined: true,
                              horizontalContentPadding: 0,
                              onPressed: () async {
                                final nTitle = notifTitleCtrl.text.isNotEmpty && !isApprovedNotification ? notifTitleCtrl.text : null;
                                final nBody = notifBodyCtrl.text.isNotEmpty && !isApprovedNotification ? notifBodyCtrl.text : null;

                                debugPrint('user data: ${widget.user.toJson()}');

                                await adminProvider
                                    .rejectUserEdits(
                                  user: widget.user,
                                  sendNotification: sendNotification,
                                  name: nameCtrl.text,
                                  doaa: doaaCtrl.text,
                                  isAdmin: isAdmin,
                                  notificationBody: nBody,
                                  notificationTitle: nTitle,
                                )
                                    .then((response) {
                                  if (response.isSuccess) {
                                    SnkBar.showSuccess(
                                      context,
                                      'تم رفض تعديل ${widget.user.name}',
                                      milliseconds: 500,
                                    );
                                  } else {
                                    SnkBar.showError(
                                      context,
                                      response.message ?? 'حدثت مشكلة',
                                    );
                                  }
                                });

                                if (!mounted) return;
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
