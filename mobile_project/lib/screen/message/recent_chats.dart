import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';

class RecentChats extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for(int i=0; i <10;i++)
          Padding(padding: EdgeInsets.symmetric(vertical: 15),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ChatPage()));
              },
              child: Container(
                height: 65,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: Image.network(
                        'https://i.pinimg.com/736x/fd/7f/48/fd7f480aa83946195f004f34a0da9ad8.jpg',
                        height: 65,
                        width: 65,
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal:20 ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Ái Thủy",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF000141)
                            ),),
                          SizedBox(height: 5),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text.rich(
                              TextSpan(
                                text: "Xin chào bạn! Bạn đang làm gì thế hohoho",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("2:10", style: TextStyle(fontSize: 15,color: Colors.black54),),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 23,
                            width: 23,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Color(0xFF001141),
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child:Text("1",style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold),) ,
                          )
                        ],
                      ),)
                  ],
                ),
              ),
            ),)
      ],
    );
  }

}