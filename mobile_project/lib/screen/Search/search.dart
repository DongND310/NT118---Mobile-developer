import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_project/screen/Search/widget/search_result.dart';
import 'package:mobile_project/screen/Search/widget/suggest_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  final List<String> hashtag=['has1','has2','has3','has4'];

  SearchScreen({super.key});
  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late bool _showresult;
  late List<String> searchHistory =[];
  late bool _show;
  final TextEditingController _textEditingController = TextEditingController();
  String? _uid;
  String? name;
  String query='';
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    _showresult = false;
    _show = false;
    super.initState();
    getUserData();
    loadSearchHistory();
  }

  void _searchButtonPressed(String searchText) {
    if (searchText.isNotEmpty) {
      setState(() {
        query = searchText;
        _showresult = true;
        if (!searchHistory.contains(searchText)) {
          searchHistory.add(searchText);
          saveSearchHistory(searchHistory);
        }
      });
    }
  }
  Future<void> loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history') ?? [];
    setState(() {
      searchHistory = history.reversed.toList();
    });
  }
  //
  // Future<void> saveSearchHistory(List<String> history) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setStringList('search_history', history);
  // }
  Future<void> saveSearchHistory(List<String> history) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('search_history', history); // Reverse the list before saving
    } catch (e) {
      // Handle the error appropriately
      throw Exception('Failed to save search history');
    }
  }
  Widget buildSearchHistoryDetail(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView.builder(
            physics: const PageScrollPhysics(),
            shrinkWrap: true,
            itemExtent: 35,
            itemCount: _show ? searchHistory.length : (searchHistory.length < 3 ? searchHistory.length : 3),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  _searchButtonPressed(searchHistory[index]);
                  setState(() {
                    _textEditingController.text = searchHistory[index];
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/history.svg',
                          width: 25,
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            searchHistory[index],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/cancel.svg',
                        width: 25,
                        height: 25,
                      ),
                      onPressed: () async {
                        setState(() {
                          searchHistory.removeAt(index);
                          saveSearchHistory(searchHistory);
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        _show
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                setState(() {
                  searchHistory.clear();
                });
                await saveSearchHistory(searchHistory); // Save the empty history list
              },
              child: const Text(
                "Xóa tất cả",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF107BFD),
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ): searchHistory.length <= 3?
        Container():
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _show = true;
                });
              },
              child: const Text(
                "Xem thêm",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF107BFD),
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  void getUserData() async {
    User currentUser = _auth.currentUser!;
    _uid = currentUser.uid;
    final DocumentSnapshot userDoc =
    await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    name = userDoc.get("Name");
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            'assets/icons/ep_back.svg',
            width: 30,
            height: 30,
          ),
        ),
        title: SizedBox(
          height: 35,
          child: TextField(
            controller: _textEditingController,
            cursorColor: Colors.blue,
            style: const TextStyle(fontSize: 18),
            decoration: InputDecoration(
              hintText: 'Tìm kiếm',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                ),
                child: Transform.scale(
                  scale: 0.6,
                  child: SvgPicture.asset(
                    'assets/icons/search.svg',
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide.none,
              ),
              suffixIcon: _textEditingController.text.isEmpty
                  ? null
                  : Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _showresult = false;
                      loadSearchHistory();
                      _textEditingController.clear();
                    });
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/cancel.svg',
                  ),
                ),
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _searchButtonPressed(_textEditingController.text.trim());
            },
            child: const Text(
              "Tìm kiếm",
              style: TextStyle(
                color: Color(0xFF107BFD),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: _showresult
          ? SearchResult(query: query,name: name??'', currentId: _uid??'',)
          : SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSearchHistoryDetail(context),
            //SearchHistoryDetail( false, name: name??'', uid: _uid??'',),
            const SizedBox(height: 10,),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Khám phá",
                style: TextStyle(
                  color: Color(0xFF107BFD),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SuggestDetail(widget.hashtag)
          ],
        ),
      ),
    );
  }
  // Widget bSearchHistoryDetail(BuildContext context) {
  //   return FutureBuilder<List<String>>(
  //     future: searchHistory,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const CircularProgressIndicator();
  //       } else if (snapshot.hasError) {
  //         return Text('Error: ${snapshot.error}');
  //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //         return Container();
  //       } else {
  //         List<String> searchHistory = snapshot.data!;
  //         return Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //               child: ListView.builder(
  //                 physics: const PageScrollPhysics(),
  //                 shrinkWrap: true,
  //                 itemExtent: 35,
  //                 itemCount: _show ? searchHistory.length : (searchHistory.length < 3 ? searchHistory.length : 3),
  //                 itemBuilder: (BuildContext context, int index) {
  //                   return GestureDetector(
  //                     onTap: () {
  //                       Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (context) =>
  //                                 SearchResult(query: searchHistory[index],name: widget.name??'', currentId: widget.uid??'',)
  //                         ),
  //                       );
  //                     },
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             SvgPicture.asset(
  //                               'assets/icons/history.svg',
  //                               width: 25,
  //                               height: 25,
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.only(left: 10.0),
  //                               child: Text(
  //                                 searchHistory[index],
  //                                 style: const TextStyle(
  //                                   fontSize: 18,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         IconButton(
  //                           icon: SvgPicture.asset(
  //                             'assets/icons/cancel.svg',
  //                             width: 25,
  //                             height: 25,
  //                           ),
  //                           onPressed: () async {
  //                             setState(() {
  //                               searchHistory.removeAt(index);
  //                               saveSearchHistory(searchHistory);
  //                             });
  //                           },
  //                         ),
  //                       ],
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),
  //             _show
  //                 ? Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 TextButton(
  //                   onPressed: () async {
  //                     setState(() {
  //                       searchHistory.clear();
  //                     });
  //                     await saveSearchHistory(searchHistory); // Save the empty history list
  //                   },
  //                   child: const Text(
  //                     "Xóa tất cả",
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(
  //                       color: Color(0xFF107BFD),
  //                       fontSize: 18,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ): searchHistory.length <= 3?
  //             Container():
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 TextButton(
  //                   onPressed: () {
  //                     setState(() {
  //                       _show = true;
  //                     });
  //                   },
  //                   child: const Text(
  //                     "Xem thêm",
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(
  //                       color: Color(0xFF107BFD),
  //                       fontSize: 18,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         );
  //       }
  //     },
  //   );
  // }
}
