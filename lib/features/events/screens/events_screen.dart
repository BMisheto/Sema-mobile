import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sema/features/events/screens/event_details_screen.dart';
import 'dart:convert';

import 'package:sema/model/event_model.dart';
import 'package:sema/theme/app_styles.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<dynamic> events = [];
  int _page = 1;

  Future<void> _getEvents() async {
    var url = Uri.parse('http://10.0.2.2:8000/api/events/');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        events = data['events'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        shadowColor: Styles.bgColor.withOpacity(0.2),
        title: Text(
          "Events",
          style: Styles.headline,
        ),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          var event = events[index];
          return GestureDetector(
              onTap: () => Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => EventDetailScreen(event: event),
                  )),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                // decoration:  BoxDecoration(

                // ),

                child: Card(
                  shadowColor: Styles.cardColor.withOpacity(0.2),
                  color: Colors.white10,
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
