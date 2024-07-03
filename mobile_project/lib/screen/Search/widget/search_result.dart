import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/constants.dart';
import 'package:mobile_project/models/user_model.dart';
import 'package:mobile_project/models/video_model.dart';
import 'package:mobile_project/screen/Search/widget/video_search.dart';
import 'package:mobile_project/services/database_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../components/video_detail.dart';
import '../../users/profile_page.dart';
import 'account_detail.dart';

class SearchResult extends StatefulWidget {
  final String query;
  final String name;
  final String currentId;

  const SearchResult(
      {super.key,
      required this.query,
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
    super.initState();
    setState(() {
      _query = widget.query.toLowerCase();
      _uid = widget.currentId;
      _name = widget.name;
    });
  }

  Future<List<DocumentSnapshot>> _getUsers() async {
    QuerySnapshot querySnapshot =
        await usersRef.where('Name', isNotEqualTo: _name).get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> _getVideos() async {
    QuerySnapshot querySnapshot = await videoRef.get();
    return querySnapshot.docs;
  }

  Future<Map<String, List<DocumentSnapshot>>> _fetchData() async {
    List<Future<List<DocumentSnapshot>>> futures = [
      _getUsers(),
      _getVideos(),
    ];
    List<List<DocumentSnapshot>> results = await Future.wait(futures);
    return {
      'users': results[0],
      'videos': results[1],
    };
  }

  Future<bool> checkFollowing(String uerId) async {
    DocumentSnapshot doc = await followingsRef
        .doc(widget.currentId)
        .collection("userFollowings")
        .doc(uerId)
        .get();
    return doc.exists;
  }

  handleUnfollowUser(String userId) {
    followersRef
        .doc(userId)
        .collection('userFollowers')
        .doc(widget.currentId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    followingsRef
        .doc(widget.currentId)
        .collection('userFollowings')
        .doc(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(widget.currentId);
    userRef.update({
      'followingsList': FieldValue.arrayRemove([userId])
    }).then((_) {
      setState(() {});
    });
  }

  handleFollowUser(String userId, bool isFollowing) {
    followersRef
        .doc(userId)
        .collection('userFollowers')
        .doc(widget.currentId)
        .set({});

    followingsRef
        .doc(widget.currentId)
        .collection('userFollowings')
        .doc(userId)
        .set({});
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(widget.currentId);
    userRef.update({
      'followingsList': FieldValue.arrayUnion([userId])
    });
  }

  buildProfileButton(bool isFollowing, String userId) {
    if (isFollowing) {
      return buildButton(
          text: "Unfollow",
          isFollowing: isFollowing,
          function: () {
            handleUnfollowUser(userId);
            setState(() {
              isFollowing = false;
            });
          });
    } else {
      return buildButton(
          text: "Follow",
          isFollowing: isFollowing,
          function: () {
            handleFollowUser(userId, isFollowing);
            setState(() {
              isFollowing = true;
            });
          });
    }
  }

  ElevatedButton buildButton(
      {required String text,
      required bool isFollowing,
      required VoidCallback function}) {
    return ElevatedButton(
      onPressed: function,
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(
          const Size(125, 35),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
            isFollowing ? Colors.grey : Colors.blue),
        foregroundColor: MaterialStateProperty.all<Color>(
            isFollowing ? Colors.black : Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      child: Text(
        text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Column(children: [
          const TabBar(
            tabs: [
              Tab(text: "Thịnh hành"),
              Tab(text: "Tài khoản"),
              Tab(text: "Video"),
            ],
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
          ),
          Expanded(
              child: TabBarView(children: [
            SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        "Tài khoản",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  StreamBuilder<QuerySnapshot>(
                      stream: usersRef
                          .where('Name', isNotEqualTo: _name)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return Container();
                        } else {
                          List<String> listUids = [];
                          for (int i = 0; i < snapshot.data!.size; i++) {
                            var data = snapshot.data!.docs[i].data()
                                as Map<String, dynamic>;
                            String userName =
                                removeDiacritics(data['Name']).toLowerCase();
                            String id = data['UID'];
                            if (userName.contains(_query.toLowerCase())) {
                              listUids.add(id);
                            }
                          }
                          if (listUids.isEmpty) {
                            return const Text(
                              "Không có tài khoản trùng khớp!",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            );
                          }
                          return StreamBuilder(
                              stream: usersRef.doc(listUids[0]).snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator(); // Or any loading indicator
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return const Text(
                                      'No data available'); // Or handle the case when data is null
                                }
                                UserModel user =
                                    UserModel.fromDoc(snapshot.data!);
                                return FutureBuilder<bool>(
                                  future: checkFollowing(user.uid),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<bool> followingSnapshot) {
                                    if (followingSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container();
                                    } else if (followingSnapshot.hasError) {
                                      return Text(
                                          'Error: ${followingSnapshot.error}');
                                    } else {
                                      bool isFollow =
                                          followingSnapshot.data ?? false;
                                      return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              (ProfileScreen(
                                                            visitedUserID:
                                                                user.uid,
                                                            currentUserId: _uid,
                                                            isBack: true,
                                                          )),
                                                        ));
                                                  },
                                                  child: AccountDetail(
                                                      user.name,
                                                      user.bio ?? '',
                                                      user.avt ?? '')),
                                            ),
                                            buildProfileButton(
                                                isFollow, user.uid)
                                          ]);
                                    }
                                  },
                                );
                              });
                        }
                      }),
                  const SizedBox(height: 15),
                  const Text(
                    "Video",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context)
                        .size
                        .height, // Đặt chiều cao cụ thể cho GridView
                    child: StreamBuilder<QuerySnapshot>(
                      stream: videoRef.snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return Container();
                        } else {
                          List<String> listVidids = [];
                          for (int i = 0; i < snapshot.data!.size; i++) {
                            var data = snapshot.data!.docs[i].data()
                                as Map<String, dynamic>;
                            String videoTitle =
                                removeDiacritics(data['caption']).toLowerCase();
                            String id = data['videoId'];
                            if (videoTitle.contains(_query.toLowerCase())) {
                              listVidids.add(id);
                            }
                          }
                          if (listVidids.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.only(left: 20, top: 50),
                              child: Text(
                                "Không có video trùng khớp!",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return GridView.builder(
                            physics: const PageScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisExtent: 218,
                            ),
                            itemCount: listVidids.length,
                            itemBuilder: (BuildContext context, int index) {
                              return StreamBuilder(
                                stream:
                                    videoRef.doc(listVidids[index]).snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }

                                  if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return const Text('No data available');
                                  }

                                  var dataVideo = snapshot.data!.data()
                                      as Map<String, dynamic>;

                                  return StreamBuilder(
                                    stream: usersRef
                                        .doc(dataVideo['postedById'])
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            userSnapshot) {
                                      if (userSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container();
                                      } else if (!userSnapshot.hasData) {
                                        return Container();
                                      } else {
                                        UserModel userModel = UserModel.fromDoc(
                                            userSnapshot.data!);
                                        VideoModel video =
                                            VideoModel.fromDocument(
                                                snapshot.data!);
                                        List<dynamic> likesList =
                                            dataVideo['likesList'] ?? [];
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      VideoDetailScreen(
                                                          video: video),
                                                ),
                                              );
                                            },
                                            child: VideoSearch(
                                              dataVideo['caption'],
                                              likesList.length.toString(),
                                              userModel.name,
                                              '',
                                            ));
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
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
                                .where('Name', isNotEqualTo: _name)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container();
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return Container();
                              } else {
                                List<String> listUids = [];
                                for (int i = 0; i < snapshot.data!.size; i++) {
                                  var data = snapshot.data!.docs[i].data()
                                      as Map<String, dynamic>;
                                  String userName =
                                      removeDiacritics(data['Name'])
                                          .toLowerCase();
                                  String id = data['UID'];
                                  if (userName.contains(_query.toLowerCase())) {
                                    listUids.add(id);
                                  }
                                }
                                if (listUids.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.only(left: 40, top: 50),
                                    child: Text(
                                      "Không có tài khoản trùng khớp!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                }
                                return ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: listUids.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return StreamBuilder(
                                          stream: usersRef
                                              .doc(listUids[index])
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator(); // Or any loading indicator
                                            }

                                            if (!snapshot.hasData ||
                                                snapshot.data == null) {
                                              return const Text(
                                                  'No data available'); // Or handle the case when data is null
                                            }
                                            DocumentSnapshot<Object?>
                                                docSnapshot = snapshot.data!;
                                            UserModel user =
                                                UserModel.fromDoc(docSnapshot);
                                            return FutureBuilder<bool>(
                                              future: checkFollowing(user.uid),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<bool>
                                                      followingSnapshot) {
                                                if (followingSnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Container();
                                                } else if (followingSnapshot
                                                    .hasError) {
                                                  return Text(
                                                      'Error: ${followingSnapshot.error}');
                                                } else {
                                                  bool isFollow =
                                                      followingSnapshot.data ??
                                                          false;
                                                  return Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder: (context) => (ProfileScreen(
                                                                                visitedUserID: user.uid,
                                                                                currentUserId: _uid,
                                                                                isBack: true,
                                                                              )),
                                                                            ));
                                                                      },
                                                                      child: AccountDetail(
                                                                          user
                                                                              .name,
                                                                          user.bio ??
                                                                              '',
                                                                          user.avt ??
                                                                              '')),
                                                            ),
                                                            buildProfileButton(
                                                                isFollow,
                                                                user.uid)
                                                          ])
                                                    ],
                                                  );
                                                }
                                              },
                                            );
                                          });
                                    });
                              }
                            }))
                  ]),
            ),
            Container(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: StreamBuilder<QuerySnapshot>(
                  stream: videoRef.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return Container();
                    } else {
                      List<String> listVidids = [];
                      for (int i = 0; i < snapshot.data!.size; i++) {
                        var data = snapshot.data!.docs[i].data()
                            as Map<String, dynamic>;
                        String videoTilte =
                            removeDiacritics(data['caption']).toLowerCase();
                        String id = data['videoId'];
                        if (videoTilte.contains(_query.toLowerCase())) {
                          listVidids.add(id);
                        }
                      }
                      if (listVidids.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.only(left: 20, top: 50),
                          child: Text(
                            "Không có video trùng khớp!",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      return GridView.builder(
                          physics: const PageScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisExtent: 218,
                          ),
                          itemCount: listVidids.length,
                          itemBuilder: (BuildContext context, int index) {
                            return StreamBuilder(
                              stream:
                                  videoRef.doc(listVidids[index]).snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator(); // Or any loading indicator
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return const Text(
                                      'No data available'); // Or handle the case when data is null
                                }

                                var dataVideo = snapshot.data!.data()
                                    as Map<String, dynamic>;

                                return StreamBuilder(
                                    stream: usersRef
                                        .doc(dataVideo['postedById'])
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            userSnapshot) {
                                      if (userSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container();
                                      } else if (!userSnapshot.hasData) {
                                        return Container();
                                      } else {
                                        UserModel userModel = UserModel.fromDoc(
                                            userSnapshot.data!);
                                        List<dynamic> likesList =
                                            dataVideo['likesList'] ?? [];
                                        return VideoSearch(
                                            dataVideo['caption'],
                                            likesList.length.toString(),
                                            userModel.name,
                                            '');
                                      }
                                    });
                              },
                            );
                          });
                    }
                  }),
              // }
            ))
          ]))
        ]));
  }
  // Future<String> _getThumbnail(String videoUrl) async {
  //   final tempDir = await getTemporaryDirectory();
  //   final thumbnailPath = await VideoThumbnail.thumbnailFile(
  //     video: videoUrl,
  //     thumbnailPath: tempDir.path,
  //     imageFormat: ImageFormat.PNG,
  //     maxHeight: 200, // you can specify the height of the thumbnail, optional
  //     quality: 75, // quality of the thumbnail, from 0 to 100, optional
  //   );
  //
  //   return thumbnailPath!;
  // }
}
