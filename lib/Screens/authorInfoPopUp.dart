import 'package:flutter/material.dart';

class authorInfoPopUp extends StatefulWidget {
  authorInfoPopUp({required this.about});
  String about;

  @override
  State<authorInfoPopUp> createState() => _authorInfoPopUpState();
}

class _authorInfoPopUpState extends State<authorInfoPopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(200),
      child: Container(
        color: Colors.black,
        child: Center(
          child: Flex(
            direction: Axis.vertical,
            children: [
              Text("About",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 17.5,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: MediaQuery.of(context).size.height / 70),
              Text(widget.about,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      decoration: TextDecoration.none)),
            ],
          ),
        ),
      ),
    );
  }
}
