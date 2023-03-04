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

class ProfilePostScreen extends StatefulWidget {
  final String profileId;
  const ProfilePostScreen({super.key, required this.profileId});

  @override
  State<ProfilePostScreen> createState() => _ProfilePostScreenState();
}

class _ProfilePostScreenState extends State<ProfilePostScreen> {
  Client client = http.Client();

  List<Post> posts = [];

  @override
  void initState() {
    _fetchPosts();
    super.initState();
  }

  _fetchPosts() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await client.get(
        Uri.parse(
            'http://10.0.2.2:8000/api/feed/${userProvider.user!.id}/myposts/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userProvider.user!.token}',
        });
    final data = json.decode(response.body);

    setState(() {
      posts = List<Post>.from(data['posts'].map((post) => Post.fromMap(post)));
      final pages = data['pages'];
      final page = data['page'];
      final postCount = data['post_count'];
      // Other data can be accessed in a similar manner
    });
    return data;
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
          style: Styles.headlineStyle3
              .copyWith(color: Color.fromARGB(255, 131, 131, 131)),
        ),
        // actions: [
        //   IconButton(onPressed: onPressed, icon: icon)
        // ],
      ),
      body: posts == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                _fetchPosts();
              },
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
                                    postId: post.id.toString(),
                                    isPoll: post.is_poll))),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          title: Text(
                            post.title,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8.0),
                              Text(
                                post.content,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  color: Color.fromARGB(137, 11, 11, 11),
                                ),
                              ),
                              if (post.link != null) SizedBox(height: 8.0),

                              Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // GestureDetector(
                            //   onTap: () {
                            //     // Navigate to the DonationDetailScreen
                            //     Navigator.push(
                            //       context,
                            //       CupertinoPageRoute(
                            //         builder: (context) => PostDetailScreen(
                            //             postId: post.id.toString(),
                            //             isPoll: post.is_poll),
                            //       ),
                            //     );
                            //   },
                            //   child: Container(
                            //     padding: EdgeInsets.symmetric(
                            //         horizontal: 15, vertical: 5),
                            //     decoration: BoxDecoration(
                            //       border: Border.all(
                            //           width: 1,
                            //           color: CupertinoColors
                            //               .extraLightBackgroundGray),
                            //       borderRadius: BorderRadius.circular(20),
                            //     ),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.end,
                            //       children: [
                            //         Text(
                            //           'View',
                            //           style: TextStyle(
                            //             fontSize: 15,
                            //             color: Colors.grey,
                            //           ),
                            //         ),
                            //         Gap(8),
                            //         Icon(
                            //           Icons.remove_red_eye,
                            //           color: Color.fromARGB(255, 99, 99, 99),
                            //           size: 16,
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
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
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Edit',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
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
                  })),
    );
  }
}
