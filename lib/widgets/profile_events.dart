import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gap/gap.dart';
import 'package:sema/features/account/screens/profile_event_screen.dart';
import 'package:sema/features/events/screens/edit_event_screen.dart';
import 'package:sema/features/events/screens/event_details_screen.dart';
import 'package:sema/model/event_model.dart';
import 'package:sema/theme/app_styles.dart';

class MyEvents extends StatefulWidget {
  final List<dynamic> events;
  final String profileId;
  const MyEvents({super.key, required this.events, required this.profileId});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Your Events',
                  style: Styles.cardTitle
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) =>  ProfileEventScreen(profileId:  widget.profileId),
                  )),
                  child: Text(
                    'View All',
                    style: Styles.cardDescription)
                )
              ],
            ),
          ),
          Gap(20),
          SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20),
              itemCount: widget.events.length,
              itemBuilder: (context, index) {
                final event = widget.events[index];
                return Container(
                  width: 340,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            'http://10.0.2.2:8000${event?['event_cover']}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: 330,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event['name'],
                                style: Styles.cardTitle
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Navigate to the DonationDetailScreen
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              EventDetailScreen(
                                                  event: event),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'Edit',
                                            style: Styles.cardDescription.copyWith(color:  Colors.white)
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
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );}
}
