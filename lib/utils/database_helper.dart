import 'dart:async';

import 'package:events_flutter/models/category.dart';
import 'package:events_flutter/models/entity.dart';
import 'package:events_flutter/models/event.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper databaseHelper = DatabaseHelper.createInstance();
  static Database _database;

  //categories table and its rows names
  String _categoryTable = "categories";
  String _categoryIdCol = "id";
  String _categoryNameCol = "name";

  //entities table and its rows names
  String _entityTable = "entities";
  String _entityIdCol = "id";
  String _entityNameCol = "name";
  String _entityRankCol = "rank";
  String _entityCategoryIdCol = "category_id";

  //events table and its rows names
  String _eventTable = "events";
  String _eventIdCol = "id";
  String _eventSubjectCol = "subject";
  String _eventDateCol = "date";
  String _eventTimeCol = "time";

  //events_entities table and its rows names
  String _eventsEntitiesTable = "events_entities";
  String _eventsEntitiesEventIdCol = "event_id";
  String _eventsEntitiesEntityIdCol = "entity_id";

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
      //category table code
      //this method to create the category table
      db.execute(
          "create table $_categoryTable($_categoryIdCol integer primary key autoincrement, "
          "$_categoryNameCol text)");
      //bellow i'll insert values in the category table
      db.execute("insert into $_categoryTable ($_categoryNameCol) values "
          "('مكتب دائم'), "
          "('مكتب تنفيذي'), "
          " ('كتل'), "
          "('لجان دائمة'), "
          "('لجان اخوة'), "
          "('لجان صداقة')");

      //entity table code
      //this method to create the entity table
      db.execute(
          "create table $_entityTable($_entityIdCol integer primary key autoincrement, "
          "$_entityNameCol text, $_entityCategoryIdCol integer, $_entityRankCol integer)");
      //bellow i'll insert values in the entity table
      db.execute(
          "insert into $_entityTable ($_entityNameCol, $_entityCategoryIdCol, $_entityRankCol) "
          "values "
          "('المكتب الدائم',1, 1),"
          "('المكتب التنفيذي',2, 1),"
          "('كتلة مبادرة النيابية',3, 1),"
          "('كتلة وطن النيابية',3, 2),"
          "('كتلة الشعب النيابية',3, 3),"
          "('اللجنة القانونية', 4, 1),"
          "('اللجنة المالية',4, 2),"
          "('لجنة الاقتصاد والاستثمار',4, 3),"
          "('لجنة الاخوة الاردنية الاماراتية',5, 1),"
          "('لجنة الاخوة البرلمانية الاردنية اللبنانية',5, 2),"
          "('لجنة الاخوة الاردنية القطرية', 5, 3)");

      //events table
      //this method to create the events table
      db.execute(
          "create table $_eventTable($_eventIdCol integer primary key autoincrement, "
          "$_eventSubjectCol text, $_eventDateCol text, $_eventTimeCol text)");
      //bellow i'll insert values in the events table
      db.execute(
          "insert into $_eventTable ($_eventSubjectCol, $_eventDateCol, $_eventTimeCol) "
          "values "
          //entity id 1
          "('يجتمع المكتب الدائم لمجلس النواب يوم الأربعاء 2017/8/9 الساعة 1:00 بعد الظهر.', '2017/8/9', '1:00 م'),"
          "('يجتمع المكتب الدائم لمجلس النواب يوم الاربعاء 2017/4/12 الساعة 12:00 ظهراً.', '2017/4/12', '12:00 م'),"
          "('يجتمع المكتب الدائم لمجلس النواب يوم الاثنين 6 /3 /2017 الساعة 11:00 صباحاً.', '6 /3 /2017', '11:00 م'),"
          //entity id 2
          "('قرر سعادة المهندس عاطف الطراونة رئيس مجلس النواب دعوة المكتب التنفيذي للاجتماع يوم الاربعاء 17/2/2016 الساعة 12:30 ظهرا في قاعة المكتب الدائم.', '17/2/2016', '12:30 م'),"
          //entity id 3
          "('اجتماع كتلة مبادرة النيابية لبحث امور تهم الكتلة.', 'الأربعاء, فبراير 6, 2019', '12:00 م'),"
          "('زيارة كتلة مبادرة النيابية لديوان الخدمة المدنية.', 'الثلاثاء, يناير 15, 2019', '11:00 ص'),"
          //entity id 4
          "('زيارة كتلة وطن النيابية الى مديرية الامن العام .', 'الثلاثاء, يناير 29, 2019', '10:30 ص'),"
          "('زيارة كتلة وطن النيابية الى قناة المملكة للاطلاع على الخطط المستقبلية للقناة .', 'الأربعاء, يناير 23, 2019', '11:30 ص'),"
          //entity id 5
          "('اجتماع كتلة الشعب النيابية لبحث موضوع الكتل البرلمانية مع مركز الدراسات والبحوث التشريعية.', 'الثلاثاء, يناير 15, 2019', '11:00 ص'),"
          "('اجتماع كتلة الشعب مع معالي وزير العدل ومعالي وزير الداخلية وعطوفة مدير الأمن العام ، للحديث عن موضوع التوقيف الإداري.', 'الاثنين, يناير 14, 2019', '11:00 ص'),"
          //entity id 6
          "('تجتمع اللجنة القانونية يوم الاثنين 8/10/2018 الساعة 11:00 صباحا، وذلك لمناقشة مشروع قانون معدل لقانون الجرائم الالكترونية لسنة 2018.', 'الثلاثاء, أكتوبر 9, 2018', '11:00 ص'),"
          "('اجتماع اللجنة القانونية لمناقشة واقرار مشروع قانون الملكية العقارية لسنة 2017 بالصيغة النهائية.', 'الثلاثاء, فبراير 5, 2019', '11:00 ص'),"
          "('اجتماع اللجنة القانونية لمناقشة مشروع قانون العفو العام لسنة 2018.', 'الأحد, يناير 6, 2019', '11:00 ص'),"
          //entity id 7
          "('تجتمع اللجنة المالية يوم الاربعاء 28/12/2016 لمناقشة مشروعي قانوني الموازنة العامة وموازنات الوحدات الحكومية للسنة المالية 2017 كالتالي:"
          "1.الساعة 11:0 وزارة الصناعة والتجارة والتموين والدوائر التابعة لها."
          "2.الساعة 1:00 هيئة الأوراق المالية، بورصة عمان، مركز ايداع الأوراق المالية.', 'الأربعاء, ديسمبر 28, 2016', '11:00 ص'),"
          "('تجتمع اللجنة المالية يوم الاحد 28/2/2016 الساعة 11:00 صباحا لمناقشة تقارير ديوان المحاسبة للاعوام 2009 - 2012.', 'الأحد, فبراير 28, 2016', '11:00 ص'),"
          "('تجتمع اللجنة المالية يوم الخميس 2018/3/15 الساعة 11:00 صباحاً لمناقشة تقرير ديوان المحاسبة 2016 والاجراءات المتخذة في التقارير السابقة المحالة، بحضور رئيس ديوان المحاسبة ورئيس هيئة النزاهة ومكافحة الفساد.', 'الخميس, مارس 15, 2018', '11:00 ص'),"
          //entity id 8
          "('تجتمع لجنة الاقتصاد والاستثمار يوم الاثنين 9-5-2016 الساعة 1:00 ظهراً لبحث الوضع الاقتصادي بشكل عام وأوضاع الشركات المتعثرة بشكل خاص.', 'الاثنين, مايو 9, 2016', '01:00 م'),"
          "('تجتمع لجنة الاقتصاد والاستثمار يوم الاثنين 16 /1 /2017 الساعة 1:00 بعد الظهر لمناقشة القانون المؤقت رقم (76) لسنة 2002 قانون الاوراق المالية.', 'الاثنين, يناير 16, 2017', '01:00 م'),"
          "('تجتمع لجنة الاقتصاد والاستثمار يوم الاربعاء 19/7/2017 الساعة 2:00 بعد الظهر لمناقشة مشروع القانون المعدل لقانون الشركات لسنة 2017.', 'الأربعاء, يوليو 19, 2017', '02:00 م'),"
          //entity id 9
          "('لجنة الاخوة الاردنية الاماراتية تلتقي بالسفير الاماراتي', 'الاثنين, فبراير 11, 2018', '05:00 م'),"
          "('لجنة الاخوة الاردنية الاماراتية تلتقي برئيس مجلس الاتحاد الاماراتي', 'الاثنين, يناير 16, 2017', '04:00 م'),"
          //entity id 10
          "('لجنة الاخوة البرلمانية الاردنية اللبنانية تلتقي بوفد نيابي من لبنان', 'الاحد, مارس 10, 2015', '04:00 م'),"
          "('لجنة الاخوة البرلمانية الاردنية اللبنانية تلتقي برئيس مجلس النواب اللبناني', 'الاربعاء, يناير 17, 2016', '07:00 م'),"
          //entity id 11
          "('لجنة الاخوة الاردنية القطرية تلتقي بوفد برلماني من دولة قطر الشقيقة', 'الخميس, مايو 22, 2018', '08:00 م'),"
          "('لجنة الاخوة الاردنية القطرية تلتقي برئيس مجلس النواب القطري', 'الاحد, مايو 11, 2018', '03:00 م')"
          "");

      //events entities table
      //this method to create the events entities table
      db.execute("create table $_eventsEntitiesTable("
          "$_eventsEntitiesEventIdCol integer, "
          "$_eventsEntitiesEntityIdCol integer)");
      //bellow i'll insert values in the events entities table
      db.execute("insert into $_eventsEntitiesTable ("
          "$_eventsEntitiesEventIdCol, "
          "$_eventsEntitiesEntityIdCol) "
          "values "
          "(1, 1),"
          "(2, 1),"
          "(3, 1),"
          "(4, 2),"
          "(5, 3),"
          "(6, 3),"
          "(7, 4),"
          "(8, 4),"
          "(9, 5),"
          "(10, 5),"
          "(11, 6),"
          "(12, 6),"
          "(13, 6),"
          "(14, 7),"
          "(15, 7),"
          "(16, 7),"
          "(17, 8),"
          "(18, 8),"
          "(19, 8),"
          "(20, 9),"
          "(21, 9),"
          "(22, 10),"
          "(23, 10),"
          "(24, 11),"
          "(25, 11)"
          "");
    });
    return database;
  }

  //category table
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

  //entity table
  //select method, this method takes two parameters, one is the categoryId to get
  // the entities belong to the selected category, and the other one is the
  // actionIndex that by it
  // i'll decide to make the logic to return the entities as a list for the
  // entities dropDownButton, or as a map list for the select events method.
  selectEntities(int categoryId, int actionIndex) async {
    Database database = await this.database;
    var mapList = await database.rawQuery(
        "SELECT * FROM $_entityTable where $_entityCategoryIdCol = $categoryId "
        "order by $_entityRankCol asc");
    //here i'll check for the actionIndex if it's equal 1, because that means that
    // this method has been called from the select events method, and i should
    // return a map list of entity ids.
    if (actionIndex == 1) {
      mapList = await database.rawQuery(
          "SELECT $_entityIdCol FROM $_entityTable where $_entityCategoryIdCol = $categoryId ");
      return mapList;
    }
    var list = List<Entity>();
    for (int index = 0; index < mapList.length; index++)
      list.add(Entity.fromMap(mapList[index]));
    return list;
  }

  //event table
  //select event method, in this method i'll return all events that belong to
  // a whole category based on the provide categoryId.
  //i defined the entityId parameter coz i'll need to return the events for
  // a specific entity, and the eventsReturnType parameter to decide based on it
  // if i should return the event list for the a specific category or all
  // the events or for a
  // specific entity
  selectEvents(int categoryId, int entityId, int eventsReturnType) async {
    String sql =
        "select $_eventTable.$_eventIdCol, $_eventTable.$_eventSubjectCol, "
        "$_eventTable.$_eventDateCol, $_eventTable.$_eventTimeCol, "
        "$_entityTable.$_entityNameCol "
        "from $_eventTable "
        "INNER JOIN $_eventsEntitiesTable on "
        "$_eventTable.$_eventIdCol = $_eventsEntitiesTable.$_eventsEntitiesEventIdCol "
        "INNER JOIN $_entityTable on "
        "$_entityTable.$_entityIdCol = $_eventsEntitiesTable.$_eventsEntitiesEntityIdCol "
        "";
    //here if the values of the eventsReturnType var is 0 that means i should
    //return the event list for a specific category or for all the events
    if (eventsReturnType == 0) {
      //bellow i'll check if the user choose one of the categories, and didn't
      // select the first choice "جميع الفئات" in the categories dropDownButton,
      // by checking the category id if it's not equal to zero.
      if (categoryId != 0) {
        //this list contains a map objects of entity ids
        List<Map<String, dynamic>> entityIds =
            await selectEntities(categoryId, 1);
        //i'll loop over the entity ids to form the sql statement, where i'll insert
        // the where conditions based on the number of entity ids
        for (int i = 0; i < entityIds.length; i++) {
          if (i == 0)
            sql = sql +
                " where $_entityTable.$_entityIdCol =  ${entityIds[i].values}";
          sql =
              sql + " or $_entityTable.$_entityIdCol =  ${entityIds[i].values}";
        }
      }
    }
    //here if the values of the eventsReturnType var is 1 that means i should
    //return the event list for a specific entity
    else if (eventsReturnType == 1) {
      sql = sql + " where $_entityTable.$_entityIdCol = $entityId ";
    }
    Database database = await this.database;
    var mapList = await database.rawQuery(sql);
    var list = List<Event>();
    for (int index = 0; index < mapList.length; index++)
      list.add(Event.fromMap(mapList[index]));
    return list;
  }
}
