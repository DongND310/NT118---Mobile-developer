import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_project/constants.dart';
import 'package:mobile_project/screen/Follow/search_bar.dart';
import 'package:mobile_project/services/database_services.dart';

import '../../models/user_model.dart';
import '../Search/widget/account_detail.dart';

class ListFollowerScreen extends StatefulWidget {
  ListFollowerScreen({super.key, required this.currentUserId});
  final String currentUserId;

  @override
  State<StatefulWidget> createState() => _ListFollowerState();
}

class _ListFollowerState extends State<ListFollowerScreen> {
  bool _isPressed = false;
  List<String> _search = [];
  final TextEditingController _textEditingController = TextEditingController();
  final DatabaseServices _databaseServices = DatabaseServices();
  String? _avt;
  String? _uid;
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    User currentUser = _auth.currentUser!;
    _uid = currentUser.uid;
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();

    _avt = userDoc.get('Avt');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
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
            title: const Text("Username",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blue)),
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(text: "Follower 500K"),
                Tab(text: "Following 100K"),
                Tab(text: "Bạn bè 11K"),
              ],
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      // SearchFollowerBar((value) {
                      //   setState(() {
                      //     _search = widget.account
                      //         .where((element) => element
                      //             .toLowerCase()
                      //             .contains(_textEditingController.text
                      //                 .toLowerCase()))
                      //         .toList();
                      //   });
                      // }, _textEditingController),
                      // ListView.builder(
                      //   physics:
                      //       const NeverScrollableScrollPhysics(),
                      //   shrinkWrap: true,
                      //   itemExtent: 100,
                      //   itemCount: _textEditingController.text.isNotEmpty
                      //       ? _search.length
                      //       : widget.account.length,
                      //   itemBuilder: (BuildContext context, int index) {
                      //     return Row(
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       children: [
                      //         Expanded(
                      //           child: AccountDetail(
                      //               _textEditingController.text.isNotEmpty
                      //                   ? _search[index]
                      //                   : widget.account[index],
                      //               "",
                      //               _avt ?? ''),
                      //         ),
                      //         ElevatedButton(
                      //           onPressed: () {
                      //             setState(() {
                      //               _isPressed = !_isPressed;
                      //             });
                      //           },
                      //           style: ButtonStyle(
                      //             minimumSize: MaterialStateProperty.all<Size>(
                      //               const Size(125, 35),
                      //             ),
                      //             backgroundColor: MaterialStateProperty.all<
                      //                     Color>(
                      //                 _isPressed ? Colors.grey : Colors.blue),
                      //             foregroundColor: MaterialStateProperty.all<
                      //                     Color>(
                      //                 _isPressed ? Colors.black : Colors.white),
                      //             shape: MaterialStateProperty.all<
                      //                 RoundedRectangleBorder>(
                      //               RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(5),
                      //               ),
                      //             ),
                      //           ),
                      //           child: const Text('Follow'),
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // ),
                      StreamBuilder<QuerySnapshot>(
                          stream: _databaseServices.listFollower(_uid!),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot doc = snapshot.data!.docs[index];
                                return FutureBuilder(future: usersRef.doc(doc.id).get(),
                                    builder: (BuildContext context, AsyncSnapshot snapshot)
                                    {
                                      if (!snapshot.hasData) {
                                        return Container();
                                      }
                                      UserModel userModel = UserModel.fromDoc(snapshot.data);
                                      return Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: AccountDetail(
                                                        _textEditingController.text.isNotEmpty
                                                            ? _search[index]
                                                            : userModel.name,
                                                        userModel.bio??'',
                                                        userModel.avt ?? ''),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _isPressed = !_isPressed;
                                                      });
                                                    },
                                                    style: ButtonStyle(
                                                      minimumSize: MaterialStateProperty.all<Size>(
                                                        const Size(125, 35),
                                                      ),
                                                      backgroundColor: MaterialStateProperty.all<
                                                              Color>(
                                                          _isPressed ? Colors.grey : Colors.blue),
                                                      foregroundColor: MaterialStateProperty.all<
                                                              Color>(
                                                          _isPressed ? Colors.black : Colors.white),
                                                      shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5),
                                                        ),
                                                      ),
                                                    ),
                                                    child: const Text('Follow'),
                                                  ),
                                                ],
                                              );
                                    }
                                );
                              },
                            );
                          }
                      )
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      // SearchFollowerBar((value) {
                      //   setState(() {
                      //     _search = widget.account
                      //         .where((element) => element
                      //             .toLowerCase()
                      //             .contains(_textEditingController.text
                      //                 .toLowerCase()))
                      //         .toList();
                      //   });
                      // }, _textEditingController),
                      // ListView.builder(
                      //   physics:
                      //       const NeverScrollableScrollPhysics(), // Đặt physics này để ListView không cuộn
                      //   shrinkWrap: true,
                      //   itemExtent: 100,
                      //   itemCount: _textEditingController.text.isNotEmpty
                      //       ? _search.length
                      //       : widget.account.length,
                      //   itemBuilder: (BuildContext context, int index) {
                      //     return Row(
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       children: [
                      //         Expanded(
                      //           child: AccountDetail(
                      //               _textEditingController.text.isNotEmpty
                      //                   ? _search[index]
                      //                   : widget.account[index],
                      //               "",
                      //               _avt ?? ''),
                      //         ),
                      //         ElevatedButton(
                      //           onPressed: () {
                      //             setState(() {
                      //               _isPressed = !_isPressed;
                      //             });
                      //           },
                      //           style: ButtonStyle(
                      //             minimumSize: MaterialStateProperty.all<Size>(
                      //               const Size(125, 35),
                      //             ),
                      //             backgroundColor: MaterialStateProperty.all<
                      //                     Color>(
                      //                 _isPressed ? Colors.grey : Colors.blue),
                      //             foregroundColor: MaterialStateProperty.all<
                      //                     Color>(
                      //                 _isPressed ? Colors.black : Colors.white),
                      //             shape: MaterialStateProperty.all<
                      //                 RoundedRectangleBorder>(
                      //               RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(5),
                      //               ),
                      //             ),
                      //           ),
                      //           child: const Text('Follow'),
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      // SearchFollowerBar((value) {
                      //   setState(() {
                      //     _search = widget.account
                      //         .where((element) => element
                      //             .toLowerCase()
                      //             .contains(_textEditingController.text
                      //                 .toLowerCase()))
                      //         .toList();
                      //   });
                      // }, _textEditingController),
                      // ListView.builder(
                      //   physics:
                      //       const NeverScrollableScrollPhysics(), // Đặt physics này để ListView không cuộn
                      //   shrinkWrap: true,
                      //   itemExtent: 100,
                      //   itemCount: _textEditingController.text.isNotEmpty
                      //       ? _search.length
                      //       : widget.account.length,
                      //   itemBuilder: (BuildContext context, int index) {
                      //     return Row(
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       children: [
                      //         Expanded(
                      //           child: AccountDetail(
                      //               _textEditingController.text.isNotEmpty
                      //                   ? _search[index]
                      //                   : widget.account[index],
                      //               "",
                      //               _avt ?? ''),
                      //         ),
                      //         ElevatedButton(
                      //           onPressed: () {
                      //             setState(() {
                      //               _isPressed = !_isPressed;
                      //             });
                      //           },
                      //           style: ButtonStyle(
                      //             minimumSize: MaterialStateProperty.all<Size>(
                      //               const Size(125, 35),
                      //             ),
                      //             backgroundColor: MaterialStateProperty.all<
                      //                     Color>(
                      //                 _isPressed ? Colors.grey : Colors.blue),
                      //             foregroundColor: MaterialStateProperty.all<
                      //                     Color>(
                      //                 _isPressed ? Colors.black : Colors.white),
                      //             shape: MaterialStateProperty.all<
                      //                 RoundedRectangleBorder>(
                      //               RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(5),
                      //               ),
                      //             ),
                      //           ),
                      //           child: const Text('Bạn bè'),
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
