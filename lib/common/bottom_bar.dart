import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sema/features/account/screens/profile_screen.dart';
import 'package:sema/features/donations/screens/donations_screen.dart';
import 'package:sema/features/events/screens/events_screen.dart';
import 'package:sema/features/feed/screens/feed_screen.dart';
import 'package:sema/theme/app_styles.dart';

import 'package:provider/provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:sema/providers/user_provider.dart';
import 'package:sema/features/donations/screens/create_donation.screen.dart';
import 'package:sema/features/events/screens/create_event_screen.dart';
import 'package:sema/features/feed/screens/create_post_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  late UserProvider userProvider;
  bool isGuest = false;
  static final List<Widget> _widgetOptions = <Widget>[
    FeedScreen(),
    EventsScreen(),
    DonationsScreen(),
    ProfileScreen(),
  ];
   

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _isGuest() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user!.id == 0) {
      setState(() {
        isGuest = true;
      });
    } else {
      setState(() {
        isGuest = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);

    _isGuest();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,


      floatingActionButton: isGuest ? SizedBox.shrink()  : FloatingActionButton(
        backgroundColor: Styles.blueColor,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.event),
                      title: Text('Events'),
                      onTap: () =>
                          Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => CreateEventScreen(),
                      )),
                    ),
                    ListTile(
                      leading: Icon(Icons.post_add),
                      title: Text('Posts'),
                      onTap: () =>
                          Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => CreatePostScreen(),
                      )),
                    ),
                    ListTile(
                      leading: Icon(Icons.monetization_on),
                      title: Text('Donation'),
                      onTap: () =>
                          Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => CreateDonationScreen(),
                      )),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 10,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Styles.blueColor,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Styles.textGray,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
              label: "Feed"),
          BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_calendar_regular),
              activeIcon:
                  Icon(FluentSystemIcons.ic_fluent_calendar_filled),
              label: "Events"),
          BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on_outlined),
              activeIcon: Icon(Icons.monetization_on),
              label: "Donations"),
          BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_person_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_person_filled),
              label: "Profile"),
        ],
      ),
    );
  }
}
