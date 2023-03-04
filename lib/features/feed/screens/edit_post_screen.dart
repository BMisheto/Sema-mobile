import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:sema/model/post_model.dart';
import 'package:sema/providers/user_provider.dart';
import 'package:sema/theme/app_styles.dart';

class EditPostScreen extends StatefulWidget {
  final Post post;
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
    _titleController = TextEditingController(text: widget.post.title);
    _contentController = TextEditingController(text: widget.post.content);
    _linkController = TextEditingController(text: widget.post.link ?? '');
    super.initState();
  }

  Future<void> _updatePost() async {
    try {
      final token = Provider.of<UserProvider>(context, listen: false).user!.token;
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/api/feed/update/${widget.post.id}/'),
          headers: {'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'},
        body: jsonEncode({
          'title': _titleController.text,
          'content': _contentController.text,
          'link': _linkController.text.isEmpty ? null : _linkController.text,
          'is_poll': widget.post.is_poll
        }),
      );
      if (response.statusCode == 200) {
        // Update was successful
         
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Updated'),
            backgroundColor: Colors.green,
          ),);
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
       appBar: AppBar(
        title: Text('Edit Post', style: Styles.headlineStyle3,),
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
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
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
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
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
                decoration: const InputDecoration(
                  labelText: 'Link (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
             Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _updatePost,
                  child: Text('Update', style:  Styles.headlineStyle3.copyWith(color: Colors.green, fontSize: 16),),
                ),
              ],
            ),
            ],
          ),
        ),
      ),
    );
  }
}
