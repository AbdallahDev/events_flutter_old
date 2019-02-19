class Entity {
  int id;
  String name;
  int category;
  int rank;

  Entity(this.name, this.category, this.rank);

  //return map obj to be able to save the entity obj in the db
  toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['category'] = category;
    map['rank'] = rank;
    return map;
  }

  //create the entity instance form the map obj when fetched from db
  Entity.fromMap(map) {
    id = map['id'];
    name = map['name'];
    category = map['category'];
    rank = map['rank'];
  }
}
