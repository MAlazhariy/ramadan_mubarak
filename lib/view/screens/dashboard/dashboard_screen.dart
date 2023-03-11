import 'package:ams_garaihy/providers/section_provider.dart';
import 'package:ams_garaihy/utils/routes.dart';
import 'package:ams_garaihy/view/screens/exercises/exercises_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ams_garaihy/view/screens/home/home_screen.dart';
import 'package:ams_garaihy/view/screens/exams/exams_screen.dart';
import 'package:ams_garaihy/view/screens/settings/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ExamsScreen(),
    ExercisesScreen(),
    // ChatScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(Provider.of<SectionProvider>(context, listen: false).isSectionNotSelected){
        Navigator.pushReplacementNamed(context, Routes.getSelectSectionScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_currentIndex),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home_rounded),
            title: Text("home".tr()),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.quiz),
            title: Text("exams".tr()),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.text_snippet_rounded),
            title: Text("exercises".tr()),
          ),
          // todo: add chat screen bar item
          // SalomonBottomBarItem(
          //   icon: const Icon(Icons.chat),
          //   title: Text("chats".tr()),
          // ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.more_horiz),
            title: Text("settings".tr()),
          ),
        ],
      ),
    );
  }
}
