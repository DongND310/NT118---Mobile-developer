import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  final bool isChange;
  UserDetailInfo({
    super.key,
    required this.text,
    required this.change,
    required this.lead,
    required this.isChange,
  });

  final Map<String, Widget Function(String)> screenMap = {
    '_bio': (change) => BioChangeScreen(text: change),
    '_dob': (change) => DobChangeScreen(text: change),
    '_email': (change) => EmailChangeScreen(text: change),
    '_gender': (change) => GenderChangeScreen(text: change),
    '_id': (change) => IdChangeScreen(text: change),
    '_name': (change) => NameChangeScreen(text: change),
    '_phone': (change) => PhoneChangeScreen(text: change),
    '_pass': (change) => PassChangeScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  change,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 95, 95, 95),
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis),
                  textAlign: TextAlign.end,
                ),
              ),
              isChange
                  ? IconButton(
                      onPressed: () {
                        if (lead == '_pass') {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text(
                                      'Thông báo',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue),
                                    ),
                                    content: const Text(
                                      'Bạn muốn thay đổi mật khẩu?',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                          child: const Text('Thay đổi',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 17)),
                                          onPressed: () {
                                            Navigator.of(context).pop();

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      screenMap[lead] != null
                                                          ? screenMap[lead]!(
                                                              change)
                                                          : Container(),
                                                ));
                                          }),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      TextButton(
                                        child: const Text('Hủy',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17)),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                    ],
                                  ));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => screenMap[lead] != null
                                    ? screenMap[lead]!(change)
                                    : Container(),
                              ));
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Color.fromARGB(255, 95, 95, 95),
                        size: 20,
                      ),
                    )
                  : const SizedBox(
                      width: 15,
                      height: 40,
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
