import 'package:flutter/material.dart';
import 'package:bubblediary/Pages/Settings.dart';
import 'package:bubblediary/Pages/bubble_lens_notes.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    BubbleLensNotes(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Align(
          alignment: Alignment
              .bottomCenter, // this is needed to align the Container properly
          child: Container(
            width: 250, // adjust the width as per your needs
            child: CrystalNavigationBar(
              enablePaddingAnimation: true,
              currentIndex: _currentIndex,
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              outlineBorderColor: Theme.of(context).primaryColor,
              onTap: (index) async {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                CrystalNavigationBarItem(icon: Icons.event_note),
                CrystalNavigationBarItem(icon: Icons.settings),
              ],
              unselectedItemColor: Theme.of(context).highlightColor,
              selectedItemColor: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
