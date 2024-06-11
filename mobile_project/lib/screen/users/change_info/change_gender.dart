import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';

import '../profile_detail.dart';

class GenderChangeScreen extends StatefulWidget {
  final String? text;

  GenderChangeScreen({super.key, required this.text});

  @override
  State<GenderChangeScreen> createState() => _GenderChangeScreenState();
}

class _GenderChangeScreenState extends State<GenderChangeScreen> {
  final List<String> gender = ["Nam", "Nữ"];

  String? selectedGender;

  final usersCollection = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    _loadUserGender();
  }

  Future<void> _loadUserGender() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc =
            await usersCollection.doc(currentUser.uid).get();
        if (userDoc.exists) {
          setState(() {
            selectedGender = userDoc['Gender'];
          });
        }
      }
    } catch (e) {
      print('Error loading user gender: $e');
    }
  }

  Future<void> updateUserData(String data) async {
    try {
      if (data.trim().isNotEmpty) {
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          await usersCollection.doc(currentUser.uid).update({'Gender': data});
        }
      }
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
            // Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailProfileScreen(),
              ),
            );
          },
          icon: SvgPicture.asset(
            'assets/icons/ep_back.svg',
            width: 30,
            height: 30,
          ),
        ),
        title: const Text(
          'Giới tính',
          style: TextStyle(
              fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: GestureDetector(
              onTap: () {
                if (selectedGender != null) {
                  updateUserData(selectedGender!);
                  // Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailProfileScreen(),
                    ),
                  );
                }
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
                  "Giới tính",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                RadioButtonList(
                  options: gender,
                  selectedOption: selectedGender,
                  onChanged: (String newValue) {
                    setState(() {
                      selectedGender = newValue;
                    });
                  },
                ),
              ],
            ),
          ],
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
    return Column(
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
                if (widget.onChanged != null && value != null) {
                  widget.onChanged!(value);
                }
              },
              activeColor: Colors.blue,
            ),
            Text(
              option,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  @override
  void didUpdateWidget(covariant RadioButtonList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedOption != _selectedOption) {
      setState(() {
        _selectedOption = widget.selectedOption;
      });
    }
  }
}
