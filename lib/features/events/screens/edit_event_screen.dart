import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sema/providers/user_provider.dart';
import 'package:sema/theme/app_styles.dart';
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
      final token = Provider.of<UserProvider>(context, listen: false).user!.token;
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/api/events/update/${widget.event['_id']}/'),
        headers: {'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'},
        body: jsonEncode({
          'name': nameController.text,
          'description': descriptionController.text,
          'venue': venueController.text,
          'location': venueController.text,
          'start_date': startDateController.text,
          'end_date': endDateController.text,
        }),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Event Updated'),
            backgroundColor: Colors.green,
          ),
        );
        // Update was successful
        Navigator.of(context).pop();
      } else {
        // Update failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to Event'),
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
       appBar: AppBar(
        title: Text('Edit Donation', style: Styles.headlineStyle3,),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: startDateController,
              decoration: InputDecoration(
                labelText: 'start date',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: startDateController,
              decoration: InputDecoration(
                labelText: 'end date',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: venueController,
              decoration: InputDecoration(
                labelText: 'Venue',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Location',
              ),
            ),
            Gap(25),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _updateEvent,
                  child: Text('Update', style:  Styles.headlineStyle3.copyWith(color: Colors.green, fontSize: 16),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
