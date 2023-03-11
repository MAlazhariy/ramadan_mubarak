import 'dart:async';
import 'dart:io';

import 'package:ams_garaihy/providers/internet_provider_provider.dart';
import 'package:ams_garaihy/utils/resources/color_manger.dart';
import 'package:ams_garaihy/utils/resources/dimensions_manager.dart';
import 'package:ams_garaihy/utils/resources/font_manager.dart';
import 'package:ams_garaihy/utils/resources/text_styles_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  // check internet connection every minute until connected to the internet
  late final _checkInternetStreamPeriodic = Stream.periodic(const Duration(minutes: 1), (count) async {
    debugPrint('$count');
    return await Provider.of<InternetProvider>(context, listen: false).checkConnection();
  });
  late StreamSubscription _sub;

  Future<void> _onPressed() async {
    _sub.pause();
    await Provider.of<InternetProvider>(context, listen: false).checkConnection();
    _sub.resume();
  }

  @override
  void initState() {
    super.initState();
    _sub = _checkInternetStreamPeriodic.asyncMap((event) async => await event).listen((event) {});
  }

  @override
  void dispose() {
    super.dispose();
    _sub.cancel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSize.s16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off,
              size: 80,
              color: kGreyTextColor,
            ),
            const SizedBox(height: AppSize.s14),
            Text(
              'no_internet'.tr(),
              style: kBoldFontStyle.copyWith(
                fontSize: FontSize.s20,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'check_internet'.tr(),
              style: kRegularFontStyle,
            ),
            const SizedBox(height: AppSize.s10),
            Consumer<InternetProvider>(
              builder: (context, internetProvider, _) {
                return internetProvider.loading
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 13,
                        ),
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator.adaptive(
                            strokeWidth: 3,
                            valueColor: const AlwaysStoppedAnimation<Color>(kGreyTextColor),
                            backgroundColor: Platform.isIOS ? kGreyTextColor : null,
                          ),
                        ),
                      )
                    : MaterialButton(
                        onPressed: _onPressed,
                        child: Text('try_again'.tr()),
                      );
              },
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
