import 'package:flutter/material.dart';
import 'package:mobile_project/components/custom_bottom_navigation_bar.dart';
import 'package:mobile_project/screen/homepage/add_video_page.dart';
import 'package:mobile_project/screen/homepage/home_page.dart';
import 'package:mobile_project/screen/homepage/notification_page.dart';
import 'package:mobile_project/screen/message/message_page.dart';
import 'package:mobile_project/screen/users/profile_page.dart';

class NavigationContainer extends StatefulWidget {
  const NavigationContainer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NavigationContainerState createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer> {
  int _selectedPageIndex = 0;

  static List<Widget> _pages = [
    HomePage(),
    MessagePage(),
    AddVideoPage(),
    NotificationPage(),
    ProfilePage(),
  ];

  void _onIconTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages[_selectedPageIndex],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
          selectedPageIndex: _selectedPageIndex, onIconTap: _onIconTapped),
    );
  }
}
