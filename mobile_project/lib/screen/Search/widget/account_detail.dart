import 'package:flutter/material.dart';

class AccountDetail extends StatefulWidget {
  @override
  final String account;
  final String descript;
  final String img;

  AccountDetail(this.account, this.descript, this.img);

  @override
  State<AccountDetail> createState() => _AccountDetailState();
}

class _AccountDetailState extends State<AccountDetail> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(style: BorderStyle.none, width: 2),
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.img)
              ),
            )),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.account,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),
              const SizedBox(height: 5),
              Text(widget.descript,
                  style: const TextStyle(fontSize: 16, color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }
}
