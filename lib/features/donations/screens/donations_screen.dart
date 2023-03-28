import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sema/features/donations/screens/donation_detail.screen.dart';
import 'dart:convert';
import 'package:gap/gap.dart';

import 'package:sema/model/donation_model.dart';
import 'package:sema/theme/app_styles.dart';
import 'package:sema/utils/url.dart';

class DonationsScreen extends StatefulWidget {
  @override
  _DonationsScreenState createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen> {
  List<dynamic> donations = [];
  int _page = 1;
  int _pages = 1;
  final searchController = TextEditingController(text: "");

  Future<void> _getDonations() async {
    var url = Uri.parse(
        '${ApiUrl}api/donations?keyword=${searchController.text}&page=$_page');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _pages = data['pages'];
      setState(() {
        if (_page == 1) {
          donations = data['donations'];
          _pages = data['pages'];
        } else {
          donations.addAll(data['donations']);
          _pages = data['pages'];
        }
      });
    }
  }

  void _loadMore() {
    setState(() {
      _page++;
    });

    _getDonations();
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
      body: RefreshIndicator(
        onRefresh: _getDonations,
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onSubmitted: (value) {
                setState(() {
                  _page = 1;
                  _getDonations();
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
                itemCount: donations.length,
                itemBuilder: (context, index) {
                  var donation = donations[index];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) =>
                          DonationDetailScreen(donation: donation),
                    )),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
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
                                '$MediaUrl${donation['donation_cover']}',
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
                                          color:
                                              Color.fromARGB(255, 49, 49, 49),
                                          fontWeight: FontWeight.w500)),
                                  Gap(4),
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
            ),
            Gap(10),
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
