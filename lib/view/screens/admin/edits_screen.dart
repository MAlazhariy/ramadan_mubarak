import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramadan_kareem/data/model/user_details_model.dart';
import 'package:ramadan_kareem/helpers/date_time_helper.dart';
import 'package:ramadan_kareem/helpers/push_to.dart';
import 'package:ramadan_kareem/providers/admin_provider.dart';
import 'package:ramadan_kareem/utils/resources/color_manger.dart';
import 'package:ramadan_kareem/utils/resources/dimensions_manager.dart';
import 'package:ramadan_kareem/utils/resources/text_styles_manager.dart';
import 'package:ramadan_kareem/view/base/internet_consumer_builder.dart';
import 'package:ramadan_kareem/view/base/main_button.dart';
import 'package:ramadan_kareem/view/base/snack_bar.dart';
import 'package:ramadan_kareem/view/screens/admin/base/custom_checkbox.dart';
import 'package:ramadan_kareem/view/screens/admin/user_data_screen.dart';
import 'package:ramadan_kareem/ztrash/shared/styles.dart';
import 'package:sizer/sizer.dart';

class EditsScreen extends StatefulWidget {
  const EditsScreen({Key? key}) : super(key: key);

  @override
  State<EditsScreen> createState() => _EditsScreenState();
}

class _EditsScreenState extends State<EditsScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<AdminProvider>(context, listen: false).getEditsPending();
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التعديلات'),
      ),

      // makes keyboard shown over the bottom sheet
      resizeToAvoidBottomInset: true,

      body: InternetConsumerBuilder(
        builder: (context, internetProvider) {
          return Consumer<AdminProvider>(
            builder: (context, adminProvider, _) {
              if(adminProvider.updatedUsers.isEmpty){
                return RefreshIndicator(
                  onRefresh: () async {
                    await adminProvider.getEditsPending();
                  },
                  child: const Center(child: Text('لا يوجد تعديلات جديدة')),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await adminProvider.getEditsPending();
                },
                child: ListView.separated(
                  itemCount: adminProvider.updatedUsers.length,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p20,
                    vertical: AppPadding.p20,
                  ),
                  itemBuilder: (context, index) {
                    final user = adminProvider.updatedUsers[index];
                    return _NewUserBuilder(user: user);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: AppSize.s12);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _NewUserBuilder extends StatefulWidget {
  const _NewUserBuilder({Key? key, required this.user}) : super(key: key);

  final UserDetails user;

  @override
  State<_NewUserBuilder> createState() => _NewUserBuilderState();
}

class _NewUserBuilderState extends State<_NewUserBuilder> {
  bool sendNotification = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await pushTo(
            context,
            UserDataScreen(
              user: widget.user,
              sendNotification: sendNotification,
            ));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: pinkColor.withAlpha(10),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p16,
          vertical: AppPadding.p16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // name
            Text(
              widget.user.name,
              style: kRegularFontStyle.copyWith(
                fontSize: 11.sp,
                color: pinkColor,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            // doaa
            Text(
              widget.user.doaa,
              style: kRegularFontStyle.copyWith(
                fontSize: 9.sp,
                height: 1.5,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const Divider(),
            // name update
            Text(
              widget.user.nameUpdate,
              style: kBoldFontStyle.copyWith(
                fontSize: 14.sp,
                color: pinkColor,
              ),
            ),
            const SizedBox(height: AppSize.s12),
            // doaa update
            Text(
              widget.user.doaaUpdate,
              style: kRegularFontStyle.copyWith(
                fontSize: 11.sp,
                height: 1.5,
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
            CustomCheckbox(
              title: 'على قيد الحياة',
              value: widget.user.isAlive,
              onChanged: (value) {
                widget.user.isAlive = value ?? true;
                Provider.of<AdminProvider>(context, listen: false).notify();
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

            const Divider(),
            // buttons
            Consumer<AdminProvider>(
              builder: (context, adminProvider, _) {
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
                          await adminProvider.approveUserEdits(
                            user: widget.user,
                            sendNotification: sendNotification,
                          ).then((response) {
                            if(response.isSuccess){
                              SnkBar.showSuccess(
                                context,
                                'تم قبول ${widget.user.name}',
                                milliseconds: 500,
                              );
                            } else {
                              SnkBar.showError(
                                context,
                                response.message??'حدثت مشكلة',
                              );
                            }
                          });
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
                          await adminProvider.rejectUserEdits(
                            user: widget.user,
                            sendNotification: sendNotification,
                          ).then((response) {
                            if(response.isSuccess){
                              SnkBar.showSuccess(
                                context,
                                'تم رفض ${widget.user.name}',
                                milliseconds: 500,
                              );
                            } else {
                              SnkBar.showError(
                                context,
                                response.message??'حدثت مشكلة',
                              );
                            }
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
