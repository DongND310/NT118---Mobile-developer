import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SuggestDetail extends StatelessWidget {
  @override
  final List<String> hashtag;

  SuggestDetail(this.hashtag);

  Widget build(BuildContext context) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: hashtag.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        hashtag[index],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(//video
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 16,
                          height: 320,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(style: BorderStyle.none,width: 2),
                          ),
                          child: ClipRect(
                            child: Image.network(
                              'https://i.pinimg.com/736x/fd/7f/48/fd7f480aa83946195f004f34a0da9ad8.jpg',
                              width: MediaQuery.of(context).size.width / 2 - 16,
                              height: 160,
                              fit: BoxFit.cover,),),
                        ),
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 16,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(style: BorderStyle.none,width: 2),
                              ),
                              child: ClipRect(
                                child: Image.network(
                                  'https://i.pinimg.com/736x/fd/7f/48/fd7f480aa83946195f004f34a0da9ad8.jpg',
                                  width: MediaQuery.of(context).size.width / 2 - 16,
                                  height: 160,
                                  fit: BoxFit.cover,),),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 16,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(style: BorderStyle.none,width: 2),
                              ),
                              child: ClipRect(
                                child: Image.network(
                                  'https://i.pinimg.com/736x/fd/7f/48/fd7f480aa83946195f004f34a0da9ad8.jpg',
                                  width: MediaQuery.of(context).size.width / 2 - 16,
                                  height: 160,
                                  fit: BoxFit.cover,),),
                            )
                          ],
                        )
                      ],
                    )
                )
              ],
            ),
          );
        }
    );
  }
}