import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_project/components/inputtext.dart';
import 'package:mobile_project/components/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'regisnoti.dart';

class InputInfoScreen extends StatefulWidget {
  InputInfoScreen({key, User? data}) : super(key: key);
  // final String email;
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
  List<String> dayList = [];

  final List<String> yearList =
      List.generate(2015 - 1970, (index) => (2015 - index).toString());
  List<String> nationList = [];

  final user = FirebaseAuth.instance.currentUser!;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final List<String> gender = ["Nam", "Nữ"];
  final accountnameController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();

  String? selectedMonth;
  String? preMonth;
  String? selectedDay;
  String? selectedYear;
  String? selectedGender;

  @override
  void initState() {
    super.initState();
  }

  bool isValidPhoneNumber(String phoneNumber) {
    // Số điện thoại hợp lệ phải có độ dài là 10 ký tự và bắt đầu bằng số 0
    final regex = RegExp(r'^0\d{9}$');
    return regex.hasMatch(phoneNumber);
  }

  Future inputPersonalInfo() async {
    String month = selectedMonth.toString();
    String day = selectedDay.toString();
    String year = selectedYear.toString();
    String dob = '$month $day, $year';
    String gender = selectedGender.toString();
    String phoneNumber = phoneController.text.trim();

    Future<void> MissingInfoDialog(String message) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Chưa hoàn thành'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: const Text('OK', style: TextStyle(color: Colors.blue)),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }

    if (accountnameController.text.trim().isEmpty ||
        usernameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        dob.isEmpty ||
        day == "null" ||
        month == "null" ||
        year == "null" ||
        gender == "null") {
      MissingInfoDialog(
          'Vui lòng nhập đầy đủ các thông tin để hoàn thành hồ sơ tài khoản.');
      return;
    }

    if (!isValidPhoneNumber(phoneNumber)) {
      MissingInfoDialog(
          'Số điện thoại không hợp lệ. Số điện thoại phải có 10 ký tự và bắt đầu bằng số 0.');
      return;
    }

    await addPersonalDetail(
        user.uid,
        accountnameController.text.trim(),
        usernameController.text.trim(),
        phoneController.text.trim(),
        dob,
        user.email!,
        gender,
        null,
        'https://i.pinimg.com/564x/47/09/80/470980b112a44064cd88290ac0edf6a6.jpg',
        '');
  }

  Future addPersonalDetail(
      String uid,
      String id,
      String name,
      String phone,
      String dob,
      String email,
      String gender,
      String? bio,
      String? img,
      String token) async {
    // DocumentReference userRef =
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'UID': uid,
      'ID': id,
      'Name': name,
      'Phone': phone,
      'DOB': dob,
      'Email': email,
      'Gender': gender,
      'Bio': bio,
      'Avt': img,
      'push_token': token
    });
    user.updateDisplayName(name);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => RegisterSuccessScreen()));
  }

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
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0, left: 20, right: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(children: [
              const Text(
                'Thông tin người dùng',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
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
                  const SizedBox(height: 10),
                  // user name, name, phone,...
                  MyTextField(
                    controller: accountnameController,
                    label: "Tên tài khoản",
                    hint: "Nhập tên tài khoản",
                  ),
                  MyTextField(
                    controller: usernameController,
                    label: "Tên người dùng",
                    hint: "Nhập tên người dùng",
                  ),
                  MyTextField(
                    controller: phoneController,
                    label: "Số điện thoại",
                    hint: "Nhập số điện thoại người dùng",
                  ),
                  //dob
                  const SizedBox(height: 20),
                  const Text(
                    'Ngày sinh',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InputDropDown(
                        options: monthList,
                        hintText: "Tháng",
                        width: 95,
                        onChanged: (String value) {
                          setState(() {
                            selectedMonth = value;
                            if (value == "Feb") {
                              dayList = List.generate(
                                  29, (index) => (index + 1).toString());
                            } else if (value == "Apr" ||
                                value == "Jun" ||
                                value == "Sep" ||
                                value == "Nov") {
                              dayList = List.generate(
                                  30, (index) => (index + 1).toString());
                            } else {
                              dayList = List.generate(
                                  31, (index) => (index + 1).toString());
                            }
                          });
                        },
                      ),
                      InputDropDown(
                        options: dayList,
                        hintText: "Ngày",
                        width: 95,
                        onChanged: (String value) {
                          setState(() {
                            selectedDay = value;
                            print('selectD: $value');
                          });
                        },
                      ),
                      InputDropDown(
                        options: yearList,
                        hintText: "Năm",
                        width: 95,
                        onChanged: (String value) {
                          setState(() {
                            selectedYear = value;
                          });
                        },
                      ),
                    ],
                  ),
                  //gender
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Giới tính',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      RadioButtonList(
                        options: gender,
                        onChanged: (String newValue) {
                          setState(() {
                            selectedGender = newValue;
                          });
                        },
                      )
                    ],
                  ),

                  //nation
                  const SizedBox(height: 20),

                  // button
                  MyButton(
                    onTap: inputPersonalInfo,
                    text: "TIẾP TỤC",
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ]),
          ),
        ),
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
    super.key,
    required this.options,
    this.hintText,
    this.onChanged,
    this.width,
  });
  @override
  _InputDropDownState createState() => _InputDropDownState();
}

class _InputDropDownState extends State<InputDropDown> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: InputDecorator(
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Colors.black12),
              borderRadius: BorderRadius.circular(5)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Colors.blue),
              borderRadius: BorderRadius.circular(5)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedOption,
            hint: widget.hintText != null
                ? Text(
                    widget.hintText!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  )
                : null,
            onChanged: (newValue) {
              setState(() {
                selectedOption = newValue;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(newValue!);
              }
            },
            items: widget.options.map((option) {
              return DropdownMenuItem(
                value: option,
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
    super.key,
    required this.options,
    this.selectedOption,
    this.onChanged,
  });
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
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                )),
          ],
        );
      }).toList(),
    );
  }
}
