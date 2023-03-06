import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sema/providers/user_provider.dart';
import 'package:sema/theme/app_styles.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _linkController = TextEditingController();
  final _choiceControllers = <TextEditingController>[
    TextEditingController(),
    TextEditingController(),
  ];
  bool _isPoll = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _linkController.dispose();
    _choiceControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _addChoiceField() {
    setState(() {
      _choiceControllers.add(TextEditingController());
    });
  }

 Future<void> _createPost() async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final response = await http.post(
    Uri.parse('http://10.0.2.2:8000/api/feed/create/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${userProvider.user!.token}',
    },
    body: jsonEncode(<String, dynamic>{
      'user': userProvider.user!.id,
      'title': _titleController.text,
      'content': _contentController.text,
      'link': _linkController.text,
      'is_poll': _isPoll,
      'choices': _isPoll
          ? _choiceControllers.map((controller) => controller.text).toList()
          : null,
    }),
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Post Added'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Something Went Wrong Try Again'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
    // Handle the error here
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Create Post",
          style: Styles.headline
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 182, 182, 182)),
                    filled: true,
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
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 182, 182, 182)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _linkController,
                maxLines: null,
                decoration: InputDecoration(
                    labelText: 'Link',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 182, 182, 182)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Link';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Checkbox(
                    value: _isPoll,
                    onChanged: (value) {
                      setState(() {
                        _isPoll = value!;
                      });
                    },
                  ),
                  const Text('This is a poll'),
                ],
              ),
              if (_isPoll) ...[
                TextFormField(
                  controller: _choiceControllers[0],
                 decoration: InputDecoration(
                    labelText: 'Choice',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 182, 182, 182)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a choice';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _choiceControllers[1],
                  decoration: InputDecoration(
                    labelText: 'Choice',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 182, 182, 182)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a choice';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                // ElevatedButton(
                //   onPressed: () {
                //     setState(() {
                //       _choiceControllers.add(TextEditingController());
                //     });
                //   },
                //   child: const Text('Add Choice'),
                // ),
                 Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(179, 227, 227, 227),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                    setState(() {
                      _choiceControllers.add(TextEditingController());
                    });
                  },
                      child: Text('Add Choice',
                          style:
                              Styles.cardTitle.copyWith(color: Colors.grey)),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16.0),
               Container(
                            width: double.infinity,
                            height: 60,
                            decoration:  BoxDecoration(
                              color:  Styles.blueColor, 
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: InkWell(
                                onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _createPost();
                    }
                  },
                                child: Text(
                                   'Create',
                                   style: Styles.cardTitle.copyWith(color: Colors.white)
                                 
                                ),
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
