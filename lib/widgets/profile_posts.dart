import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:sema/features/feed/screens/post_detail_screen.dart';
import 'package:sema/model/post_model.dart';
import 'package:sema/providers/user_provider.dart';
import 'package:sema/theme/app_styles.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'package:sema/features/account/screens/profile_post_screen.dart';
import 'package:sema/features/feed/screens/edit_post_screen.dart';

class ProfilePosts extends StatelessWidget {
  final List<dynamic> posts;
  final String profileId;

  const ProfilePosts({Key? key, required this.posts, required this.profileId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
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
                Text('Your Posts', style: Styles.cardTitle),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => ProfilePostScreen(
                        profileId: profileId,
                      ),
                    ),
                  ),
                  child: Text('View All', style: Styles.cardDescription),
                )
              ],
            ),
          ),
          Gap(20),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Container(
                  width: 300,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    // padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          post['title'],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                        post['content'].length <= 50
                              ? post['content']
                              : '${post['content'].substring(0, 100)}...',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
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
                                    builder: (context) => PostDetailScreen(
                                         post: post),
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
                                    Text('View', style: Styles.cardDescription),
                                    Gap(8),
                                    Icon(
                                      Icons.remove_red_eye,
                                      color: Color.fromARGB(255, 99, 99, 99),
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
                                        EditPostScreen(post: post),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Edit',
                                        style: Styles.cardTitle
                                            .copyWith(color: Colors.white)),
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
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
