import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gap/gap.dart';

import 'package:sema/theme/app_styles.dart';
import 'package:sema/widgets/comment_items.dart';
import 'package:sema/widgets/poll_items.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;
  final bool isPoll;

  const PostDetailScreen({required this.postId, required this.isPoll});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final commentController = TextEditingController();
  Map<String, dynamic> postData = {};
  List<dynamic> comments = [];
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
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8000/api/feed/${widget.postId}/'));
    final data = json.decode(response.body);
    if (data['post'] != null) {
      setState(() {
        postData = Map<String, dynamic>.from(data['post']);

        // Add the null check here
        if (postData['is_poll'] != null && postData['is_poll']) {
          postData['is_poll'] = true;
        }
      });
    }
  }

  _fetchComments() async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/feed/comments/${widget.postId}/'));
    final data = json.decode(response.body);
    setState(() {
      comments = List<dynamic>.from(data['comments']);
    });
  }

  _fetchPolls() async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/feed/polls/${widget.postId}/'));
    final data = json.decode(response.body);
    setState(() {
      polls = List<dynamic>.from(data['polls']);
      _isPostLoading = false;
    });
  }

  Future<void> _createComment() async {
    try {
 
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/api/feed/${widget.postId}/comment/create/'),
        headers: {'Content-Type': 'application/json',
       },
        body: jsonEncode({
          'comment': commentController.text,
          
        }),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Comment Added'),
            backgroundColor: Colors.green,
          ),
        );
        _fetchPostDetail();
        _fetchComments();
        _fetchPolls();
        // Update was successful
        Navigator.of(context).pop();
      } else {
        // Update failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to'),
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


 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(30),
              _isPostLoading
                  ? CircularProgressIndicator()
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            postData['title'],
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Gap(20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            postData['content'],
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(20),
              Padding(
                
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment:  MainAxisAlignment.start,
                  crossAxisAlignment:  CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                  controller: commentController,
                  decoration: InputDecoration(
                    labelText: 'Comment',
                    filled: true,
                    labelStyle: TextStyle(color: Colors.grey),
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter  Comment';
                    }
                    return null;
                  },
                ),
                Gap(10),
                 GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _createComment();
                    }
                  },
                  child: Text('Comment', style: Styles.headlineStyle4.copyWith(color: Colors.black, fontWeight:  FontWeight.normal),),
                ),
              
              
              
                  ],
                ),
              ),
              Gap(20),
              postData['has_photo']
                  ? Image.network(postData['postImage'])
                  : SizedBox.shrink(),
              Gap(30),
              widget.isPoll == true
                  ? PollItems(
                      polls: polls,
                    )
                  : SizedBox.shrink(),
              widget.isPoll == false
                  ? CommentItems(comments: comments)
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
