import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ramadan_kareem/utils/constants.dart';
import 'package:ramadan_kareem/utils/resources/assets_manger.dart';
import 'package:ramadan_kareem/utils/resources/color_manger.dart';
import 'package:ramadan_kareem/utils/resources/dimensions_manager.dart';
import 'package:ramadan_kareem/utils/resources/text_styles_manager.dart';
import 'package:ramadan_kareem/view/base/main_button.dart';
import 'package:ramadan_kareem/ztrash/shared/styles.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

class ShareAppScreen extends StatelessWidget {
  const ShareAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('صدقة جارية'),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Stack(
          alignment: Alignment.center,
          children: [
            // background
            SvgPicture.asset(
              ImageRes.svg.splashBG,
              fit: BoxFit.cover,
            ),
            // center title & logo
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // hadeeth
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: Container(
                        // alignment: Alignment.center,
                        // height: double.infinity,
                        margin: EdgeInsets.symmetric(
                          horizontal: 12.w,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p30,
                          vertical: AppPadding.p20,
                        ),
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                          // border: Border.all(
                          //   color: pinkColor,
                          //   strokeAlign: 0,
                          //   width: 1.8,
                          // ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.10),
                              blurRadius: 4,
                              spreadRadius: 0,
                              offset: const Offset(1, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // icon
                            // SvgPicture.asset(
                            //   ImageRes.svg.quoteIcon,
                            //   height: 38,
                            // ),
                            const SizedBox(height: AppSize.s20),
                            // quote text
                            Text(
                              'قَالَ رَسُول اللَّه ﷺ: (مَن دَعا إلى هُدًى، كانَ له مِنَ الأجْرِ مِثْلُ أُجُورِ مَن تَبِعَهُ، لا يَنْقُصُ ذلكَ مِن أُجُورِهِمْ شيئًا، ..).\nصحيح مسلم.',
                              // 'قَالَ رَسُول اللَّه ﷺ: (مَن دَعا إلى هُدًى، كانَ له مِنَ الأجْرِ مِثْلُ أُجُورِ مَن تَبِعَهُ، لا يَنْقُصُ ذلكَ مِن أُجُورِهِمْ شيئًا، ومَن دَعا إلى ضَلالَةٍ، كانَ عليه مِنَ الإثْمِ مِثْلُ آثامِ مَن تَبِعَهُ، لا يَنْقُصُ ذلكَ مِن آثامِهِمْ شيئًا).\nصحيح مسلم.',
                              style: kBoldFontStyle.copyWith(
                                fontSize: 12.5.sp,
                                height: 1.6,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: AppSize.s20),
                            // const SizedBox(height: AppSize.s12),
                          ],
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.favorite,
                      size: 40,
                      color: pinkColor,
                    ),
                  ],
                ),
                const SizedBox(height: AppSize.s5),
                // text
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p30 + 10,
                    vertical: AppPadding.p20,
                  ),
                  child: Text(
                    'أظهر بعض الحب لنا ودع التطبيق يصل لغيرك 💖، ولا تنس أن كل مَن يدعو بسببك، فإن لك أجراً مثل أجره 😍',
                    style: kBoldFontStyle.copyWith(
                      fontSize: 12.5.sp,
                      height: 1.65,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppSize.s16),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p30 + 10,
                    // vertical: AppPadding.p20,
                  ),
                  child: MainButton(
                    title: 'شارك التطبيق',
                    onPressed: () async {
                      await Share.share(
                        '${AppConstants.appName} 🌙❤\n${AppConstants.appName} هو تطبيق بيخلينا ندعي لبعض بظهر الغيب 🤲\nقَالَ رَسُول اللَّه ﷺ: (دَعْوةُ المرءِ المُسْلِمِ لأَخيهِ بِظَهْرِ الغَيْبِ مُسْتَجَابةٌ، عِنْد رأْسِهِ ملَكٌ مُوكَّلٌ كلَّمَا دَعَا لأَخِيهِ بخيرٍ قَال المَلَكُ المُوكَّلُ بِهِ: آمِينَ، ولَكَ بمِثْلٍ). رواه مسلم.\n\n- لما نفتح التطبيق هنلاقي ناس ممكن ما نكونش عارفينهم، هندعيلهم بظهر الغيب، والملك هيرد "ولك بمثل" فيكون دعاءنا أقرب للإجابة لينا وللمدعو ليه، زي ما قال سيدنا النبي ﷺ، واحنا كمان اسمنا بيكون ظاهر للمستخدمين التانيين وبيدعولنا هما كمان بظهر الغيب ❤🤲\n\n👈 نزل التطبيق من هنا: https://play.google.com/store/apps/details?id=malazhariy.ramadan_kareem',
                        subject: '${AppConstants.appName} 🌙❤',
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
