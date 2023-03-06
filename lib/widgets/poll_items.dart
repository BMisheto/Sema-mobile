import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gap/gap.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:sema/theme/app_styles.dart';

class PollItems extends StatefulWidget {
  final List<dynamic> polls;
  const PollItems({Key? key, required this.polls}) : super(key: key);

  @override
  State<PollItems> createState() => _PollItemsState();
}

class _PollItemsState extends State<PollItems> {
  List<String> _pollItems = [];
  int _pollItemsCount = 0;
  bool _isLoading = true;
  

  @override
  void initState() {
    super.initState();
  }

  void _onVote(String pollId) async {
    // TODO: Add code to handle voting on the poll item at the given index.
   
    final url = Uri.parse('http://10.0.2.2:8000/api/feed/polls/${pollId}/vote/');
    final response = await http.put(url);
    // handle response
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 248, 248, 248),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
            child: Text(
              "Polls",
              style: Styles.cardTitle
            ),
          ),
          Gap(10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.polls.length,
              separatorBuilder: (context, index) => Divider(
                height: 0,
                thickness: 1,
                color: Colors.grey.withOpacity(0.3),
                indent: 16.0,
                endIndent: 16.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          widget.polls[index]['choice_text'],
                          style: Styles.cardTitle
                        ),
                      ),
                      Text(
                        widget.polls[index]['votes'].toString(),
                        style: Styles.cardTitle
                      ),
                      IconButton(
                        onPressed: () => _onVote(widget.polls[index]['_id'].toString()),
                        icon: Icon(Icons.check_box),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Gap(30),
          
        ],
      ),
    );
  }
}
