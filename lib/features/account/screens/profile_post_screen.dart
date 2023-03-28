import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sema/features/feed/screens/edit_post_screen.dart';
import 'package:sema/features/feed/screens/post_detail_screen.dart';
import 'package:sema/model/post_model.dart';
import 'package:sema/providers/user_provider.dart';
import 'package:sema/theme/app_styles.dart';
import "package:http/http.dart" as http;
import "package:http/http.dart";
import 'package:sema/utils/url.dart';

class ProfilePostScreen extends StatefulWidget {
  final String profileId;
  const ProfilePostScreen({super.key, required this.profileId});

  @override
  State<ProfilePostScreen> createState() => _ProfilePostScreenState();
}

class _ProfilePostScreenState extends State<ProfilePostScreen> {
  Client client = http.Client();

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

  _fetchPosts() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await client.get(
        Uri.parse(
            '${ApiUrl}api/feed/${userProvider.user!.id}/myposts/?keyword=${searchController.text}&page=$_page'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userProvider.user!.token}',
        });
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
    });
    return data;
  }

  _deletePost(int id) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await client
        .get(Uri.parse('${ApiUrl}api/feed/delete/$id/'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${userProvider.user!.token}',
    });
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
    });
    return data;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        shadowColor: Styles.bgColor.withOpacity(0.2),
        title: Text(
          "Your posts",
          style: Styles.headline,
        ),
      ),
      body: posts == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                _fetchPosts();
              },
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
                      hintText: 'Search Posts...',
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
                              onTap: () =>
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (context) => PostDetailScreen(
                                            post: post,
                                          ))),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                title: Text(post['title'],
                                    style: Styles.cardTitle),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8.0),
                                    Text(post['content'],
                                        style: Styles.cardDescription),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            _deletePost(post['_id']);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('Delete',
                                                    style: Styles.cardTitle
                                                        .copyWith(
                                                            color:
                                                                Colors.white)),
                                                Gap(8),
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Gap(5),
                                        GestureDetector(
                                          onTap: () {
                                            // Navigate to the EditDonationScreen
                                            Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    EditPostScreen(post: post),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('Edit',
                                                    style: Styles.cardTitle
                                                        .copyWith(
                                                            color:
                                                                Colors.white)),
                                                Gap(8),
                                                Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
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
              )),
    );
  }
}
