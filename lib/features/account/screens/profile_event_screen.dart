import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sema/features/events/screens/edit_event_screen.dart';
import 'package:sema/features/events/screens/event_details_screen.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:sema/providers/user_provider.dart';
import 'package:sema/theme/app_styles.dart';

class ProfileEventScreen extends StatefulWidget {
  final String profileId;
  const ProfileEventScreen({super.key, required this.profileId});

  @override
  State<ProfileEventScreen> createState() => _ProfileEventScreenState();
}

class _ProfileEventScreenState extends State<ProfileEventScreen> {
  List<dynamic> events = [];
  int _page = 1;
  int _pages = 1;
  bool _isLoading = false;
  final searchController = TextEditingController(text: "");

  Future<void> _getEvents() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var url = Uri.parse(
        'http://10.0.2.2:8000/api/events/${userProvider.user!.id}/myevents/?keyword=${searchController.text}&page=$_page');
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${userProvider.user!.token}',
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        if (_page == 1) {
          events = data['events'];
          _pages = data['pages'];

          _isLoading = false;
        } else {
          events.addAll(data['events']);
          _pages = data['pages'];

          _isLoading = false;
        }
      });
    }
  }

  void _loadMore() {
    setState(() {
      _page++;
    });

    _getEvents();
  }

  @override
  void initState() {
    super.initState();
    _getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        shadowColor: Styles.bgColor.withOpacity(0.2),
        title: Text(
          "Events",
          style: Styles.headline,
        ),
      ),
     body: RefreshIndicator(
         onRefresh: _getEvents,
        child: Column(
          children: [
             TextField(
              controller: searchController,
              onSubmitted: (value) {
                setState(() {
                  _page = 1;
                  _getEvents();
                });
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10).copyWith(
                  left: 20,
                ),
                fillColor: Colors.white,
                filled: true,
                disabledBorder: null,
                focusedBorder: null,
                hintText: 'Search ...',
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  var event = events[index];
                  return GestureDetector(
                      onTap: () => Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => EventDetailScreen(event: event),
                          )),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Card(
                          shadowColor: Styles.cardColor.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: Image.network(
                                  'http://10.0.2.2:8000${event['event_cover']}',
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(event['name'],
                                        style: Styles.cardTitle.copyWith(
                                            color: Color.fromARGB(255, 49, 49, 49),
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(height: 8),
                                    Text(
                                        event['description'].length <= 60
                                            ? event['description']
                                            : '${event['description'].substring(0, 95)}...',
                                        style: Styles.cardDescription),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            // Navigate to the DonationDetailScreen
                                            Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    EventDetailScreen(event: event),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 5),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: CupertinoColors
                                                      .extraLightBackgroundGray),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'View',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Gap(8),
                                                Icon(
                                                  Icons.remove_red_eye,
                                                  color:
                                                      Color.fromARGB(255, 99, 99, 99),
                                                  size: 16,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            // Navigate to the EditDonationScreen
                                            Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    EditEventScreen(event: event),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Edit',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Gap(8),
                                                Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
                },
              ),
            ),
             (_page < _pages)
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: GestureDetector(
                        onTap: _loadMore,
                        child:
                            Text("Show more", style: Styles.cardDescription)),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
