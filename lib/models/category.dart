class Category {
  int id;
  String name;

  Category(this.name);

  //return map obj to be able to save the category obj in the db
  toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    return map;
  }

  //create the category instance form the map obj when fetched from db
  Category.fromMap(map) {
    id = map['id'];
    name = map['name'];
  }
}
