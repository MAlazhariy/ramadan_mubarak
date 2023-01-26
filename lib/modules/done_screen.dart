import 'package:flutter/material.dart';
import 'package:ramadan_kareem/layout/home_screen.dart';
import 'package:ramadan_kareem/shared/components/components/push.dart';
import 'package:ramadan_kareem/shared/styles.dart';
import 'package:sizer/sizer.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text(
              //   'تم التسجيل بنجاح',
              //   style: TextStyle(
              //     fontSize: 18.sp,
              //     color: pinkColor,
              //     fontWeight: FontWeight.w700,
              //   ),
              // ),
              // const Divider(
              //   height: 45,
              //   thickness: 1.5,
              //   indent: 20,
              //   endIndent: 20,
              // ),
              // Text(
              //   'تم إرسال طلبك إلى المسؤولين وحالما يتم الموافقة عليه سيظهر فوراً للمستخدمين الآخرين.',
              //   style: TextStyle(
              //     fontSize: 13.sp,
              //     height: 1.4,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              // const Divider(
              //   height: 45,
              //   thickness: 1.5,
              //   indent: 20,
              //   endIndent: 20,
              // ),
              SizedBox(height: 20.sp),
              Icon(
                Icons.location_on,
                size: 40.sp,
                color: pinkColor,
              ),
              SizedBox(height: 5.sp),
              Text(
                'إذن الوصول للموقع',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: pinkColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5.sp),
              Text(
                'هذا الإذن مطلوب؛ حيث يستخدم في حساب مواقيت الصلاة حسب توقيتك المحلي، مما يساعد على ظهور الإشعارات في وقتها الصحيح، ولن تعمل الإشعارات إلا بعد الموافقة على هذا الإذن.',
                style: TextStyle(
                  fontSize: 12.sp,
                  height: 1.4,
                  // fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.sp),
              Text(
                'هذه البيانات لا يتم الاحتفاظ بها أو مشاركتها كما هو موضح في سياسة الخصوصية، لذلك كن مطمئناً.',
                style: TextStyle(
                  fontSize: 9.sp,
                  height: 1.4,
                  // fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // button
              Align(
                alignment: AlignmentDirectional.center,
                child: MaterialButton(
                  onPressed: () {
                    pushAndFinish(
                      context,
                      const HomeScreen(),
                    );
                  },
                  padding: const EdgeInsets.all(0),
                  shape: const StadiumBorder(),
                  highlightElevation: 5,
                  highlightColor: pinkColor.withAlpha(50),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: pinkColor,
                      borderRadius: BorderRadius.circular(15.sp),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 50,
                      ),
                      width: 50.w,
                      child: Text(
                        'متابعة',
                        style: Theme.of(context).textTheme.headline2?.copyWith(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
