import 'package:flutter/material.dart';
import 'package:ramadan_kareem/view/screens/more/more_screen.dart';
import 'package:ramadan_kareem/view/screens/home/home_screen.dart';
import 'package:ramadan_kareem/view/screens/settings/settings_screen.dart';
import 'package:ramadan_kareem/view/screens/share_app/share_app_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    ShareAppScreen(),
    HomeScreen(),
    MoreScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.favorite),
            title: const Text("صدقة جارية"),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.home_rounded),
            title: const Text("الرئيسية"),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.more_horiz),
            title: const Text("المزيد"),
          ),
        ],
      ),
    );
  }
}
