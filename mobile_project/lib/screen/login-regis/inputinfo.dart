import 'dart:convert';
import 'package:mobile_project/components/inputtext.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'regisnoti.dart';
import 'package:http/http.dart' as http;

class InputInfoScreen extends StatefulWidget {
  InputInfoScreen({key, required this.title}) : super(key: key);

  final String title;

  @override
  State<InputInfoScreen> createState() => _InputInfoScreenState();
}

class _InputInfoScreenState extends State<InputInfoScreen> {
  final List<String> monthList = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  final List<String> dayList = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
    "24",
    "25",
    "26",
    "27",
    "28",
    "29",
    "30",
    "31"
  ];
  final List<String> yearList =
      List.generate(2015 - 1970, (index) => (2015 - index).toString());

  List<String> nationList = [];

  final accountnameController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://restcountries.com/v3.1/all'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        nationList = data
            .map<String>((country) => country['name']['common'] as String)
            .toList();
        nationList.sort();
      });
    } else {
      throw Exception('Failed to load countries');
    }
  }

  final List<String> gender = ["Nam", "Nữ"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            'assets/icons/ep_back.svg',
            width: 30,
            height: 30,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: ListView(
            padding: const EdgeInsets.only(top: 0.0, left: 40, right: 45),
            children: [
              Text(
                'Thông tin người dùng',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Nhập các thông tin dưới đây để hoàn thiện hồ sơ người dùng',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),

                  // user name, name, phone,...
                  MyTextField(
                      controller: accountnameController,
                      label: "Tên tài khoản",
                      hint: "Nhập tên tài khoản",
                      obscureText: false),
                  MyTextField(
                      controller: usernameController,
                      label: "Tên người dùng",
                      hint: "Nhập tên người dùng",
                      obscureText: false),
                  MyTextField(
                      controller: phoneController,
                      label: "Số điện thoại",
                      hint: "Nhập số điện thoại người dùng",
                      obscureText: false),

                  //dob
                  SizedBox(height: 20),
                  Text(
                    'Ngày sinh',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InputDropDown(
                        options: dayList,
                        hintText: "Ngày",
                        width: 95,
                      ),
                      InputDropDown(
                          options: monthList, hintText: "Tháng", width: 95),
                      InputDropDown(
                          options: yearList, hintText: "Năm", width: 95),
                    ],
                  ),

                  //gender
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Giới tính',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      RadioButtonList(
                        options: gender,
                        selectedOption: "Nam",
                      )
                    ],
                  ),

                  //nation
                  SizedBox(height: 20),
                  Text(
                    'Quốc gia',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 5),
                  InputDropDown(
                      options: nationList, hintText: "Quốc gia", width: 400),

                  SizedBox(
                    height: 25,
                  ),

                  SizedBox(
                    height: 25,
                  ),
                  // button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterSuccessScreen()));
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          'TIẾP TỤC',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ]),
      ),
    );
  }
}

class InputDropDown extends StatefulWidget {
  final List<String> options;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final double? width;

  const InputDropDown({
    Key? key,
    required this.options,
    this.hintText,
    this.onChanged,
    this.width,
  }) : super(key: key);

  @override
  _InputDropDownState createState() => _InputDropDownState();
}

class _InputDropDownState extends State<InputDropDown> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: InputDecorator(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.black12),
              borderRadius: BorderRadius.circular(5)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.blue),
              borderRadius: BorderRadius.circular(5)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedOption,
            hint: widget.hintText != null
                ? Text(
                    widget.hintText!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  )
                : null,
            onChanged: (newValue) {
              setState(() {
                _selectedOption = newValue;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(newValue!);
              }
            },
            items: widget.options.map((option) {
              return DropdownMenuItem(
                value: option,
                //child: Text(option),
                child: SizedBox(
                    width: widget.width! * 0.5,
                    child: Text(
                      option,
                      overflow: TextOverflow.ellipsis,
                    )),
              );
            }).toList(),
            menuMaxHeight: 250,
          ),
        ),
      ),
    );
  }
}

class RadioButtonList extends StatefulWidget {
  final List<String> options;
  final String? selectedOption;
  final ValueChanged<String>? onChanged;

  const RadioButtonList({
    Key? key,
    required this.options,
    this.selectedOption,
    this.onChanged,
  }) : super(key: key);

  @override
  _RadioButtonListState createState() => _RadioButtonListState();
}

class _RadioButtonListState extends State<RadioButtonList> {
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.options.map((option) {
        return Row(
          children: [
            Radio<String>(
              value: option,
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(value!);
                }
              },
              activeColor: Colors.blue,
            ),
            Text(option,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                )),
          ],
        );
      }).toList(),
    );
  }
}
