import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sema/providers/user_provider.dart';
import 'package:sema/theme/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class CreateDonationScreen extends StatefulWidget {
  const CreateDonationScreen({super.key});

  @override
  State<CreateDonationScreen> createState() => _CreateDonationScreenState();
}

class _CreateDonationScreenState extends State<CreateDonationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetController = TextEditingController();
  File? _donationCover;

  Future<void> _selectImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _donationCover = File(pickedFile.path);
      }
    });
  }

  void _createDonation(BuildContext context) async {
    final name = _nameController.text;
    final description = _descriptionController.text;
    final target = double.parse(_targetController.text);

    final token = Provider.of<UserProvider>(context, listen: false).user!.token;

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:8000/api/donations/create/'),
    );
    request.headers['Authorization'] = 'Bearer $token';

    if (_donationCover != null) {
      final bytes = await _donationCover!.readAsBytes();
      final file = http.MultipartFile.fromBytes(
        'donation_cover',
        bytes,
        filename: 'donation_cover.jpg',
      );
      request.files.add(file);
    }

    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['target'] = target.toString();

    final response = await request.send();

    if (response.statusCode == 201) {
      // Success
      final responseJson = await response.stream.bytesToString();
      final donationId = json.decode(responseJson)['id'];
      final uploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:8000/api/donations/$donationId/upload/'),
      );
      uploadRequest.headers['Authorization'] = 'Bearer $token';
      if (_donationCover != null) {
        final bytes = await _donationCover!.readAsBytes();
        final file = http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: 'image.jpg',
        );
        uploadRequest.files.add(file);
      }
      await uploadRequest.send();
      Navigator.of(context).pop();
    } else {
      // Error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create donation'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildImageContainer() {
      return SizedBox(
        
        width: MediaQuery.of(context).size.width,
        child: InkWell(
          onTap: _selectImage,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[200],
            ),
            child: _donationCover != null
                ? Image.file(_donationCover!, fit: BoxFit.cover)
                : Icon(Icons.camera_alt, size: 50, color: Colors.grey[400]),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Create donation",
          style: Styles.headlineStyle3
              .copyWith(color: Color.fromARGB(255, 124, 124, 124)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildImageContainer(),
                Gap(20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    filled: true,
                    labelStyle: TextStyle(color: Colors.grey),
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                Gap(20),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    filled: true,
                    labelStyle: TextStyle(color: Colors.grey),
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                Gap(20),
                TextFormField(
                  controller: _targetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Target',
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
                    if (value == null) {
                      return 'Please enter a target';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                Gap(20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _createDonation(context);
                    }
                  },
                  child: Text('Create'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
