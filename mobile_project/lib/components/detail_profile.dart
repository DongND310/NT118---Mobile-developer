import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_project/screen/users/change_info/change_bio.dart';
import 'package:mobile_project/screen/users/change_info/change_dob.dart';
import 'package:mobile_project/screen/users/change_info/change_email.dart';
import 'package:mobile_project/screen/users/change_info/change_gender.dart';
import 'package:mobile_project/screen/users/change_info/change_id.dart';
import 'package:mobile_project/screen/users/change_info/change_name.dart';
import 'package:mobile_project/screen/users/change_info/change_phone.dart';
import 'package:mobile_project/screen/users/change_info/change_pass.dart';

class UserDetailInfo extends StatelessWidget {
  final String text;
  final String change;
  final String lead;
  UserDetailInfo({
    super.key,
    required this.text,
    required this.change,
    required this.lead,
  });

  final Map<String, Widget> screenMap = {
    '_bio': BioChangeScreen(),
    '_dob': DobChangeScreen(),
    '_email': EmailChangeScreen(),
    '_gender': GenderChangeScreen(),
    '_id': IdChangeScreen(),
    '_name': NameChangeScreen(),
    '_phone': PhoneChangeScreen(),
    '_pass': PassChangeScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text ?? '',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Container(
              width: 150,
              child: Text(
                change,
                style: TextStyle(
                    color: const Color.fromARGB(255, 95, 95, 95),
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis),
                textAlign: TextAlign.end,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => screenMap[lead] ?? Container(),
                    ));
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
