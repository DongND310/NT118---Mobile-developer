import 'package:flutter/material.dart';

class UserDetailInfo extends StatelessWidget {
  final String text;
  final String change;
  const UserDetailInfo({
    super.key,
    required this.text,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text ?? '',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        Row(
          children: [
            Text(
              change,
              style: TextStyle(
                  color: const Color.fromARGB(255, 95, 95, 95), fontSize: 16),
            ),
            IconButton(
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => PersonDetailProfileScreen()));
              },
              icon: const Icon(
                Icons.arrow_forward_ios_sharp,
                color: const Color.fromARGB(255, 95, 95, 95),
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
