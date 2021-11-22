import 'package:flutter/material.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {


  final String title;

  Header(this.title) : preferredSize = Size.fromHeight(60.0);

  @override
  final Size preferredSize;

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header>{

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title, style: TextStyle(color: Colors.white, fontFamily: "Nunito", fontSize: 20),),
      centerTitle: true,
      backgroundColor: Colors.deepPurpleAccent,
    );
  }
}
