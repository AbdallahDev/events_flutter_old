import 'package:flutter/material.dart';

class EventsApiLocalDb extends StatefulWidget {
  @override
  _EventsApiLocalDbState createState() => _EventsApiLocalDbState();
}

class _EventsApiLocalDbState extends State<EventsApiLocalDb> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("API Events"),
      ),
      body: Container(
        child: DropdownButton(
          items: <DropdownMenuItem>[],
          onChanged: (value) {},
        ),
      ),
    );
  }
}
