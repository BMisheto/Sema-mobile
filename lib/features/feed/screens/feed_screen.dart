import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sema/features/feed/screens/post_detail_screen.dart';
import 'package:sema/theme/app_styles.dart';
import 'package:http/http.dart' as http;
import 'package:sema/utils/url.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final http.Client client = http.Client();

  List<Map<String, dynamic>> posts = [];
  int _page = 1;
  int _pages = 1;
  final searchController = TextEditingController(text: "");
  bool _isLoading = false;

  @override
  void initState() {
    _fetchPosts();

    super.initState();
  }

  Future<void> _fetchPosts() async {
    _isLoading = true;
    final response = await client.get(Uri.parse(
        '${ApiUrl}api/feed?keyword=${searchController.text}&page=$_page'));
    final data = json.decode(response.body);

    setState(() {
      if (_page == 1) {
        posts = List<Map<String, dynamic>>.from(data['posts']);
        _pages = data['pages'];

        _isLoading = false;
      } else {
        posts.addAll(List<Map<String, dynamic>>.from(data['posts']));

        _isLoading = false;
        _pages = data['pages'];
      }

      // You can store other fetched data in state variables too
    });
  }

  void _loadMore() {
    setState(() {
      _page++;
    });

    _fetchPosts();
  }

  @override
  void dispose() {
    client.close();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        shadowColor: Styles.bgColor.withOpacity(0.2),
        title: Text(
          "Sema",
          style: Styles.headline,
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _fetchPosts,
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    onSubmitted: (value) {
                      setState(() {
                        _page = 1;
                        _fetchPosts();
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10).copyWith(
                        left: 20,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Search ...',
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final post = posts[index];

                        return Card(
                          shadowColor: Styles.cardColor.withOpacity(0.4),
                          child: InkWell(
                            onTap: () => Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => PostDetailScreen(
                                  post: post,
                                ),
                              ),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              title:
                                  Text(post['title'], style: Styles.cardTitle),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Gap(10),
                                  Text(post['content'],
                                      style: Styles.cardDescription),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  (_page < _pages)
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: GestureDetector(
                              onTap: _loadMore,
                              child: Text("Show more",
                                  style: Styles.cardDescription)),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
    );
  }
}
