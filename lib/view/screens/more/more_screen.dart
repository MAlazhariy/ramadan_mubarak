import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramadan_kareem/helpers/push_to.dart';
import 'package:ramadan_kareem/providers/profile_provider.dart';
import 'package:ramadan_kareem/utils/app_uri.dart';
import 'package:ramadan_kareem/view/base/internet_consumer_builder.dart';
import 'package:ramadan_kareem/view/screens/admin/add_user_screen.dart';
import 'package:ramadan_kareem/view/screens/admin/edits_screen.dart';
import 'package:ramadan_kareem/view/screens/admin/new_members_screen.dart';
import 'package:ramadan_kareem/view/screens/login/login_screen.dart';
import 'package:ramadan_kareem/view/screens/more/base/more_item_builder.dart';
import 'package:ramadan_kareem/view/screens/settings/settings_screen.dart';
import 'package:ramadan_kareem/view/screens/update_user/update_user_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المزيد'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.sp,
          vertical: 15.sp,
        ),
        child: InternetConsumerBuilder(
          builder: (context, internetProvider) {
            return Consumer<ProfileProvider>(
              builder: (context, profileProvider, _) {
                return ListView(
                  children: [
                    if (profileProvider.userDetails != null)
                      MoreItemBuilder(
                        title: 'تعديل الدعاء',
                        icon: Icons.edit_outlined,
                        onTap: () {
                          pushTo(context, const UpdateUserDataScreen());
                        },
                      ),
                    MoreItemBuilder(
                      title: 'صفحتنا على فيسبوك',
                      icon: Icons.facebook_outlined,
                      onTap: () async {
                        await launchUrlString(
                          AppUri.FACEBOOK_PAGE,
                          mode: LaunchMode.externalNonBrowserApplication,
                        );
                      },
                    ),
                    if (profileProvider.userDetails?.isModerator == true)
                      MoreItemBuilder(
                        title: 'إضافة مستخدم',
                        icon: Icons.add,
                        onTap: () async {
                          pushTo(context, const AddUserScreen());
                        },
                      ),
                    if (profileProvider.userDetails?.isModerator == true)
                      MoreItemBuilder(
                        title: 'قبول التعديلات',
                        icon: Icons.manage_accounts_outlined,
                        onTap: () async {
                          pushTo(context, const EditsScreen());
                        },
                      ),
                    if (profileProvider.userDetails?.isModerator == true)
                      MoreItemBuilder(
                        title: 'قبول الأسماء',
                        icon: Icons.checklist,
                        onTap: () async {
                          pushTo(context, const NewMembersScreen());
                        },
                      ),
                  ],
                );
              },
            );
          },
          noInternetScreen: (context, internetProvider) {
            return ListView(
              children: [
                MoreItemBuilder(
                  title: 'تعديل الدعاء',
                  icon: Icons.edit_outlined,
                  onTap: () {
                    pushTo(context, const UpdateUserDataScreen());
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
