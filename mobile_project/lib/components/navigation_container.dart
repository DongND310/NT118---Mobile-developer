import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/_mock_data/mock.dart';
import 'package:mobile_project/components/custom_bottom_navigation_bar.dart';
import 'package:mobile_project/screen/homepage/add_video_page.dart';
import 'package:mobile_project/screen/homepage/home_page.dart';
import 'package:mobile_project/screen/homepage/notification_page.dart';
import 'package:mobile_project/screen/message/message_page.dart';
import 'package:mobile_project/screen/users/profile_page.dart';

class NavigationContainer extends StatefulWidget {
  NavigationContainer({super.key, required this.currentUserID});

  final String currentUserID;
  @override
  _NavigationContainerState createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer> {
  int _selectedPageIndex = 0;
  final user = FirebaseAuth.instance.currentUser;

  void _onIconTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: [
        HomePage(currentUserId: widget.currentUserID),
        MessagePage(),
        AddVideoPage(),
        NotificationPage(),
        ProfileScreen(
          currentUserId: widget.currentUserID,
          visitedUserID: widget.currentUserID,
        ),
      ][_selectedPageIndex]
          // child: _pages[_selectedPageIndex],
          ),
      bottomNavigationBar: CustomBottomNavigationBar(
          selectedPageIndex: _selectedPageIndex, onIconTap: _onIconTapped),
    );
  }
}
