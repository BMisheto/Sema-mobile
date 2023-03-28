import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sema/model/donation_model.dart';
import 'package:sema/providers/user_provider.dart';
import 'package:sema/theme/app_styles.dart';
import 'package:sema/utils/url.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class DonationEditScreen extends StatefulWidget {
  final Map<String, dynamic> donation;
  const DonationEditScreen({Key? key, required this.donation})
      : super(key: key);

  @override
  _DonationEditScreenState createState() => _DonationEditScreenState();
}

class _DonationEditScreenState extends State<DonationEditScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetController = TextEditingController();

  late String _name;
  late String _description;
  late double _target;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.donation['name'];
    _descriptionController.text = widget.donation['description'];
    _targetController.text = widget.donation['target'];
    _name = widget.donation['name'];
    _description = widget.donation['description'];
  }

  Future<void> _updateDonation() async {
    try {
      final token =
          Provider.of<UserProvider>(context, listen: false).user!.token;
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse(
            '${ApiUrl}api/donations/update/${widget.donation['_id']}/'),
      );
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });
      request.fields['name'] = _nameController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['target'] = _targetController.text;
      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'donation_cover',
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
          'Edit Donation',
          style: Styles.headline,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                  child:
                   _imageFile != null
                      ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Image.file(
                            _imageFile!,
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                      )
                      : 
                      SizedBox(
                          child: Image.network(
                            '${MediaUrl}${widget.donation['donation_cover']}',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              Gap(20),
              TextField(
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
                onChanged: (value) => setState(() => _name = value),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _descriptionController,
                maxLines: 20,
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
                onChanged: (value) => setState(() => _description = value),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _targetController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Target Amount',
                  prefixText: '\$',
                  filled: true,
                  labelStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) =>
                    setState(() => _target = double.tryParse(value) ?? 0.0),
              ),
              SizedBox(height: 16.0),
              Container(
                            width: double.infinity,
                            height: 60,
                            decoration:  BoxDecoration(
                              color:  Styles.blueColor, 
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: InkWell(
                                onTap: _updateDonation,
                                child: Text(
                                   'Update',
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
