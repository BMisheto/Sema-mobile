import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sema/theme/app_styles.dart';

class DonationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> donation;

  DonationDetailScreen({required this.donation});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(donation['name']),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'http://10.0.2.2:8000${donation['donation_cover']}'),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                donation['name'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                donation['description'],
                style: Styles.headlineStyle3.copyWith(color: Styles.textColor),
              ),
            ),
            SizedBox(height: 16),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16),
            //   child: Text(
            //     donation['start_date'],
            //     style: TextStyle(
            //       fontSize: 16,
            //       fontWeight: FontWeight.bold,
            //       color: CupertinoColors.systemGrey,
            //     ),
            //   ),
            // ),
            SizedBox(height: 16),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16),
            //   child: Text(
            //     donation['end_date'],
            //     style: TextStyle(
            //       fontSize: 16,
            //       fontWeight: FontWeight.bold,
            //       color: CupertinoColors.systemGrey,
            //     ),
            //   ),
            // ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
