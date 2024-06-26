import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchFollowerBar extends StatefulWidget {
  final Function (String) onChange;
  TextEditingController controller = TextEditingController();
  SearchFollowerBar(this.onChange, this.controller, {super.key});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchFollowerBar> {
  late Function (String) _onChange;
  TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    _onChange = widget.onChange;
    _textEditingController = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: SizedBox(
        height: 40,
        width: 350,
        child: TextField(
          controller: _textEditingController,
          onChanged: _onChange,
          style: const TextStyle(
            fontSize: 18,
          ),
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 8, bottom: 8),
              child: SvgPicture.asset(
                'assets/icons/search.svg',
              ),
            ),
            hintText: "Tìm kiếm...",
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
      ),
    );
  }
}
