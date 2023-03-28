import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:sema/model/post_model.dart';
import 'package:sema/providers/user_provider.dart';
import 'package:sema/theme/app_styles.dart';
import 'package:sema/utils/url.dart';

class EditPostScreen extends StatefulWidget {
  final Map<String, dynamic> post;
  const EditPostScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _linkController;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.post['title']);
    _contentController = TextEditingController(text: widget.post['content']);
    _linkController = TextEditingController(text: widget.post['link'] ?? '');
    super.initState();
  }

  Future<void> _updatePost() async {
    try {
      final token =
          Provider.of<UserProvider>(context, listen: false).user!.token;
      final response = await http.put(
        Uri.parse('${ApiUrl}api/feed/update/${widget.post['_id']}/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'title': _titleController.text,
          'content': _contentController.text,
          'link': _linkController.text.isEmpty ? null : _linkController.text,
          'is_poll': widget.post['is_poll']
        }),
      );
      if (response.statusCode == 200) {
        // Update was successful

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Updated'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } else {
        // Update failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update post'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error updating post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update post'),
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
        title: Text(
          'Edit Post',
          style: Styles.headline,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: ' Title',
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
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _contentController,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Content',
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
                    return 'Please enter some content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _linkController,
                decoration: InputDecoration(
                  labelText: 'Link',
                  filled: true,
                  labelStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              
              const SizedBox(height: 16.0),
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: Styles.blueColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: InkWell(
                    onTap: _updatePost,
                    child: Text('Update',
                        style: Styles.cardTitle.copyWith(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
