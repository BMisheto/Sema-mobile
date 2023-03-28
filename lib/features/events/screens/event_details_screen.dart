import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gap/gap.dart';
import 'package:sema/providers/user_provider.dart';
import 'package:sema/theme/app_styles.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:sema/utils/url.dart';

class EventDetailScreen extends StatefulWidget {
    final Map<String, dynamic> event;
  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late UserProvider userProvider;



   @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
   
  }

  Future<void> _addAttendee() async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);



  
  final response = await http.post(
    Uri.parse('${ApiUrl}api/events/attending/add/${widget.event['_id']}/'),
    headers: <String, String>{
      'Content-Type': "application/json",
      'Authorization': 'Bearer ${userProvider.user!.token}',
    },
    body: jsonEncode(<String, dynamic>{
      'user': userProvider.user!.id,
      
          
    }),
  );

  
  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to list'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Something went wrong try again'),
        backgroundColor: Colors.red,
      ),
    );
    Navigator.of(context).pop();
    // Handle the error here
  }
}
  Future<void> _removeAttendee() async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final response = await http.delete(
    Uri.parse('${ApiUrl}api/events/attending/remove/${widget.event['_id']}/'),
    headers: <String, String>{
      'Content-Type': "application/json",
      'Authorization': 'Bearer ${userProvider.user!.token}',
    },
    body: jsonEncode(<String, dynamic>{
      'user': userProvider.user!.id,
      
          
    }),
  );

  
  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed from list'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Something went wrong try again'),
        backgroundColor: Colors.red,
      ),
    );
    Navigator.of(context).pop();
    // Handle the error here
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Event Details", style: Styles.paragraph,)
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      '${MediaUrl}${widget.event['event_cover']}',
                    ),
                  ),
                ),
              ),
              Gap(10),
              Gap(10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(5),
                    Text(
                      widget.event['name'],
                      style: Styles.bigHeadline,
                    ),
                    Gap(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Date',
                              style: Styles.cardTitle,
                            ),
                            Gap(5),
                            Text(
                              widget.event['start_date'],
                              style: Styles.paragraph,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'End date',
                              style: Styles.cardTitle,
                            ),
                            Gap(5),
                            Text(
                              widget.event['end_date'],
                              style: Styles.paragraph,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location',
                              style: Styles.cardTitle,
                            ),
                            Gap(5),
                            Text(
                              widget.event['location'],
                              style: Styles.paragraph,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Venue',
                              style: Styles.cardTitle,
                            ),
                            Gap(5),
                            Text(
                              widget.event['venue'],
                              style: Styles.paragraph,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Gap(20),
                  
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Attending',
                              style: Styles.cardTitle,
                            ),
                            Gap(5),
                            Text(
                              widget.event['attendees'].toString(),
                              style: Styles.paragraph,
                            ),
                          ],
                        ),
                       
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.event['description'],
                  style: Styles.paragraph.copyWith(color: Colors.grey.shade800),
                ),
              ),
              SizedBox(height: 16),

              userProvider.user?.id  == 0 ? SizedBox.shrink() :
               Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                     color: Colors.green,
                     borderRadius:  BorderRadius.circular(10)
                  ),
                  width: double.infinity,
                 
                  child: Center(
                    child: GestureDetector(
                      onTap: _addAttendee,
                      child: Text('Add me to list', style: Styles.paragraph.copyWith(color: Colors.white)),
                    ),
                  )
                ,
                ),
              ),
              Gap(10),
               userProvider.user?.id  == 0 ? SizedBox.shrink() :
               Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                     color: Colors.grey.shade600,
                     borderRadius:  BorderRadius.circular(10)
                  ),
                  width: double.infinity,
                 
                  child: Center(
                    child: GestureDetector(
                      onTap: _removeAttendee,
                      child: Text('Remove me from list', style: Styles.paragraph.copyWith(color: Colors.white)),
                    ),
                  )
                ,
                ),
              ),Gap(20)
            
            ],
          ),
        ),
      ),
    );
  }
}