import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../Search/widget/account_detail.dart';

class SearchMessageScreen extends StatefulWidget{
  final List<String>account =["Account1","Account2","AT","Ái Thủy","Account1","Account1","Account1","Account1","Account1","Account1"];

  @override
  State<StatefulWidget> createState() =>_SearchMessageState();
}

class _SearchMessageState extends State<SearchMessageScreen>{
  TextEditingController _textEditingController = TextEditingController();
  List<String> _search =[];
  FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ep_back.svg',
            width: 30,
            height: 30,
          ),
          onPressed: () {},
        ),
        title: SizedBox(
          height: 30,
          child: TextField(
            controller: _textEditingController,
            focusNode: _focusNode,
            onChanged: (value)
            {

              setState(() {
                _search = widget.account.
                where((element) => element.toLowerCase().contains(_textEditingController.text.toLowerCase())).toList();
              });
            },
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: SvgPicture.asset(
                  'assets/icons/search.svg',
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide.none,
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _textEditingController.clear();
                      _focusNode.unfocus();
                    });
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/cancel.svg',
                  ),
                ),
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemExtent: 100,
                          itemCount:  _textEditingController.text.isNotEmpty? _search.length:widget.account.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _textEditingController.text.isNotEmpty?
                            AccountDetail(_search[index],"")
                                :AccountDetail(widget.account[index],"");
                          }
                      )
                  ),
            ]
        ),
      )
    );
  }
}