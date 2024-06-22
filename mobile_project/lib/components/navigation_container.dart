import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_project/screen/homepage/add_video_page.dart';
import 'package:mobile_project/screen/homepage/home_page.dart';
import 'package:mobile_project/screen/homepage/notification_page.dart';
import 'package:mobile_project/screen/message/message_page.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:mobile_project/screen/users/profile_page.dart';
import 'package:provider/provider.dart';

class NavigationContainer extends StatefulWidget {
  NavigationContainer({super.key, required this.currentUserID, this.pageIndex});
  int? pageIndex;
  final String currentUserID;
  @override
  _NavigationContainerState createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer> {
  int _selectedPageIndex = 0;
  late final List<GlobalKey<NavigatorState>> _navigatorKeys;

  @override
  void initState() {
    super.initState();
    _selectedPageIndex =
        widget.pageIndex ?? 0; // Default to the first page if not specified

    // Initialize navigator keys for each page
    _navigatorKeys = List.generate(5, (index) => GlobalKey<NavigatorState>());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
    });

    switch (index) {
      case 0:
      case 1:
      case 3:
      case 4:
        // Push to the new page using Navigator
        _navigatorKeys[index].currentState?.pushReplacement(
              MaterialPageRoute(builder: (context) => _buildPage(index)),
            );
        break;
      case 2:
        // Handle AddVideoPage navigation if needed
        break;
      default:
        break;
    }
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return HomePage(currentUserId: widget.currentUserID);
      case 1:
        return MessagePage();
      case 2:
        return const AddVideoPage();
      case 3:
        return NotificationPage();
      case 4:
        return ProfileScreen(
          currentUserId: widget.currentUserID,
          visitedUserID: widget.currentUserID,
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: List.generate(
          5,
          (index) => _buildOffstageNavigator(index),
        ),
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
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _selectedPageIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => _buildPage(index),
          );
        },
      ),
    );
  }
}
