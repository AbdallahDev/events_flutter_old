class Event {
  int id;
  String subject;
  String date;
  String time;

  //this constructor to create the event obj
  Event(this.subject, this.date, this.time);

  //this method to convert the event obj to map obj to save it in the db
  toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['subject'] = subject;
    map['date'] = date;
    map['time'] = time;
    return map;
  }

  //this named constructor to create the event obj and initialize it
  //from the map obj
  Event.fromMap(map) {
    id = map['id'];
    subject = map['subject'];
    date = map['date'];
    time = map['time'];
  }
}
