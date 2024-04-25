import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchHistoryDetail extends StatefulWidget{
  @override

  State<StatefulWidget> createState() => _SearchHistoryState();
  final List<String> searchhistory;
  final bool showmore;
  SearchHistoryDetail(this.searchhistory, this.showmore, {super.key});
}

class _SearchHistoryState extends State<SearchHistoryDetail>{
  late bool _show;
  @override
  void initState() {
    _show = widget.showmore;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView.builder(
              physics: PageScrollPhysics(),
              shrinkWrap: true,
              itemExtent: 35,
              itemCount: _show ? widget.searchhistory.length : 3,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/history.svg',
                          width: 25,
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            widget.searchhistory[index],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/cancel.svg',
                        width: 25,
                        height: 25,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.searchhistory.removeAt(index);
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          Visibility(
            visible: !_show,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _show = true;
                    });
                  },
                  child: const Text(
                    "Xem thêm",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF107BFD),
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: _show,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Xóa tất cả",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF107BFD),
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          )
        ]
    );
  }
}