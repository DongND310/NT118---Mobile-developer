import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HashTagScreen extends StatefulWidget {
  final String hashtag;
  @override
  State<StatefulWidget> createState() => _HashTagState();

  HashTagScreen(this.hashtag);
}

class _HashTagState extends State<HashTagScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ep_back.svg',
            width: 30,
            height: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/hashtag1.png',
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.hashtag,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                            Text("Bài đăng của 118K",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black38))
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black, // Màu của đường viền
                                  width: 0.8, // Độ rộng của đường viền
                                ),
                              ),
                              child: SizedBox(
                                width: 220,
                                height: 35,
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: SvgPicture.asset(
                                          "assets/icons/vector.svg",
                                        )),
                                    Text(
                                      "Thêm vào yêu thích",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Text("Description here")),
                Container(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: PageScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 1,
                      mainAxisExtent: 160,
                    ),
                    itemCount: 20,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: MediaQuery.of(context).size.width / 2 - 16,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(style: BorderStyle.none, width: 2),
                        ),
                        child: ClipRect(
                          child: Image.network(
                            'https://i.pinimg.com/736x/fd/7f/48/fd7f480aa83946195f004f34a0da9ad8.jpg',
                            width: MediaQuery.of(context).size.width / 2 - 16,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            )),
      ),
    );
  }
}
