import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sema/features/donations/screens/donation_detail.screen.dart';
import 'dart:convert';

import 'package:sema/model/donation_model.dart';
import 'package:sema/theme/app_styles.dart';

class DonationsScreen extends StatefulWidget {
  @override
  _DonationsScreenState createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen> {
  List<dynamic> donations = [];
  int _page = 1;

  Future<void> _getDonations() async {
    var url = Uri.parse('http://10.0.2.2:8000/api/donations/');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        donations = data['donations'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getDonations();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Donations'),
      ),
      child: ListView.builder(
        itemCount: donations.length,
        itemBuilder: (context, index) {
          var donation = donations[index];
          return GestureDetector(
              onTap: () => Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) =>
                        DonationDetailScreen(donation: donation),
                  )),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Card(
                  shadowColor: Styles.cardColor.withOpacity(0.5),
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
                          'http://10.0.2.2:8000${donation['donation_cover']}',
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
                            Text(
                              donation['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // SizedBox(height: 8),
                            // Text(
                            //   donation['description'],
                            //   style: TextStyle(fontSize: 16),
                            // ),
                            SizedBox(height: 8),
                            Text(
                              'Target: ${donation['target']}',
                              style: TextStyle(fontSize: 16),
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
    );
  }
}
