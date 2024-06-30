import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_project/screen/homepage/add_video_page.dart';
import 'package:mobile_project/screen/homepage/home_page.dart';
import 'package:mobile_project/screen/homepage/notification_page.dart';
import 'package:mobile_project/screen/message/message_page.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:mobile_project/screen/users/profile_page.dart';

class NavigationContainer extends StatefulWidget {
  NavigationContainer({super.key, required this.currentUserID, this.pageIndex});
  int? pageIndex;
  final String currentUserID;
  @override
  _NavigationContainerState createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer> {
  int _selectedPageIndex = 0;
  final user = FirebaseAuth.instance.currentUser;
  late final List<Widget> _pages = [
    HomePage(currentUserId: widget.currentUserID),
    MessagePage(),
    const AddVideoPage(),
    NotificationPage(),
    ProfileScreen(
      currentUserId: widget.currentUserID,
      visitedUserID: widget.currentUserID,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedPageIndex = widget.pageIndex ?? 0;
  }

  void _onAddButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddVideoPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedPageIndex,
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        buttonBackgroundColor: Colors.white,
        index: _selectedPageIndex,
        backgroundColor: const Color(0xFF107BFD),
        items: [
          CurvedNavigationBarItem(
            labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color:
                    _selectedPageIndex == 0 ? const Color(0xFF107BFD) : null),
            child: SvgPicture.asset(
              _selectedPageIndex == 0
                  ? 'assets/icons/home_filled.svg'
                  : 'assets/icons/home.svg',
              width: 25,
              height: 25,
            ),
          ),
          CurvedNavigationBarItem(
            labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color:
                    _selectedPageIndex == 1 ? const Color(0xFF107BFD) : null),
            child: SvgPicture.asset(
              _selectedPageIndex == 1
                  ? 'assets/icons/message_filled.svg'
                  : 'assets/icons/message.svg',
              width: 25,
              height: 25,
            ),
          ),
          CurvedNavigationBarItem(
            child: Container(
              width: 41,
              height: 41,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF107BFD),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF107BFD),
                      blurRadius: 3.0,
                      spreadRadius: 1.0,
                      offset: Offset(0.0, 2.0),
                    )
                  ]),
              child: const Icon(
                Icons.add,
                color: Color(0xFFF1FCFD),
              ),
            ),
          ),
          CurvedNavigationBarItem(
            labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color:
                    _selectedPageIndex == 3 ? const Color(0xFF107BFD) : null),
            child: SvgPicture.asset(
              _selectedPageIndex == 3
                  ? 'assets/icons/noti_filled.svg'
                  : 'assets/icons/noti.svg',
              width: 25,
              height: 25,
            ),
          ),
          CurvedNavigationBarItem(
            labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color:
                    _selectedPageIndex == 4 ? const Color(0xFF107BFD) : null),
            child: SvgPicture.asset(
              _selectedPageIndex == 4
                  ? 'assets/icons/person_filled.svg'
                  : 'assets/icons/person.svg',
              width: 25,
              height: 25,
            ),
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            _onAddButtonPressed();
          } else {
            setState(() {
              _selectedPageIndex = index;
            });
          }
        },
      ),
    );
  }
}
