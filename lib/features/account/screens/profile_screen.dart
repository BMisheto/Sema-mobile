import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sema/features/account/screens/profile_edit_screen.dart';
import 'package:sema/features/donations/screens/create_donation.screen.dart';
import 'package:sema/features/events/screens/create_event_screen.dart';
import 'package:sema/features/feed/screens/create_post_screen.dart';
import 'package:sema/model/post_model.dart';
import 'package:sema/model/user_model.dart';
import 'package:sema/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../theme/app_layout.dart';
import '../../../theme/app_styles.dart';
import '../../../widgets/profile_donation.dart';
import '../../../widgets/profile_events.dart';
import '../../../widgets/profile_posts.dart';
import 'package:gap/gap.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> profile = {};
  late UserProvider userProvider;
  File? _image;
  List<Post> posts = [];
  List<dynamic> events = [];
  List<dynamic> donations = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _fetchProfileDetail();
    _fetchMyPosts();
    _fetchMyEvents();
    _fetchMyDonations();
  }

  _fetchProfileDetail() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      isLoading = true;
    });

    final response = await http
        .get(Uri.parse('http://10.0.2.2:8000/api/users/profile/'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${userProvider.user!.token}',
    });
    final data = json.decode(response.body);
    if (data != null) {
      setState(() {
        profile = Map<String, dynamic>.from(data);
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  _fetchMyPosts() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final profileId = userProvider.user?.id;

    final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/feed/${profileId}/myposts/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userProvider.user!.token}',
        });
    final data = json.decode(response.body);

    setState(() {
      posts = List<Post>.from(data['posts'].map((post) => Post.fromMap(post)));
      final pages = data['pages'];
      final page = data['page'];
      final postCount = data['post_count'];
      // Other data can be accessed in a similar
      // manner
    });
  }

  Future<void> _fetchMyEvents() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final profileId = userProvider.user?.id;
    var url = Uri.parse(
      'http://10.0.2.2:8000/api/events/${profileId}/myevents/',
    );
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${userProvider.user!.token}',
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        events = data['events'];
      });
    }
  }

  Future<void> _fetchMyDonations() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final profileId = userProvider.user?.id;

    var url = Uri.parse(
      'http://10.0.2.2:8000/api/donations/${profileId}/mydonations/',
    );
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${userProvider.user!.token}',
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        donations = data['donations'];
      });
    }
  }

  Future<void> _selectImage() async {
    if (userProvider == null) {
      return;
    }

    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Upload the selected image to the API endpoint
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/users/profile/upload/'),
        headers: {
          HttpHeaders.contentTypeHeader: 'multipart/form-data',
        },
        body: {
          'image': http.MultipartFile.fromBytes(
            'image',
            await _image!.readAsBytes(),
          ),
        },
      );

      if (response.statusCode == 200) {
        userProvider.updateUser(User(
          first_name: userProvider.user!.first_name,
          last_name: userProvider.user!.last_name,
          mobile: userProvider.user!.mobile,
          country: userProvider.user!.country,
          token: userProvider.user!.token,
          email: userProvider.user!.email,
          password: userProvider.user!.password,
          id: userProvider.user!.id,
          is_active: userProvider.user!.is_active,
          is_staff: userProvider.user!.is_staff,
          isAdmin: userProvider.user!.isAdmin,
          profile_photo: userProvider.user!.profile_photo,
        ));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile Photo Updated'),
          ),
        );

        _fetchProfileDetail();
        // Image uploaded successfully
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something Went Wrong! Try again'),
          ),
        );
        // Handle error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(
            child: Text(
          "Profile",
          style: Styles.headlineStyle3.copyWith(color: Colors.black),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.event),
                      title: Text('Events'),
                      onTap: () =>
                          Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => CreateEventScreen(),
                      )),
                    ),
                    ListTile(
                      leading: Icon(Icons.post_add),
                      title: Text('Posts'),
                      onTap: () =>
                          Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => CreatePostScreen(),
                      )),
                    ),
                    ListTile(
                      leading: Icon(Icons.monetization_on),
                      title: Text('Donation'),
                      onTap: () =>
                          Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => CreateDonationScreen(),
                      )),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : ListView(
                children: [
                  Gap(5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child:Text('Logout', style: Styles.headlineStyle4.copyWith(color: Colors.red))
                        ),
                        GestureDetector(
                          onTap: () {},
                          child:Text('Edit', style: Styles.headlineStyle4.copyWith(color: Colors.green))
                        )
                  
                  
                      ]
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 251, 251, 251),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            if (_image != null)
                              CircleAvatar(
                                radius: 100.0,
                                backgroundImage: FileImage(File(_image!.path)),
                              )
                            else
                              CircleAvatar(
                                radius: 100.0,
                                backgroundImage: NetworkImage(
                                  'http://10.0.2.2:8000${profile['profile_photo']}',
                                ),
                              ),
                            IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.green,
                              ),
                              onPressed: _selectImage,
                            ),
                          ],
                        ),
                        Gap(30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              profile['first_name'],
                              style: Styles.headlineStyle3.copyWith(
                                  color: Color.fromARGB(255, 34, 34, 34),
                                  fontWeight: FontWeight.w400),
                            ),
                            Gap(5),
                            Text(
                              profile['last_name'],
                              style: Styles.headlineStyle3.copyWith(
                                  color: Color.fromARGB(255, 34, 34, 34),
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Gap(5),
                        Text(
                          profile['country'],
                          style: Styles.headlineStyle4.copyWith(
                              color: Color.fromARGB(255, 34, 34, 34),
                              fontWeight: FontWeight.w400),
                        ),
                        Gap(5),
                       
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Gap(10),
                        ProfilePosts(
                          posts: posts,
                          profileId: profile['id'].toString(),
                        ),
                        Gap(5),
                        MyEvents(
                          events: events,
                          profileId: profile['id'].toString(),
                        ),
                        Gap(5),
                        ProfileDonation(
                          donations: donations,
                          profileId: profile['id'].toString(),
                        ),
                        Gap(5),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
