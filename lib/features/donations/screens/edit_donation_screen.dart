import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:sema/model/donation_model.dart';
import 'package:sema/providers/user_provider.dart';
import 'package:sema/theme/app_styles.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
      final token = Provider.of<UserProvider>(context, listen: false).user!.token;
     
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/api/donations/update/${widget.donation['_id']}/'),
        headers: {'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'},
        body: jsonEncode({
          'name': _nameController.text,
          'description': _descriptionController.text,
          'target': _targetController.text.toString(),
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

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Donation', style: Styles.headlineStyle3,),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                onChanged: (value) => setState(() => _name = value),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
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
                ),
                onChanged: (value) =>
                    setState(() => _target = double.tryParse(value) ?? 0.0),
              ),
              SizedBox(height: 16.0),
              Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _updateDonation,
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
