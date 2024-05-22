import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_project/screen/users/change_info/change_bio.dart';
import 'package:mobile_project/screen/users/change_info/change_dob.dart';
import 'package:mobile_project/screen/users/change_info/change_email.dart';
import 'package:mobile_project/screen/users/change_info/change_gender.dart';
import 'package:mobile_project/screen/users/change_info/change_id.dart';
import 'package:mobile_project/screen/users/change_info/change_name.dart';
import 'package:mobile_project/screen/users/change_info/change_nation.dart';
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

  final Map<String, Widget Function(String)> screenMap = {
    '_bio': (change) => BioChangeScreen(text: change),
    '_dob': (change) => DobChangeScreen(text: change),
    '_email': (change) => EmailChangeScreen(text: change),
    '_gender': (change) => GenderChangeScreen(text: change),
    '_id': (change) => IdChangeScreen(text: change),
    '_name': (change) => NameChangeScreen(text: change),
    '_phone': (change) => PhoneChangeScreen(text: change),
    '_nation': (change) => NationChangeScreen(text: change),
    '_pass': (change) => PassChangeScreen(text: change),
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
        Expanded(
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
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
                        builder: (context) => screenMap[lead] != null
                            ? screenMap[lead]!(change)
                            : Container(),
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
        ),
      ],
    );
  }
}
