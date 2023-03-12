import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ramadan_kareem/providers/auth_provider.dart';
import 'package:ramadan_kareem/providers/splash_provider.dart';
import 'package:ramadan_kareem/utils/resources/color_manger.dart';
import 'package:ramadan_kareem/utils/routes.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'widgets/page_1.dart';
import 'widgets/page_2.dart';
import 'widgets/page_3.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  OnBoardScreenState createState() => OnBoardScreenState();
}

class OnBoardScreenState extends State<OnBoardScreen> {
  double currentIndex = 0;
  bool isLast = false;

  PageController boardController = PageController();

  List<Widget> pages = const [
    BoardPage1(),
    BoardPage2(),
    BoardPage3(),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    return Scaffold(
      backgroundColor: const Color(0xFFECF0F3),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            // horizontal: 20,
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// skip button
              // Align(
              //     alignment: AlignmentDirectional.topEnd,
              //     child: GestureDetector(
              //       child: Text(
              //         !isLast ? 'skip' : '',
              //         style: const TextStyle(
              //           color: kGreyTextColor,
              //           fontSize: 9,
              //           fontWeight: FontWeight.w500,
              //         ),
              //       ),
              //       onTap: (){
              //         if (!isLast) {
              //           setState(() {
              //             boardController.animateToPage(
              //               pages.length - 1,
              //               duration: const Duration(
              //                 milliseconds: 400,
              //               ),
              //               curve: Curves.fastLinearToSlowEaseIn,
              //             );
              //           });
              //         }
              //         else {
              //           null;
              //         }
              //       },
              //     ),
              //   ),

              /// page design
              SizedBox(
                height: 450,
                child: PageView.builder(
                  onPageChanged: (int value) {
                    setState(() {
                      currentIndex = value.toDouble();
                      isLast = (currentIndex == pages.length - 1);
                    });
                  },
                  itemBuilder: (context, index) {
                    return pages[index];
                  },
                  physics: const BouncingScrollPhysics(),
                  itemCount: pages.length,
                  controller: boardController,
                ),
              ),

              /// main button
              LayoutBuilder(
                builder: (_, constraints) {
                  return Tooltip(
                    message: isLast ? 'إنهاء' : 'التالي',
                    child: MaterialButton(
                      autofocus: true,
                      onPressed: () {
                        if (isLast) {
                          Provider.of<SplashProvider>(context, listen: false).setIsAppFirstOpen();
                          Navigator.pushReplacementNamed(
                            context,
                            Provider.of<AuthProvider>(context, listen: false).isLoggedIn
                                ? Routes.getDashboardScreen()
                                : Routes.getLoginScreen(),
                          );
                        } else {
                          /// navigate to next page
                          setState(() {
                            boardController.nextPage(
                              duration: const Duration(
                                milliseconds: 700,
                              ),
                              curve: Curves.fastLinearToSlowEaseIn,
                            );
                          });
                        }
                      },
                      color: isLast ? kMainColor : kGreyTextColor,
                      minWidth: constraints.maxWidth - 100,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      splashColor: Colors.white.withAlpha(25),
                      highlightColor: Colors.white.withAlpha(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLast ? 'إنهاء' : 'التالي',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight:
                                  isLast ? FontWeight.w600 : FontWeight.w600,
                            ),
                          ),
                          // if (!isLast)
                          //   const SizedBox(
                          //     width: 2,
                          //   ),
                          // if (!isLast)
                          //   const Icon(
                          //     Icons.navigate_next,
                          //     color: Colors.white,
                          //   ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(
                height: 15,
              ),

              /// indicator
              Align(
                child: SmoothPageIndicator(
                  controller: boardController,
                  count: pages.length,
                  effect: WormEffect(
                    activeDotColor: kGreyTextColor,
                    dotColor: kGreyTextColor.withAlpha(100),
                    dotHeight: 6,
                    dotWidth: 6,
                    spacing: 6-1,
                    offset: currentIndex,
                  ),
                  onDotClicked: (int index) {
                    setState(() {
                      boardController.animateToPage(
                        index,
                        duration: const Duration(
                          milliseconds: 300,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
