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
  double _cardOpacity = 0.0;
  final Duration _animationDuration = const Duration(milliseconds: 500);

  Future<void> _getDonations() async {
    var url = Uri.parse('http://10.0.2.2:8000/api/donations/');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        donations = data['donations'];
        _cardOpacity = 1.0;
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        shadowColor: Styles.bgColor.withOpacity(0.2),
        title: Text(
          "Donations",
          style: Styles.headline,
        ),
      ),
      body: ListView.builder(
        itemCount: donations.length,
        itemBuilder: (context, index) {
          var donation = donations[index];
          return GestureDetector(
            onTap: () => Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => DonationDetailScreen(donation: donation),
            )),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                          Text(donation['name'],
                              style: Styles.cardTitle.copyWith(
                                  color: Color.fromARGB(255, 49, 49, 49),
                                  fontWeight: FontWeight.w500)),
                          SizedBox(height: 8),
                          Text(
                              donation['description'].length <= 60
                                  ? donation['description']
                                  : '${donation['description'].substring(0, 95)}...',
                              style: Styles.cardDescription),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
