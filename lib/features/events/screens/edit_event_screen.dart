import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sema/providers/user_provider.dart';
import 'package:sema/theme/app_styles.dart';
import 'package:sema/utils/url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import "package:gap/gap.dart";
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sema/model/event_model.dart';

class EditEventScreen extends StatefulWidget {
  final Map<String, dynamic> event;
  const EditEventScreen({super.key, required this.event});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final venueController = TextEditingController();
  final locationController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final descriptionController = TextEditingController();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.event['name'];
    descriptionController.text = widget.event['description'];
    venueController.text = widget.event['venue'];
    locationController.text = widget.event['location'];
    startDateController.text = widget.event['start_date'];
    endDateController.text = widget.event['end_date'];
  }

  Future<void> _updateEvent() async {
    try {
      final token =
          Provider.of<UserProvider>(context, listen: false).user!.token;
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse(
            '${ApiUrl}api/events/update/${widget.event['_id']}/'),
      );
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });
      request.fields['name'] = nameController.text;

      request.fields['description'] = descriptionController.text;
      request.fields['start_date'] = startDateController.text;
      request.fields['end_date'] = endDateController.text;
      request.fields['venue'] = venueController.text;
      request.fields['location'] = locationController.text;

      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'event_cover',
          _imageFile!.path,
        ));
      }
      final response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
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
            content: Text('Failed to update'),
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

  void _selectImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Edit Event',
          style: Styles.headline,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(20),
            InkWell(
              onTap: _selectImage,
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: _imageFile != null
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Image.file(
                          _imageFile!,
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      )
                    : SizedBox(
                        child: Image.network(
                          '${MediaUrl}${widget.event['event_cover']}',
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            Gap(20),
            TextField(
              controller: nameController,
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
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
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
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: startDateController,
              decoration: InputDecoration(
                labelText: 'start date',
                filled: true,
                labelStyle: TextStyle(color: Colors.grey),
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: startDateController,
              decoration: InputDecoration(
                labelText: 'end date',
                filled: true,
                labelStyle: TextStyle(color: Colors.grey),
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
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
            ),
            SizedBox(height: 16.0),
            TextField(
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
            ),
            Gap(25),
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Styles.blueColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: InkWell(
                  onTap: _updateEvent,
                  child: Text('Update',
                      style: Styles.cardTitle.copyWith(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
