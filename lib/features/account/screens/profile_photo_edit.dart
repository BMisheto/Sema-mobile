import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sema/providers/user_provider.dart';
import 'package:sema/theme/app_styles.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class ProfilePhotoEdit extends StatefulWidget {
  const ProfilePhotoEdit({super.key});

  @override
  State<ProfilePhotoEdit> createState() => _ProfilePhotoEditState();
}

class _ProfilePhotoEditState extends State<ProfilePhotoEdit> {
  File? _image;

  Future<void> _getImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage != null ? File(pickedImage.path) : null;
    });
  }

  Future<void> _uploadImage() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/users/profile/upload/');
    final request = http.MultipartRequest('POST', url);
    final user = Provider.of<UserProvider>(context, listen: false).user!;
    request.headers['Authorization'] = 'Bearer ${user.token}';
    request.fields['user_id'] = user.id.toString();
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image uploaded successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
      // Refresh the user's data to display the updated profile photo
      // Provider.of<UserProvider>(context, listen: false).setUser(user);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload image'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final profilePhotoUrl = userProvider.user?.profile_photo.toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: 500,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Gap(20),
                Text('Profile Photo', style: Styles.paragraph.copyWith(color: Styles.textGray),),
                Gap(20),
                _image != null
                    ? Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(_image!),
                          ),
                        ),
                      )
                    : Container(
                        child: CircleAvatar(
                          radius: 100.0,
                          backgroundImage: NetworkImage(
                            'http://10.0.2.2:8000${profilePhotoUrl}',
                          ),
                        ),
                      ),

                // Gap(20),
                // ElevatedButton(
                //   onPressed: _getImageFromGallery,
                //   child: Text('Select Photo'),
                // ),
                // Gap(10),
                // ElevatedButton(

                //   onPressed: _image != null ? _uploadImage : null,
                //   child: Text('Upload Photo'),
                // ),
                Gap(20),
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(179, 227, 227, 227),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: _getImageFromGallery,
                      child: Text('Select Photo',
                          style:
                              Styles.cardTitle.copyWith(color: Colors.grey)),
                    ),
                  ),
                ),
                Gap(10),
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Styles.blueColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: _image != null ? _uploadImage : null,
                      child: Text('Upload Photo',
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
