import 'package:events_flutter/models/category.dart';
import 'package:events_flutter/models/entity.dart';
import 'package:events_flutter/models/event.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper databaseHelper = DatabaseHelper.createInstance();
  static Database _database;

  //category table and its rows names
  String _categoryTable = "category";
  String _categoryIdCol = "id";
  String _categoryNameCol = "name";

  //entity table and its rows names
  String _entityTable = "entity";
  String _entityIdCol = "id";
  String _entityNameCol = "name";
  String _entityRankCol = "rank";
  String _entityCategoryIdCol = "category_id";

  //event table and its rows names
  String _eventTable = "event";
  String _eventIdCol = "id";
  String _eventSubjectCol = "subject";
  String _eventDateCol = "date";
  String _eventTimeCol = "time";

  //event_entity table and its rows names
  String _eventEntityTable = "event_entity";
  String _eventEntityEventIdCol = "event_id";
  String _eventEntityEntityIdCol = "entity_id";

  DatabaseHelper.createInstance();

  get database async {
    if (_database == null) _database = await initializeDb();
    return _database;
  }

  //this method to initialize the db
  Future<Database> initializeDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    var path = directory.path + "notes.db";
    Database database =
        await openDatabase(path, version: 1, onCreate: (db, version) {
      //this method to create the category table
      db.execute(
          "create table $_categoryTable($_categoryIdCol integer primary key autoincrement, "
          "$_categoryNameCol text)");

      //this method to create the entity table
      db.execute(
          "create table $_entityTable($_entityIdCol integer primary key autoincrement, "
          "$_entityNameCol text, $_entityRankCol integer, "
          "$_entityCategoryIdCol integer)");

      //this method to create the event_entity table
      db.execute(
          "create table $_eventEntityTable($_eventEntityEventIdCol integer, "
          "$_eventEntityEntityIdCol integer)");

      //this method to create the event table
      db.execute(
          "create table $_eventTable($_eventIdCol integer primary key autoincrement, "
          "$_eventSubjectCol text, $_eventDateCol text, $_eventTimeCol text)");
    });
    return database;
  }

  //CRUD operation methods
  //category table
  //insert
  Future<int> insertCategory(category) async {
    Database database = await this.database;
    var result = await database.insert(_categoryTable, category.toMap());
    return result;
  }

  //select
  selectCategories() async {
    Database database = await this.database;
    var mapList =
        await database.query(_categoryTable, orderBy: "$_categoryIdCol asc");
    var list = List<Category>();
    for (int index = 0; index < mapList.length; index++)
      list.add(Category.fromMap(mapList[index]));
    return list;
  }

  //delete
  Future<int> deleteCategory() async {
    Database database = await this.database;
    var result = await database.delete(_categoryTable);
    return result;
  }

  //entity table
  //insert
  insertEntity(entity) async {
    Database database = await this.database;
    database.insert(_entityTable, entity.toMap());
  }

  //select event method
  selectEntity() async {
    Database database = await this.database;
    var mapList =
        await database.query(_eventTable, orderBy: "$_entityRankCol asc");
    var list = List<Entity>();
    for (int index = 0; index < mapList.length; index++)
      list.add(Entity.fromMap(mapList[index]));
    return list;
  }
}
