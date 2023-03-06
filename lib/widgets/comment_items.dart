import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sema/theme/app_styles.dart';
import 'package:gap/gap.dart';

class CommentItems extends StatefulWidget {
  final List<dynamic> comments;

  const CommentItems({Key? key, required this.comments}) : super(key: key);

  @override
  _CommentItemsState createState() => _CommentItemsState();
}

class _CommentItemsState extends State<CommentItems> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(10),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
            child: Text(
              "Comments",
              style: Styles.cardTitle
            ),
          ),
          Gap(10),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Styles.cardBackground
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.comments.length,
              separatorBuilder: (context, index) => Divider(
                height: 0,
                thickness: 1,
                color: Styles.cardColor,
                indent: 16.0,
                endIndent: 16.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.all(6),
                  padding:  EdgeInsets.all(7),
                  decoration:  BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text(
                    widget.comments[index]['content'],
                    style: Styles.paragraph
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
