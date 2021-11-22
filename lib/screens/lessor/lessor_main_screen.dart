import 'package:flutter/material.dart';
import 'package:rental_apartments_finder/screens/lessor/upload_property_screen.dart';

import 'lessor_homepage_screen.dart';

class LessorMainScreen extends StatefulWidget {
  LessorMainScreen({Key? key}) : super(key: key);

  @override
  _LessorMainScreenState createState() => _LessorMainScreenState();
}

class _LessorMainScreenState extends State<LessorMainScreen> {
  late PageController pageController;
  static int pageIndex = 0;
  //final _lessorFormScaffoldKey = GlobalKey<ScaffoldState>(debugLabel: "hello");

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  void changePage(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: PageView(
        scrollDirection: Axis.horizontal,
        controller: pageController,
        children: <Widget>[
          LessorHomepageScreen(),
          UploadPropertyScreen(),
        ],
        onPageChanged: (index) {
          setState(() => pageIndex = index);
        },
      ),
    );
  }
}
