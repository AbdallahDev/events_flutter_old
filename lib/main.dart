import 'package:events_flutter/screens/events_apil_local_db.dart';
import 'package:flutter/material.dart';
import 'package:events_flutter/screens/event_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "JHR Events",
      home: EventsApiLocalDb(),
    );
  }
}
