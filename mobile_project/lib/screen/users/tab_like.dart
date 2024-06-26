import 'package:flutter/material.dart';

class LikeTab extends StatelessWidget {
  const LikeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemCount: 28,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 3 / 4),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(0.5),
          child: Container(
            color: const Color.fromARGB(255, 243, 121, 162),
          ),
        );
      },
    );
  }
}
