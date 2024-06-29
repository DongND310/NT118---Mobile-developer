import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/constants.dart';
import 'package:mobile_project/models/user_model.dart';
import 'package:mobile_project/screen/Search/widget/video_search.dart';
import 'package:mobile_project/services/database_services.dart';

import '../../users/profile_page.dart';
import '../hashtagview.dart';
import 'account_detail.dart';
import 'hashtag.dart';

class SearchResult extends StatefulWidget {
  final String query;
  final String name;
  final String currentId;

  const SearchResult(
      {super.key, required this.query,
        required this.name,
        required this.currentId});


  @override
  State<StatefulWidget> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  late final String _query;
  late final String _name;
  late final String _uid;
  final DatabaseServices databaseServices = DatabaseServices();
  @override
  void initState() {
    setState(() {
      _query= widget.query.toLowerCase();
      _uid = widget.currentId;
      _name = widget.name;
    });
  }
  Widget build(BuildContext context) {
    return TabBarView(children: [
      SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: usersRef
                      .orderBy('Name')
                      .startAt([_query])
                      .endAt(["$_query\uf8ff"])
                      .where('Name', isNotEqualTo: _name)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return Container();
                    }else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Text("Không có gì để tìm");
                    }
                    else {
                      UserModel user = UserModel.fromDoc(snapshot.data!.docs[0]);
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Tài khoản",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      "Xem thêm",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        color: Color.fromARGB(195, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    "assets/icons/more.svg",
                                    width: 30,
                                    height: 30,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          ( ProfileScreen(visitedUserID:user.uid ,currentUserId: _uid)
                                          ),
                                        ));
                                  },
                                  child: AccountDetail(user.name, user.bio??'', user.avt ?? '')
                              )
                          )
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 15),
                const Text(
                  "Video",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisExtent: 220,
                  ),
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return VideoSearch(
                      "hihi",
                      "30",
                      "hihiihi",
                    );
                  },
                ),
              ],
            ),
          )),
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: usersRef
                          .orderBy('Name')
                          .startAt([_query])
                          .endAt(["$_query\uf8ff"])
                          .where('Name', isNotEqualTo: _name)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState==ConnectionState.waiting){
                          return Container();
                        }else if(!snapshot.hasData){
                          return Container();
                        }
                        else
                        {
                          List<String> listUids = snapshot
                              .data!.docs
                              .map((doc) => doc.id)
                              .toList();
                          return  ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: listUids.length,
                              itemBuilder: (BuildContext context, int index) {
                                UserModel user = UserModel.fromDoc(snapshot.data!.docs[index]);
                                return Expanded(
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                ( ProfileScreen(visitedUserID:user.uid ,currentUserId: _uid)
                                                ),
                                              ));
                                        },
                                        child: AccountDetail(user.name, user.bio??'', user.avt ?? '')
                                    )
                                );

                              });
                        }
                      }
                  )
              )
            ]),
      ),
      Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GridView.builder(
              physics: const PageScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisExtent: 218,
              ),
              itemCount: 20,
              itemBuilder: (BuildContext context, int index) {
                return VideoSearch(
                  "widget.title",
                  "10",
                  "account",
                );
              },
            ),
          )),
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  height: 50 ,
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemExtent: 70,
                      itemCount: 20,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HashTagScreen(
                                          "hashtag nè")));
                            },
                            child: Hashtag("hashtag nè"));
                      }),
                )),
          ],
        ),
      )
    ]);
  }
  // Widget buildVideo()
  // {
  //   return FutureBuilder(
  //     future:usersRef
  //         .where('name', isGreaterThanOrEqualTo: query)
  //         .where('name', isLessThan: '${query}z')
  //         .limit(1).get() ,
  //     builder: (context, snapshot) {
  //       if(snapshot.connectionState==ConnectionState.waiting){
  //         return Container();
  //       }else if(!snapshot.hasData){
  //         return Container();
  //       }
  //       else
  //       {
  //         UserModel user = UserModel.fromDoc(snapshot.data!.docs[0]);
  //         return AccountDetail(user.name, user.bio??'', user.avt ?? '');
  //       }
  //     },
  //   );
  // }
}