class Entity {
  int id;
  String name;
  int rank;
  int category;

  Entity(this.name, this.rank, this.category);

  //return map obj to be able to save the entity obj in the db
  toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['rank'] = rank;
    map['category'] = category;
    return map;
  }

  //create the entity instance form the map obj when fetched from db
  Entity.fromMap(map) {
    id = map['id'];
    name = map['name'];
    rank = map['rank'];
    category = map['category'];
  }
}
