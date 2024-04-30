import 'package:flutter/material.dart';

class VideoTab extends StatelessWidget {
  const VideoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 14,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 3 / 4),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(0.5),
          child: Container(
            color: Colors.grey,
          ),
        );
      },
    );
  }
}
