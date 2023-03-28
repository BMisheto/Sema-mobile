import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:gap/gap.dart';

import 'package:sema/theme/app_styles.dart';
import 'package:sema/utils/url.dart';
import 'package:sema/widgets/comment_items.dart';
import 'package:sema/widgets/poll_items.dart';

class PostDetailScreen extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostDetailScreen({required this.post});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final commentController = TextEditingController();
  late Map<String, dynamic> postData = {};
  late List<dynamic> comments = [];
  List<dynamic> polls = [];
  bool _isPostLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPostDetail();
    _fetchComments();
    _fetchPolls();
  }

  _fetchPostDetail() async {
    setState(() {
      _isPostLoading = true;
    });
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8000/api/feed/${widget.post['_id']}/'));
      final data = json.decode(response.body);
      if (data['post'] != null) {
        setState(
          () {
            postData = Map<String, dynamic>.from(data['post']);
          },
        );
      }
    } catch (error) {
      print('Error fetching post detail: $error');
      // Handle the error as needed, such as showing an error message to the user
    } finally {
      setState(() {
        _isPostLoading = false;
      });
    }
  }

  _fetchComments() async {
    try {
      final response = await http.get(Uri.parse(
          '${ApiUrl}api/feed/comments/${widget.post['_id']}/'));
      final data = json.decode(response.body);
      setState(() {
        comments = List<dynamic>.from(data['comments']);
      });
    } catch (error) {
      print('Error fetching comments: $error');
      // Handle the error as needed, such as showing an error message to the user
    }
  }

  _fetchPolls() async {
    try {
      final response = await http.get(
          Uri.parse('${ApiUrl}api/feed/polls/${widget.post['_id']}/'));
      final data = json.decode(response.body);
      setState(() {
        polls = List<dynamic>.from(data['polls']);
      });
    } catch (error) {
      print('Error fetching polls: $error');
      // Handle the error as needed, such as showing an error message to the user
    }
  }

  Future<void> _createComment() async {
    try {
      final response = await http.post(
        Uri.parse(
            '${ApiUrl}api/feed/${widget.post['_id']}/comment/create/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'content': commentController.text,
        }),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Comment Added'),
            backgroundColor: Colors.green,
          ),
        );
        commentController.clear();
        _fetchComments();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add comment'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something Went Wrong,Try Again'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onVote(String pollId) async {
    try {
      final url =
          Uri.parse('${ApiUrl}api/feed/polls/${pollId}/vote/');
      final response = await http.put(url);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vote Submitted!'),
            backgroundColor: Colors.green,
          ),
        );
        _fetchPolls();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to vote'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(30),
              _isPostLoading
                  ? CircularProgressIndicator()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child:
                              Text(postData['title'], style: Styles.headline),
                        ),
                        Gap(20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(postData['content'],
                              style: Styles.paragraph),
                        ),
                      ],
                    ),
              Gap(20),
                postData['is_poll'] == false ? 
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: commentController,
                        decoration: InputDecoration(
                          labelText: 'Comment',
                          filled: true,
                          labelStyle: TextStyle(color: Colors.grey),
                          fillColor: Styles.cardBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a comment';
                          }
                          return null;
                        },
                      ),
                    ),
                    Gap(10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _createComment();
                          }
                        },
                        child: Text(
                          'Add Comment',
                          style: Styles.cardDescription,
                        ),
                      ),
                    ),
                  ],
                ),
               ) : SizedBox.shrink(),
              Gap(20),
              postData['has_photo']
                  ? Image.network(postData['postImage'])
                  : SizedBox.shrink(),
              Gap(30),
              postData['is_poll'] == true
                  ? Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 248, 248, 248),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, top: 8.0, bottom: 8.0),
                            child: Text("Polls", style: Styles.cardTitle),
                          ),
                          Gap(10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 16.0),
                            child: ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: polls.length,
                              separatorBuilder: (context, index) => Divider(
                                height: 0,
                                thickness: 1,
                                color: Colors.grey.withOpacity(0.3),
                                indent: 16.0,
                                endIndent: 16.0,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(polls[index]['choice_text'],
                                            style: Styles.cardTitle),
                                      ),
                                      Text(polls[index]['votes'].toString(),
                                          style: Styles.cardTitle),
                                          Gap(15),
                                      GestureDetector(
                                        onTap: () => _onVote(
                                            polls[index]['_id'].toString()),
                                        child: Row(
                                          children: [
                                           
                                            Text(
                                              'Vote',
                                              style: Styles.cardTitle.copyWith(color: Colors.grey)
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Gap(30),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
              postData['is_poll'] == false
                  ? CommentItems(comments: comments)
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
