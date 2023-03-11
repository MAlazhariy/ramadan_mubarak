
import 'package:flutter/material.dart';
import 'package:ramadan_kareem/helpers/network_check.dart';
import 'package:ramadan_kareem/view/widgets/snack_bar.dart';
import 'package:ramadan_kareem/shared/styles.dart';
import 'package:sizer/sizer.dart';

class ScreenName extends StatefulWidget {
  const ScreenName({Key? key}) : super(key: key);

  @override
  State<ScreenName> createState() => _PendingDataScreenState();
}

class _PendingDataScreenState extends State<ScreenName> {


  @override
  void initState() {
    super.initState();

    hasNetwork().then((connected) {
      if (!connected) {
        SnkBar(
          context,
          'أنت غير متصل بالإنترنت !',
          seconds: 4,
          backgroundColor: Colors.red,
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),

      // makes keyboard shown over the bottom sheet
      resizeToAvoidBottomInset: false,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 40,
          ),
          child: Column(
            children: [
              // back button
              Align(
                alignment: AlignmentDirectional.center,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
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
                      width: 70.w,
                      child: Text(
                        'مراجعة الأسماء',
                        style: Theme.of(context).textTheme.headline2?.copyWith(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
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
