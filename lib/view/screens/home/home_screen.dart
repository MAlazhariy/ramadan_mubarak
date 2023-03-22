import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:provider/provider.dart';
import 'package:ramadan_kareem/providers/doaa_provider.dart';
import 'package:ramadan_kareem/utils/resources/assets_manger.dart';
import 'package:ramadan_kareem/utils/resources/dimensions_manager.dart';
import 'package:ramadan_kareem/ztrash/shared/cache_helper/cache_helper.dart';
import 'package:ramadan_kareem/ztrash/shared/components/components/description_text.dart';
import 'package:ramadan_kareem/ztrash/shared/components/components/doaa_text.dart';
import 'package:ramadan_kareem/ztrash/shared/components/components/headline_text.dart';
import 'package:ramadan_kareem/ztrash/shared/components/constants.dart';
import 'package:ramadan_kareem/ztrash/shared/styles.dart';
import 'package:ramadan_kareem/ztrash/adeya.dart';
import 'package:ramadan_kareem/helpers/notification_ready_funcs.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = 'Test name';
  String doaa = 'Test doaa here';
  int counter = 0;
  final controller = ScrollController();

  void next() {
    setState(() {
      ++counter;
      CacheHelper.setCounter(counter);

      int index = counter % CacheHelper.getLength()!;
    });
  }

  void previous() {
    setState(() {
      --counter;
      // Cache.setCounter(counter);
      int? index = counter % CacheHelper.getLength()!;
    });
  }

  void random() {
    setState(() {
      counter = getRandomIndex();
      CacheHelper.setCounter(counter);
    });
  }

  void _scrollListener() {
    final double maxScroll = controller.position.maxScrollExtent;
    final double currentScroll = controller.position.pixels;
    const double delta = 300; // the threshold value
    if (maxScroll - currentScroll <= delta) {
      debugPrint('getting pagination data: $maxScroll - $currentScroll = "${maxScroll - currentScroll}"');
    }
  }

  @override
  void initState() {
    super.initState();

    debugPrint('heloooooo: initState');

    controller.addListener(_scrollListener);

    /// if it's first time set a random value to counter
    /// and save counter .. then set isFirstTime to false
    setState(() {
      if (CacheHelper.isFirstTime()) {
        // get counter random value
        int index = getRandomIndex();
        counter = index;
        // save new counter value to cache
        CacheHelper.setCounter(counter);

        // get name & doaa

        // set IsFirstTime to false
        CacheHelper.setIsFirstTime(false);
      } else {
        int len = CacheHelper.getLength()!;

        if (len != 0) {
          // get counter from cache plus one
          counter = CacheHelper.getCounter() + 1;
          // set index value
          int index = counter;

          CacheHelper.setCounter(counter);
          index = counter % len;
        }
      }
    });

    if (!CacheHelper.isNotificationsDone()) {
      readyShowScheduledNotification(context);
    }

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //
    // });
  }

  @override
  void didChangeDependencies() {
    debugPrint('heloooooo: didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        ImageRes.svg.mosque,
                        width: 100.w,
                        fit: BoxFit.fitWidth,
                        // color: Colors.blue,
                      ),

                      /// الشغل كله هنا بقى
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

                            SizedBox(
                              height: 200,
                              child: Consumer<DoaaProvider>(
                                builder: (context, doaaProvider, _) {
                                  final length = doaaProvider.isLoading ? doaaProvider.users.length+1 : doaaProvider.users.length;

                                  return Row(
                                    children: [
                                      // names
                                      Expanded(
                                        child: InViewNotifierList(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: length,
                                          controller: controller,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: AppSize.s8,
                                          ),
                                          physics: const BouncingScrollPhysics(),
                                          initialInViewIds: [
                                            doaaProvider.lastIndex.toString(),
                                          ],
                                          isInViewPortCondition: (double deltaTop, double deltaBottom, double vpHeight) {
                                            return (deltaTop < (0.2 * vpHeight) && deltaBottom > (0.2 * vpHeight));
                                          },
                                          onListEndReached: () {
                                            debugPrint('onListEndReached');
                                          },
                                          builder: (context, index) {
                                            if(doaaProvider.isLoading && index == length-1){
                                              return Container(
                                                alignment: Alignment.center,
                                                margin: const EdgeInsetsDirectional.only(
                                                  end: AppSize.s8,
                                                ),
                                                child: const SizedBox(
                                                  height: 23,
                                                  width: 23,
                                                  child: CircularProgressIndicator.adaptive(
                                                    strokeWidth: 2.6,
                                                  ),
                                                ),
                                              );
                                            }
                                            final num = index + 1;
                                            final user = doaaProvider.users[index];

                                            final doaaWidget = Hero(
                                              tag: '$index-doaa',
                                              child: RichText(
                                                textAlign: TextAlign.center,
                                                // softWrap: false,
                                                // overflow: TextOverflow.ellipsis,
                                                text: TextSpan(
                                                  text: user.doaa * num * 5,
                                                  style: TextStyle(
                                                    color: black1,
                                                    height: 1.2,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15.sp,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            );
                                            final nameWidget = Hero(
                                              tag: '$index-name',
                                              transitionOnUserGestures: true,
                                              child: RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  text: user.name,
                                                  style: TextStyle(
                                                    color: pinkColor,
                                                    height: 1.1,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 15.sp,
                                                  ),
                                                ),
                                              ),
                                            );

                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(PageRouteBuilder(
                                                    opaque: false,
                                                    barrierDismissible: true,
                                                    pageBuilder: (BuildContext context, _, __) {
                                                      return AlertDialog(
                                                        // title: Text(
                                                        //   '${'name '}$num',
                                                        //   style: TextStyle(
                                                        //     fontSize: 13.sp,
                                                        //   ),
                                                        // ),
                                                        content: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            /// name
                                                            nameWidget,
                                                            SizedBox(
                                                              height: 6.sp,
                                                            ),

                                                            /// doaa
                                                            doaaWidget,
                                                            // Text(
                                                            //   doaa * num,
                                                            //   textAlign: TextAlign.center,
                                                            //   style: TextStyle(
                                                            //     color: black1,
                                                            //     height: 1.2,
                                                            //     fontWeight: FontWeight.w500,
                                                            //     fontSize: 15.sp,
                                                            //   ),
                                                            // ),
                                                          ],
                                                        ),
                                                        // actions: [
                                                        //   SizedBox(
                                                        //     width: double.infinity,
                                                        //     child: Center(
                                                        //       child: Wrap(
                                                        //         spacing: 4.sp,
                                                        //         children: buttons,
                                                        //       ),
                                                        //     ),
                                                        //   ),
                                                        // ],
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12.sp),
                                                        ),
                                                      );
                                                    }));
                                                return;

                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return Directionality(
                                                      textDirection: TextDirection.rtl,
                                                      child: AlertDialog(
                                                        title: Hero(
                                                          tag: '$index-name',
                                                          child: Text(
                                                            '${'name '}$num',
                                                            style: TextStyle(
                                                              fontSize: 13.sp,
                                                            ),
                                                          ),
                                                        ),
                                                        content: SizedBox(
                                                          width: 65.w,
                                                          child: SingleChildScrollView(
                                                            physics: const BouncingScrollPhysics(),
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Hero(
                                                                  tag: '$index-doaa',
                                                                  child: Text(
                                                                    'doaa test',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                      color: black1,
                                                                      height: 1.2,
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 15.sp,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        // actions: [
                                                        //   SizedBox(
                                                        //     width: double.infinity,
                                                        //     child: Center(
                                                        //       child: Wrap(
                                                        //         spacing: 4.sp,
                                                        //         children: buttons,
                                                        //       ),
                                                        //     ),
                                                        //   ),
                                                        // ],
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12.sp),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: InViewNotifierWidget(
                                                id: '$index',
                                                builder: (context, isInView, _) {
                                                  if (isInView) {
                                                    doaaProvider.paginate(index);
                                                    debugPrint('**************');
                                                    for(var i in doaaProvider.users){
                                                      debugPrint('- user: ${i.name} | ${i.timeStamp}');
                                                    }
                                                    debugPrint('**************');
                                                    // debugPrint('index "$index" is in view');
                                                  }
                                                  return Container(
                                                    width: 85.w,
                                                    height: 100,
                                                    margin: const EdgeInsets.symmetric(
                                                      horizontal: AppSize.s8,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8.sp),
                                                      color: isInView ? Colors.blue : pinkColor.withAlpha(15),
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        // Container content goes here
                                                        Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            /// name
                                                            nameWidget,
                                                            SizedBox(
                                                              height: 6.sp,
                                                            ),

                                                            /// doaa
                                                            Expanded(child: doaaWidget),
                                                          ],
                                                        ),
                                                        if (!user.isAlive)
                                                          PositionedDirectional(
                                                            top: 0,
                                                            end: -5,
                                                            child: SvgPicture.asset(
                                                              ImageRes.svg.death,
                                                              height: 100,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
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
                                      mainAxisAlignment: MainAxisAlignment.center,
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
                                      'اختيار عشوائي',
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
                              title: 'فضل الدعاء للغير',
                            ),
                            SizedBox(
                              height: 4.sp,
                            ),
                            const DescriptionText(
                              title:
                                  'إن أفضل الدعاء، دعوة غائب لغائب، فدعاء المسلم لأخيه المسلم بظهر الغيب أنفع وأرجى للإجابة للداعي وللمدعو له، كما أخبرنا النبي ﷺ.\nوقد كان بعض السلف إذا أراد أن يدعو لنفسه، يدعو لأخيه المسلم بتلك الدعوة؛ فتكون أقرب للإجابة ويحصل له مثلها بسبب تأمين الملك.',
                            ),

                            SizedBox(
                              height: 20.sp,
                            ),
                            const HeadlineText(
                              title: 'هيا ندعي بعض الأدعية',
                            ),
                            SizedBox(
                              height: 5.sp,
                            ),
                            const DescriptionText(
                              title:
                                  'قَالَ رَسُول اللَّه ﷺ: (ثَلَاثَةٌ لَا تُرَدُّ دَعْوَتُهُمْ: الصَّائِمُ حَتَّى يُفْطِرَ وَالْإِمَامُ الْعَادِلُ وَالْمَظْلُومُ).',
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
                              title: 'لا تنسونا من صالح دعاءكم 💙',
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
                            //       'هناك بعض الميزات المهمة قيد التعديل حالياً؛ لذلك يرجى تحديث التطبيق فور توفره على المتجر.',
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
    );
  }
}

// Custom clipper to create a diagonal path shape
class _DiagonalPathClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height * 0.8);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
