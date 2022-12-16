import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmx_player/screen/home_Screen.dart';
import 'package:tmx_player/screen/playlist_screen.dart';

import 'package:tmx_player/screen/search_screen.dart';
import 'package:tmx_player/screen/setting_screen.dart';
import 'package:tmx_player/widgets/colors.dart';

// ignore: non_constant_identifier_names
bool? SWITCHVALUE;

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreen();
}

class _NavigationScreen extends State<NavigationScreen> {
  @override
  void initState() {
    checkNotification();
    super.initState();
  }

  Future<void> checkNotification() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    SWITCHVALUE = sharedPrefs.getBool(NOTIFICATION);
    SWITCHVALUE = SWITCHVALUE ??= true;
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    PlaylistScreen(),
    Search(),
    SettingScreen(),
  ];

  int _currentSelectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: tmxBackground),
      child: Scaffold(
        body: _screens[_currentSelectedIndex],
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 11,
            unselectedFontSize: 10,
            iconSize: 25,
            selectedIconTheme: const IconThemeData(color: navIconsC),
            backgroundColor: tmxBlack,
            selectedItemColor: emptyColors,
            unselectedItemColor: tmxWhite,
            currentIndex: _currentSelectedIndex,
            onTap: (newIndex) {
              setState(() {
                _currentSelectedIndex = newIndex;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_rounded,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.headphones_rounded,
                ),
                label: "Playlist",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.search_rounded,
                ),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                ),
                label: "Settings",
              ),
            ]),
        backgroundColor: tmxTransparent,
      ),
    );
  }
}
