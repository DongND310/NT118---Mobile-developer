import 'package:flutter/material.dart';

class SaveTab extends StatelessWidget {
  const SaveTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(0),
      itemCount: 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 3 / 4),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(0.5),
          child: Container(
            color: Color.fromARGB(255, 255, 239, 97),
          ),
        );
      },
    );
  }
}
