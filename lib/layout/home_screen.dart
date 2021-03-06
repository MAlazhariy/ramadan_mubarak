import 'dart:developer' as dev;
import 'package:adhan/adhan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:ramadan_kareem/models/users_model.dart';
import 'package:ramadan_kareem/modules/adeya.dart';
import 'package:ramadan_kareem/modules/notification_api.dart';
import 'package:ramadan_kareem/modules/notification_ready_funcs.dart';
import 'package:ramadan_kareem/modules/settings/settings_screen.dart';
import 'package:ramadan_kareem/shared/cache_helper/cache_helper.dart';
import 'package:ramadan_kareem/shared/components/components/push.dart';
import 'package:ramadan_kareem/shared/network/firebase_funcs.dart';
import 'package:ramadan_kareem/shared/components/components/description_text.dart';
import 'package:ramadan_kareem/shared/components/components/doaa_text.dart';
import 'package:ramadan_kareem/shared/components/components/headline_text.dart';
import 'package:ramadan_kareem/shared/components/components/network_check.dart';
import 'package:ramadan_kareem/shared/components/components/snack_bar.dart';
import 'package:ramadan_kareem/shared/components/constants.dart';
import 'package:ramadan_kareem/shared/styles.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/timezone.dart' as tz;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = '';
  String doaa = '';
  int counter = 0;

  // final List<UserDataModel> users = userModel.data.where((user) => user.approved == true).toList();

  void next() {
    setState(() {
      ++counter;
      Cache.setCounter(counter);
      int index = counter % Cache.getLength();

      name =
          userModel.data.where((user) => user.approved == true).toList()[index]
              .name;
      doaa =
          userModel.data.where((user) => user.approved == true).toList()[index]
              .doaa;
    });
  }

  void previous() {
    setState(() {
      --counter;
      // Cache.setCounter(counter);
      int index = counter % Cache.getLength();

      name =
          userModel.data.where((user) => user.approved == true).toList()[index]
              .name;
      doaa =
          userModel.data.where((user) => user.approved == true).toList()[index]
              .doaa;
    });
  }

  void random() {
    setState(() {
      counter = getRandomIndex();
      Cache.setCounter(counter);

      name = userModel.data.where((user) => user.approved == true)
          .toList()[counter].name;
      doaa = userModel.data.where((user) => user.approved == true)
          .toList()[counter].doaa;
    });
  }

  @override
  void initState() {
    super.initState();

    /// if it's first time set a random value to counter
    /// and save counter .. then set isFirstTime to false
    setState(() {

    if (Cache.isFirstTime()) {
    // get counter random value
    int index = getRandomIndex();
    counter = index;
    // save new counter value to cache
    Cache.setCounter(counter);

    // get name & doaa
    name = userModel.data.where((user) => user.approved == true).toList()[counter].name;
    doaa = userModel.data.where((user) => user.approved == true).toList()[counter].doaa;

    // set IsFirstTime to false
    Cache.setIsFirstTime(false);
    } else {
    int len = Cache.getLength();

    if (len != 0) {
    // get counter from cache plus one
    counter = Cache.getCounter() + 1;
    // set index value
    int index = counter;

    Cache.setCounter(counter);
    index = counter % len;

    name = userModel.data.where((user) => user.approved == true).toList()[index].name;
    doaa = userModel.data.where((user) => user.approved == true).toList()[index].doaa;
    }
    }

    });


    if (!Cache.isNotificationsDone()) {
    readyShowScheduledNotification(context);
    }

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var hijriDay = HijriCalendar.fromDate(DateTime.now()).toFormat('dd').padLeft(2, '??');
    var hijriDay = HijriCalendar.fromDate(DateTime.now()).toFormat('dd');
    var hijriMY = HijriCalendar.fromDate(DateTime.now()).toFormat('MMMM yyyy');

    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        textDirection: TextDirection.rtl,
        children: [

          /// BG
          SizedBox(
            // height: 35.h,
            width: 100.w,
            child: SvgPicture.asset(
              'assets/images/bg3.svg',
              fit: BoxFit.fitWidth,
              alignment: AlignmentDirectional.topCenter,
            ),
          ),

          /// fawanees
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: Container(
              padding: EdgeInsetsDirectional.only(
                end: 7.w,
              ),
              height: 18.h,
              // width: 100.w,
              child: SvgPicture.asset(
                'assets/images/helal2.svg',
                // fit: BoxFit.contain,
                alignment: AlignmentDirectional.bottomEnd,
              ),
            ),
          ),

          /// hijri data
          SafeArea(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.sp,
                    vertical: 15.sp,
                  ),
                  margin: EdgeInsetsDirectional.only(
                    top: 2.h,
                    start: 5.5.w,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0XFFFBA557).withAlpha(160),
                        const Color(0XFFEC3161).withAlpha(160),
                      ],
                      begin: AlignmentDirectional.topStart,
                      end: AlignmentDirectional.bottomEnd,
                    ),
                    borderRadius: BorderRadius.circular(15.sp),
                  ),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        hijriDay,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 55.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        hijriMY,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// screen
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 12.h,
                  ),
                  Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/images/mosque2.svg',
                        width: 100.w,
                        fit: BoxFit.fitWidth,
                        // color: Colors.blue,
                      ),

                      /// ?????????? ?????? ?????? ??????
                      Container(
                        color: offWhiteColor,
                        width: 100.w,
                        // height: 600.h,
                        margin: EdgeInsets.only(
                          top: 21.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            /// hadeeth
                            Padding(
                              padding: EdgeInsetsDirectional.only(
                                start: 15.sp,
                                end: 15.sp,
                                bottom: 18.sp,
                              ),
                              child: Text(
                                '?????????? ???????????? ???????????? ???: (?????????????? ???????????? ???????????????????? ?????????????? ???????????????? ???????????????? ?????????????????????????? ?????????? ?????????????? ?????????? ???????????????? ?????????????? ?????????? ???????????????? ?????????? ???????? ???????????????? ???????????????????? ????????: ?????????????? ?????????? ??????????????).',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  // fontWeight: FontWeight.w500,
                                  height: 1.5,
                                  color: greyColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            /// name and doaa
                            Container(
                              color: pinkColor.withAlpha(15),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.sp,
                                vertical: 20.sp,
                              ),
                              width: 100.w,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // previous
                                  MaterialButton(
                                    onPressed: () {
                                      previous();
                                    },
                                    shape: const CircleBorder(),
                                    padding: EdgeInsets.all(2.sp),
                                    minWidth: 6.w,
                                    color: pinkColor,
                                    // elevation: 0,
                                    focusElevation: 0,
                                    highlightElevation: 0,
                                    hoverElevation: 0,
                                    disabledElevation: 0,
                                    child: Icon(
                                      Icons.navigate_before,
                                      size: 16.sp,
                                      color: offWhiteColor,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [

                                        /// name
                                        Text(
                                          name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: pinkColor,
                                            height: 1.1,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 6.sp,
                                        ),

                                        /// doaa
                                        Text(
                                          doaa,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: black1,
                                            height: 1.2,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // next
                                  MaterialButton(
                                    onPressed: () {
                                      next();
                                    },
                                    shape: const CircleBorder(),
                                    padding: EdgeInsets.all(2.sp),
                                    minWidth: 6.w,
                                    color: pinkColor,
                                    // elevation: 0,
                                    focusElevation: 0,
                                    highlightElevation: 0,
                                    hoverElevation: 0,
                                    disabledElevation: 0,
                                    child: Icon(
                                      Icons.navigate_next,
                                      size: 16.sp,
                                      color: offWhiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // buttons
                            Padding(
                              padding: EdgeInsets.symmetric(
                                // horizontal: 14.sp,
                                horizontal: 8.w,
                                vertical: 4.sp,
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: MaterialButton(
                                  onPressed: () {
                                    random();
                                  },
                                  minWidth: 85.w,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.sp),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8.sp,
                                  ),
                                  // minWidth: 6.w,
                                  color: pinkColor.withAlpha(10),
                                  elevation: 0,
                                  focusElevation: 0,
                                  highlightElevation: 0,
                                  hoverElevation: 0,
                                  disabledElevation: 0,
                                  child: SizedBox(
                                    // width: 30.w,
                                    child: Text(
                                      '???????????? ????????????',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: pinkColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 15.sp,
                            ),

                            // doaa pic
                            Align(
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                'assets/images/doaa_icon.svg',
                                width: 50.w,
                                fit: BoxFit.fitWidth,
                                // color: Colors.blue,
                              ),
                            ),

                            SizedBox(
                              height: 20.sp,
                            ),
                            const HeadlineText(
                              title: '?????? ???????????? ??????????',
                            ),
                            SizedBox(
                              height: 4.sp,
                            ),
                            const DescriptionText(
                              title:
                              '???? ???????? ?????????????? ???????? ???????? ???????????? ?????????? ???????????? ?????????? ???????????? ???????? ?????????? ???????? ?????????? ?????????????? ???????????? ?????????????? ?????? ?????? ???????????? ?????????? ???.\n?????? ?????? ?????? ?????????? ?????? ???????? ???? ???????? ???????????? ???????? ?????????? ???????????? ???????? ?????????????? ?????????? ???????? ?????????????? ?????????? ???? ?????????? ???????? ?????????? ??????????.',
                            ),

                            SizedBox(
                              height: 20.sp,
                            ),
                            const HeadlineText(
                              title: '?????? ???????? ?????? ??????????????',
                            ),
                            SizedBox(
                              height: 5.sp,
                            ),
                            const DescriptionText(
                              title:
                              '?????????? ???????????? ???????????? ???: (?????????????????? ?????? ?????????????? ????????????????????????: ???????????????????? ???????????? ???????????????? ???????????????????????? ???????????????????? ????????????????????????????).',
                            ),
                            SizedBox(
                              height: 12.sp,
                            ),

                            Container(
                              height: 30.h,
                              // width: double.maxFinite,
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                              ),
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 80.w,
                                    height: 30.h,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.sp,
                                    ),
                                    // height: 25.sp,
                                    decoration: BoxDecoration(
                                      color: pinkColor.withAlpha(10),
                                      borderRadius: BorderRadius.circular(8.sp),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        child: DoaaText(
                                          doaa: adeya[index],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 4.w,
                                  );
                                },
                                itemCount: adeya.length,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                              ),
                            ),

                            SizedBox(
                              height: 20.sp,
                            ),
                            const HeadlineText(
                              title: '???? ???????????? ???? ???????? ???????????? ????',
                            ),

                            // SizedBox(
                            //   height: 25.sp,
                            // ),
                            //
                            // Padding(
                            //   padding: EdgeInsets.symmetric(
                            //     horizontal: 35.sp,
                            //   ),
                            //   child: Align(
                            //     alignment: Alignment.center,
                            //     child: Text(
                            //       '???????? ?????? ?????????????? ???????????? ?????? ?????????????? ?????????????? ???????? ???????? ?????????? ?????????????? ?????? ?????????? ?????? ????????????.',
                            //       style: TextStyle(
                            //         fontSize: 11.sp,
                            //         fontWeight: FontWeight.w500,
                            //         height: 1.5,
                            //         color: Colors.red,
                            //       ),
                            //       textAlign: TextAlign.center,
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              height: 35.sp,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          push(
            context,
            SettingsScreen(),
          );
        },
        child: const Icon(Icons.settings),
      ),
    );
  }
}
