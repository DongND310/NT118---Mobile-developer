import 'package:flutter/material.dart';

class ChangeInfoField extends StatelessWidget {
  final String label;
  // final String? text;
  final controller;

  const ChangeInfoField(
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          TextField(
            controller: controller,
            cursorColor: Colors.blue,
            decoration: InputDecoration(
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.cancel,
                  color: Color.fromARGB(151, 0, 0, 0),
                  size: 22,
                ),
                onPressed: () {
                  controller.clear();
                },
              ),
            ),
            onChanged: (value) {
              controller.text = value;
            },
          ),
          const SizedBox(height: 20),
        ]);
  }
}
