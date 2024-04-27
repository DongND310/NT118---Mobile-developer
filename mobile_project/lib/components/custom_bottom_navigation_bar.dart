import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_project/screen/homepage/add_video_page.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar(
      {super.key, required this.selectedPageIndex, required this.onIconTap});
  final int selectedPageIndex;
  final Function onIconTap;

  @override
  Widget build(BuildContext context) {
    final barHeight = MediaQuery.of(context).size.height * 0.06;
    final style = Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(fontSize: 10, fontWeight: FontWeight.w600);
    return BottomAppBar(
      color: selectedPageIndex == 0
          ? const Color(0xFF000141)
          : const Color(0xFFF1FCFD),
      child: SizedBox(
        height: barHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _bottomBarNavItem(0, 'Trang chủ', style, 'home'),
            _bottomBarNavItem(1, 'Hộp thư', style, 'message'),
            _addVideoNavItem(barHeight, context),
            _bottomBarNavItem(3, 'Thông báo', style, 'noti'),
            _bottomBarNavItem(4, 'Hồ sơ', style, 'person'),
          ],
        ),
      ),
    );
  }

  _bottomBarNavItem(
      int index, String label, TextStyle textStyle, String iconName) {
    bool isSelected = selectedPageIndex == index;
    Color iconAndTextColor = isSelected ? const Color(0xFF107BFD) : Colors.grey;

    if (isSelected && selectedPageIndex == 0) {
      iconAndTextColor = Colors.white;
    }

    return GestureDetector(
      onTap: () => {onIconTap(index)},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/${isSelected ? '${iconName}_filled' : iconName}.svg',
          ),
          const SizedBox(
            height: 1,
          ),
          Text(
            label,
            style: textStyle.copyWith(color: iconAndTextColor),
          )
        ],
      ),
    );
  }

  _addVideoNavItem(double height, BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) {
              return const AddVideoPage();
            },
          ),
        )
      },
      child: SizedBox(
        height: height + 5,
        width: 48,
        child: Center(
          child: Container(
            width: 41,
            height: height + 5,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF107BFD),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF107BFD), // Shadow color
                    blurRadius: 3.0, // Shadow blur radius
                    spreadRadius: 1.0, // Shadow spread radius
                    offset: Offset(0.0, 2.0), // Shadow offset
                  )
                ]),
            child: const Icon(
              Icons.add,
              color: Color(0xFFF1FCFD),
            ),
          ),
        ),
      ),
    );
  }
}
