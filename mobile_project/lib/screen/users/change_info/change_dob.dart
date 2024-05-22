import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/screen/login-regis/inputinfo.dart';

class DobChangeScreen extends StatefulWidget {
  final String? text;

  DobChangeScreen({super.key, required this.text});

  @override
  State<DobChangeScreen> createState() => _DobChangeScreenState();
}

class _DobChangeScreenState extends State<DobChangeScreen> {
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
  final user = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  String? selectedMonth;
  String? selectedDay;
  String? selectedYear;

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.text != null) {
      _textEditingController.text = widget.text!;
      _initializeDate(widget.text!);
    }
  }

  void _initializeDate(String dob) {
    List<String> parts = dob.split(' ');
    if (parts.length == 3) {
      setState(() {
        selectedMonth = parts[0];
        selectedDay = parts[1].replaceAll(',', '');
        selectedYear = parts[2];
        _updateDayList(selectedMonth);
      });
    }
  }

  void _updateDayList(String? month) {
    if (month == "Feb") {
      dayList = List.generate(29, (index) => (index + 1).toString());
    } else if (month == "Apr" ||
        month == "Jun" ||
        month == "Sep" ||
        month == "Nov") {
      dayList = List.generate(30, (index) => (index + 1).toString());
    } else {
      dayList = List.generate(31, (index) => (index + 1).toString());
    }
  }

  Future<void> updateUserData(String data) async {
    String month = selectedMonth.toString();
    String day = selectedDay.toString();
    String year = selectedYear.toString();
    data = '$month $day, $year';
    try {
      if (data.trim().isNotEmpty) {
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          await usersCollection.doc(currentUser.uid).update({'DOB': data});
        }
      } else {}
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = widget.text ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.black,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.5,
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
        title: const Text(
          'Ngày sinh',
          style: TextStyle(
              fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: GestureDetector(
              onTap: () {
                String data = _textEditingController.text.trim();
                updateUserData(data);
                Navigator.pop(context);
              },
              child: Text(
                'Lưu',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: ListView(
          padding: const EdgeInsets.only(top: 0.0, left: 30, right: 20),
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Ngày sinh",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InputDropDown(
                        options: monthList,
                        hintText: selectedMonth ?? "Tháng",
                        width: 95,
                        onChanged: (String value) {
                          setState(() {
                            selectedMonth = value;
                            _updateDayList(selectedMonth);
                          });
                        },
                      ),
                      InputDropDown(
                        options: dayList,
                        hintText: selectedDay ?? "Ngày",
                        width: 95,
                        onChanged: (String value) {
                          setState(() {
                            selectedDay = value;
                          });
                        },
                      ),
                      InputDropDown(
                        options: yearList,
                        hintText: selectedYear ?? "Năm",
                        width: 95,
                        onChanged: (String value) {
                          setState(() {
                            selectedYear = value;
                          });
                        },
                      ),
                    ],
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}
