import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryDetail extends StatefulWidget {
  final List<String> searchhistory;
  final bool showmore;

  const SearchHistoryDetail(this.searchhistory, this.showmore, {super.key});

  @override
  State<StatefulWidget> createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistoryDetail> {
  late bool _show;
  late Future<List<String>> searchHistory;

  @override
  void initState() {
    _show = widget.showmore;
    searchHistory = loadSearchHistory();
    super.initState();
  }

  Future<List<String>> loadSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList('search_history') ?? [];
      return history.reversed.toList(); // Reverse the list to show the latest first
    } catch (e) {
      // Handle the error appropriately
      throw Exception('Failed to load search history');
    }
  }

  Future<void> saveSearchHistory(List<String> history) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('search_history', history.reversed.toList()); // Reverse the list before saving
    } catch (e) {
      // Handle the error appropriately
      throw Exception('Failed to save search history');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: searchHistory,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container();
        } else {
          List<String> searchHistory = snapshot.data!;
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
                    return Row(
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
      },
    );
  }
}
