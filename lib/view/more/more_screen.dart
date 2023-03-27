import 'package:flutter/material.dart';
import 'package:ramadan_kareem/helpers/push_to.dart';
import 'package:ramadan_kareem/view/base/internet_consumer_builder.dart';
import 'package:ramadan_kareem/view/more/base/more_item_builder.dart';
import 'package:ramadan_kareem/view/screens/settings/update_data_screen.dart';
import 'package:ramadan_kareem/ztrash/shared/styles.dart';
import 'package:sizer/sizer.dart';

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
