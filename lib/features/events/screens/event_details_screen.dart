import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sema/model/event_model.dart';
import 'package:sema/theme/app_styles.dart';
import 'package:sema/widgets/poll_items.dart';
import 'package:gap/gap.dart';

class EventDetailScreen extends StatelessWidget {
  final Map<String, dynamic> event;

  const EventDetailScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
                      'http://10.0.2.2:8000${event['event_cover']}',
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
                      event['name'],
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
                              event['start_date'],
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
                              event['end_date'],
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
                              event['location'],
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
                              event['venue'],
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
                  event['description'],
                  style: Styles.paragraph,
                ),
              ),
              SizedBox(height: 16),
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
                      onTap: (){},
                      child: Text('Attend', style: Styles.paragraph.copyWith(color: Colors.white)),
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
