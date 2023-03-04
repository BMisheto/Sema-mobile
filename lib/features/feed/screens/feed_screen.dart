import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sema/features/feed/screens/post_detail_screen.dart';
import 'package:sema/model/post_model.dart';
import 'package:sema/theme/app_styles.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Client client = http.Client();

  List<Post> posts = [];

  @override
  void initState() {
    _fetchPosts();
    super.initState();
  }

  _fetchPosts() async {
    final response =
        await client.get(Uri.parse('http://10.0.2.2:8000/api/feed/'));
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

  Widget build(BuildContext context) {
    

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        shadowColor: Styles.bgColor.withOpacity(0.2),
        title: Text(
          "Sema",
          style: Styles.headlineStyle3.copyWith(color: Styles.textColor),
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
                                    postId: post.id.toString(), isPoll: post.is_poll))),
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
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
    );
  }
}
