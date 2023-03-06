import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sema/features/feed/screens/post_detail_screen.dart';
import 'package:sema/theme/app_styles.dart';
import 'package:http/http.dart' as http;

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final http.Client client = http.Client();

  List<Map<String, dynamic>> posts = [];

 @override
  void initState() {
    _fetchPosts();
    super.initState();
  }

Future<void> _fetchPosts() async {
    final response =
        await client.get(Uri.parse('http://10.0.2.2:8000/api/feed/'));
    final data = json.decode(response.body);

    setState(() {
      posts = List<Map<String, dynamic>>.from(data['posts']);
      // You can store other fetched data in state variables too
    });
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
      body:posts == null || posts.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _fetchPosts,
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
                            postId: post['_id'].toString(),
                            
                          ),
                        ),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        title: Text(
                          post['title'],
                          style:Styles.cardTitle
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(10),
                            Text(
                              post['content'],
                               style:Styles.cardDescription
                            ),
                         
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
