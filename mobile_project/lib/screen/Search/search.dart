import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_project/screen/Search/widget/account_detail.dart';
import 'package:mobile_project/screen/Search/widget/hashtag.dart';
import 'package:mobile_project/screen/Search/widget/search_history_detail.dart';
import 'package:mobile_project/screen/Search/widget/search_result.dart';
import 'package:mobile_project/screen/Search/widget/suggest_detail.dart';
import 'package:mobile_project/screen/Search/widget/video_search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'hashtagview.dart';

class SearchScreen extends StatefulWidget {
  final List<String> hashtag=['has1','has2','has3','has4'];
  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late bool _showresult;
  List<String> searchHistory = [];
  final TextEditingController _textEditingController = TextEditingController();
  String? _avt;
  String? _uid;
  String? name;
  String query='';
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    _showresult = false;
    super.initState();
    getUserData();
    loadSearchHistory();
  }

  void _searchButtonPressed() {
    final searchText = _textEditingController.text.trim();
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
      searchHistory = history;
    });
  }

  Future<void> saveSearchHistory(List<String> history) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('search_history', history);
  }

  void getUserData() async {
    User currentUser = _auth.currentUser!;
    _uid = currentUser.uid;
    final DocumentSnapshot userDoc =
    await FirebaseFirestore.instance.collection('users').doc(_uid).get();

    _avt = userDoc.get('Avt');
    name = userDoc.get("Name");
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 4,
        child: Scaffold(
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
                  _searchButtonPressed();
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
            bottom: _showresult
                ? const TabBar(
              tabs: [
                  Tab(text: "Thịnh hành"),
                  Tab(text: "Tài khoản"),
                  Tab(text: "Video"),
                  Tab(text: "Hashtag"),
              ],
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
            )
                : PreferredSize(
                preferredSize: const Size.fromHeight(0.0),
                child: Container(),
            ),
          ),
          body: _showresult
              ? SearchResult(query: query,name: name??'', currentId: _uid??'',)
              : SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchHistoryDetail(
                    searchHistory, false),
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
        ));
  }
}
