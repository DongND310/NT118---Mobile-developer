import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';

class ChangeInfoField extends StatelessWidget {
  final String label;
  // final String? text;
  final controller;

  ChangeInfoField(
      {super.key,
      required this.label,
      // required this.text,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 20),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          TextField(
            controller: controller,
            cursorColor: Colors.blue,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: const Color.fromARGB(151, 0, 0, 0),
                  size: 22,
                ),
                onPressed: () {
                  controller.clear();
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
        ]);
  }
}
