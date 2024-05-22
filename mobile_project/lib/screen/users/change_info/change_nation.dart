import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_project/screen/login-regis/inputinfo.dart';
import 'package:mobile_project/util/imagepicker.dart';

class NationChangeScreen extends StatefulWidget {
  final String? text;

  NationChangeScreen({super.key, required this.text});

  @override
  State<NationChangeScreen> createState() => _NationChangeScreenState();
}

class _NationChangeScreenState extends State<NationChangeScreen> {
  List<String> nationList = [];
  String? selectedNation;

  final TextEditingController _textEditingController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('users');

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

  Future<void> updateUserData(String data) async {
    data = selectedNation.toString();
    try {
      if (data.trim().isNotEmpty) {
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          await usersCollection.doc(currentUser.uid).update({'Nation': data});
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
          'Quốc gia',
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
                    "Quốc gia",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  InputDropDown(
                    options: nationList,
                    hintText: selectedNation ?? "Quốc gia",
                    width: 400,
                    onChanged: (String newValue) {
                      setState(() {
                        selectedNation = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                ]),
          ],
        ),
      ),
    );
  }
}
