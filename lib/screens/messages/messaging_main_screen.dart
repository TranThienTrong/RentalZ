import 'package:flutter/material.dart';
import 'package:rental_apartments_finder/screens/messages/recent_conversations_screen.dart';

import 'contact_screen.dart';

class MessagingMainScreen extends StatefulWidget {
  const MessagingMainScreen({Key? key}) : super(key: key);

  @override
  _MessagingMainScreenState createState() => _MessagingMainScreenState();
}

class _MessagingMainScreenState extends State<MessagingMainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  /* Responsive Design */
  double deviceWidth = 0;
  double deviceHeight = 0;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[
              Colors.deepPurple.withOpacity(0.75),
              Colors.blue.withOpacity(0.75)
            ],
          ),
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.white, //change your color here
      ),
      title: Text(
        'Message',
        style:
            TextStyle(color: Colors.white, fontFamily: "Nunito", fontSize: 20),
      ),
      centerTitle: true,
      bottom: TabBar(
        controller: _tabController,
        unselectedLabelColor: Colors.white,
        indicatorColor: Colors.orange,
        labelColor: Colors.orange,
        indicatorWeight: 3.0,
        tabs: [
          Tab(
            icon: Icon(
              Icons.people_outlined,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.chat_bubble_outlined,
            ),
          ),
        ],
      ),
    );

    deviceHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        appBar.preferredSize.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: appBar,
      body: SizedBox(
        height: deviceHeight,
        width: deviceWidth,
        child: TabBarView(
          controller: _tabController,
          children: [
            ContactScreen(deviceHeight),
            RecentMessageScreen(),
          ],
        ),
      ),
    );
  }
}
