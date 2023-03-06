import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sema/providers/user_provider.dart';
import 'package:sema/theme/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final venueController = TextEditingController();
  final locationController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final descriptionController = TextEditingController();

  String? _errorMessage;
  bool _isLoading = false;
  File? _eventCover;

  Future<void> _selectImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _eventCover = File(pickedFile.path);
      }
    });
  }

  void _createEvent(BuildContext context) async {
    final name = nameController.text;
    final description = descriptionController.text;
    final startDate = startDateController.text;
    final endDate = endDateController.text;
    final location = locationController.text;
    final venue = venueController.text;

    final token = Provider.of<UserProvider>(context, listen: false).user!.token;

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:8000/api/events/create/'),
    );
    request.headers['Authorization'] = 'Bearer $token';

    if (_eventCover != null) {
      final bytes = await _eventCover!.readAsBytes();
      final file = http.MultipartFile.fromBytes(
        'event_cover',
        bytes,
        filename: 'event_cover.jpg',
      );
      request.files.add(file);
    }

    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['start_date'] = startDate;
    request.fields['end_date'] = endDate;
    request.fields['location'] = location;
    request.fields['venue'] = venue;

    final response = await request.send();

    if (response.statusCode == 201 || response.statusCode == 200) {
      // Success
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Created'),
        ),
      );
      Navigator.of(context).pop();
    } else {
      // Error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create Event'),
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
            child: _eventCover != null
                ? Image.file(_eventCover!, fit: BoxFit.cover)
                : Icon(Icons.camera_alt, size: 50, color: Colors.grey[400]),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Create event", style: Styles.headline),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageContainer(),
                Gap(20),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: ' Name',
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
                      return 'Please enter  name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: venueController,
                  decoration: InputDecoration(
                    labelText: 'Venue',
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
                      return 'Please event Vanue name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
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
                      return 'Please event Vanue name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'description',
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
                      return 'Please Description name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: startDateController,
                  decoration: InputDecoration(
                    labelText: 'Start date',
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
                      return 'Please enter start Date name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: endDateController,
                  decoration: InputDecoration(
                    labelText: 'End Date',
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
                      return 'Please enter End Date name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Styles.blueColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _createEvent(context);
                        }
                      },
                      child: Text('Create',
                          style:
                              Styles.cardTitle.copyWith(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
