import 'dart:developer' as dev;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:ramadan_kareem/modules/notification_api.dart';
import 'package:ramadan_kareem/shared/cache_helper/cache_helper.dart';
import 'package:ramadan_kareem/shared/cache_helper/firebase_funcs.dart';
import 'package:ramadan_kareem/shared/components/components/network_check.dart';
import 'package:ramadan_kareem/shared/styles.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/timezone.dart' as tz;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Stream<QuerySnapshot> streamSnapData;
  // List localData = []; // todo:
  String name = '';
  String doaa = '';
  int counter = 0;

  void next() {
    setState(() {
      ++counter;
      Cache.setCounter(counter);
      int index = counter % Cache.getLength();

      name = Cache.getName(index);
      doaa = Cache.getDoaa(index);
    });
  }

  void previous() {
    setState(() {
      --counter;
      // Cache.setCounter(counter);
      int index = counter % Cache.getLength();

      name = Cache.getName(index);
      doaa = Cache.getDoaa(index);
    });
  }

  void random() {
    setState(() {
      int _r = Random().nextInt(Cache.getLength());

      name = Cache.getName(_r);
      doaa = Cache.getDoaa(_r);
    });
  }



  // Future<void> setAlarm() async {
  //   dev.log('Alarm started at ${DateTime.now()}');
  //   var date = DateTime.now().add(const Duration(seconds: 5));
  //   int alarmID = 6;
  //
  //   await AndroidAlarmManager.oneShot(Duration(seconds: 10), alarmID,test);
  // }
  //
  // void test(){
  //   dev.log('finished at ${DateTime.now()}');
  //   print('hi there');
  //   name = 'test';
  //   doaa = 'test bardo';
  //   setState(() {
  //
  //   });
  // }




  // Future<void> getInitData() async {
  //   final bool connected = await hasNetwork();
  //
  //   if (connected) {
  //     // أنا مش عايز أستريم !
  //     // streamSnapData = FirebaseFirestore.instance.collection('users').orderBy('time').snapshots();
  //
  //     List mydata = await getFirebaseData();
  //     Cache.saveData(mydata);
  //   }
  //   setState(() {
  //     localData = Cache.getData();
  //   });
  // }

  Future<void> getData() async {
    final bool connected = await hasNetwork();

    if (connected) {
      List mydata = await getFirebaseData();
      Cache.saveData(mydata);
    }
  }

  @override
  void initState() {
    super.initState();

    NotificationApi.init(true);

    counter = Cache.getCounter();
    int index = counter;

    int len = Cache.getLength();

    if(len != 0) {
      counter++;
      Cache.setCounter(counter);
      index = counter % len;

      name = Cache.getName(index);
      doaa = Cache.getDoaa(index);
    }

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //
    // });
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var hijriDay = HijriCalendar.fromDate(DateTime.now()).toFormat('dd').padLeft(2,'٠');
    var hijriMY = HijriCalendar.fromDate(DateTime.now()).toFormat('MMMM yyyy');

    return Scaffold(
      // body: StreamBuilder<QuerySnapshot>(
      //   stream: users,
      //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (snapshot.hasError) {
      //       return Text('عذرا حدث خطأ، يرجى إبلاغ المبرمج، رمز الخطأ: ${snapshot.error.toString()}');
      //     }else if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const CircularProgressIndicator();
      //     }
      //
      //     final data = snapshot.requireData;
      //
      //     return ListView.builder(
      //       itemCount: data.size,
      //       itemBuilder: (context, index) {
      //         final String name = data.docs[index]['name'];
      //
      //         return Text(name);
      //       },
      //     );
      //   },
      // ),

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

                      /// الشغل كله هنا بقى
                      Container(
                        color: offWhiteColor,
                        width: 100.w,
                        height: 600.h,
                        // todo: remove before line
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
                                'قَالَ رَسُول اللَّه ﷺ: (دَعْوةُ المرءِ المُسْلِمِ لأَخيهِ بِظَهْرِ الغَيْبِ مُسْتَجَابةٌ، عِنْد رأْسِهِ ملَكٌ مُوكَّلٌ كلَّمَا دَعَا لأَخِيهِ بخيرٍ قَال المَلَكُ المُوكَّلُ بِهِ: آمِينَ، ولَكَ بمِثْلٍ).',
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
                                      textDirection: TextDirection.ltr,
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
                                      textDirection: TextDirection.ltr,
                                      color: offWhiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.sp,
                                vertical: 4.sp,
                              ),
                              child: Row(
                                children: [
                                  // next
                                  Expanded(
                                    child: MaterialButton(
                                      onPressed: () {
                                        next();
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.sp),
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
                                        width: 30.w,
                                        child: Text(
                                          'التالي',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: pinkColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5.sp),
                                  // random
                                  Expanded(
                                    child: MaterialButton(
                                      onPressed: () {
                                        random();
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.sp),
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
                                        width: 30.w,
                                        child: Text(
                                          'عشوائي',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: pinkColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5.sp),
                                  // previous
                                  Expanded(
                                    child: MaterialButton(
                                      onPressed: () {
                                        previous();
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.sp),
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
                                        width: 30.w,
                                        child: Text(
                                          'السابق',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: pinkColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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

                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15.sp,
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'فضل الدعاء للغير',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                    color: pinkColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            // hadeeth
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.sp,
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'إن أفضل الدعاء، دعوة غائب لغائب، فدعاء المسلم لأخيه المسلم بظهر الغيب أنفع وأرجى للإجابة للداعي وللمدعو له، كما أخبرنا النبي ﷺ.\nوقد كان بعض السلف إذا أراد أن يدعو لنفسه، يدعو لأخيه المسلم بتلك الدعوة؛ فتكون أقرب للإجابة ويحصل له مثلها بسبب تأمين الملك.',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                    color: greyColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            // لا تنسونا
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15.sp,
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'لا تنسونا من صالح دعاءكم 💙',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                    color: greyColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
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
          // NotificationApi.showNotification(
          //   title: 'دعاء',
          //   body: 'hi there!',
          //   payload: 'sarah.abc',
          //   // date: DateTime.now().add(const Duration(seconds: 5)),
          // );

          print('FAB pressed');

          int index = counter;

          int len = Cache.getLength();
          String nname = '';
          String ndoaa = '';

          if(len != 0) {
            Cache.setCounter(counter);
            index = (counter+1) % len;

            nname = Cache.getName(index);
            ndoaa = Cache.getDoaa(index);
          }
          DateTime now = DateTime.now().toUtc();
          print('now = $now');

          NotificationApi.showScheduledNotification(
            title: 'هيا ندعي لـ $nname',
            body: ndoaa,
            time: Time(now.hour, now.minute, now.second,),
            repeatDuration: const Duration(seconds: 10),
            id: 0,
          );
        },
      ),
    );
  }
}
