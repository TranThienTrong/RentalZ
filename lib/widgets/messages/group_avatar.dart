import 'package:flutter/material.dart';

class GroupAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 60.0,
      child: new Stack(
        children: <Widget>[
          new Positioned(
              top:0,
              left: 0,
              child: new Icon(Icons.monetization_on, size: 30.0, color: const Color.fromRGBO(218, 165, 32, 1.0))),
          new Positioned(
            top: 0.0,
            left: 27,
            child: new Icon(Icons.monetization_on,
                size: 30.0, color: const Color.fromRGBO(218, 165, 32, 1.0)),
          ),
          new Positioned(
            top: 27,
            left: 0.0,
            child: new Icon(Icons.monetization_on,
                size: 30.0, color: const Color.fromRGBO(218, 165, 32, 1.0)),
          ),
          new Positioned(
            top: 27,
            left: 27,
            child: new Icon(Icons.monetization_on,
                size: 30.0, color: const Color.fromRGBO(218, 165, 32, 1.0)),
          ),

        ],
      ),
    );
  }
}
