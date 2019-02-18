import 'package:events_flutter/models/category.dart';
import 'package:flutter/material.dart';
import 'package:events_flutter/utils/database_helper.dart';

class EventList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EventListState();
  }
}

class _EventListState extends State<EventList> {
  static final double _minimumMargin = 5;
  static final _boldText = TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: 19,
  );
  static final _regularText =
      TextStyle(fontWeight: FontWeight.w400, fontSize: 19);
  static final DatabaseHelper _databaseHelper = DatabaseHelper.createInstance();
  List<String> _categoryNames = List<String>();
  static var _eventList;

  var _count;

  @override
  void initState() {
    super.initState();
    _count = 0;
  }

  @override
  Widget build(BuildContext context) {
    _fillCategoryDropDownButton();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              "نشاطات المجلس",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 25,
              ),
            ),
            _getContainer(),
            _getLogo(),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          DropdownButton<String>(
            items: _categoryNames.map((item) {
              return DropdownMenuItem<String>(
                child: Text(item),
                value: item,
              );
            }).toList(),
            value: _categoryNames[0],
            onChanged: (value) {},
          ),
//          _getEventsList(),
        ],
      ),
    );
  }

  Widget _getEventsList() {
    return Container(
      margin: EdgeInsets.all(_minimumMargin * 2),
      child: ListView.builder(
        itemCount: _count,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Card(
                elevation: 5,
                child: Container(
                  child: ListTile(
                    title: Column(
                      children: <Widget>[
                        Row(
                          textDirection: TextDirection.rtl,
                          children: <Widget>[
                            //title
                            Text(
                              ":الجهة",
                              style: _boldText,
                            ),
                            _getContainer(),
//                            Text(
//                              _eventList[index].title,
//                              style: _regularText,
//                            ),
                          ],
                        ),
                        Row(
                          textDirection: TextDirection.rtl,
                          children: <Widget>[
                            //title
                            Text(
                              "الموضوع:",
                              style: _boldText,
                              textDirection: TextDirection.rtl,
                            ),
                            _getContainer(),
                            Expanded(
                              child: Text(
                                _eventList[index].subject,
                                style: _regularText,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          textDirection: TextDirection.rtl,
                          children: <Widget>[
                            //title
                            Text(
                              ":الـتـاريـخ",
                              style: _boldText,
                            ),
                            _getContainer(),
                            Text(
                              _eventList[index].date,
                              style: _regularText,
                            ),
                          ],
                        ),
                        Row(
                          textDirection: TextDirection.rtl,
                          children: <Widget>[
                            //title
                            Text(
                              ":الـــوقــت",
                              style: _boldText,
                            ),
                            _getContainer(),
                            Text(
                              _eventList[index].time,
                              style: _regularText,
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
          );
        },
      ),
    );
  }

  //this method will fill the category dropDownButton with categories
  _fillCategoryDropDownButton() async {
    //fires clear the category table
    _databaseHelper.deleteCategory();
    //fill the category table with categories
    _databaseHelper.insertCategory(Category("مكتب دائم"));
    _databaseHelper.insertCategory(Category("مكتب تنفيذي"));
    _databaseHelper.insertCategory(Category("كتل"));
    _databaseHelper.insertCategory(Category("لجان دائمة"));
    _databaseHelper.insertCategory(Category("لجان اخوة"));
    _databaseHelper.insertCategory(Category("لجان صداقة"));

    //fill the temporary category list
    var categoryList = await _databaseHelper.selectCategories();
    debugPrint(categoryList.length.toString());

    //fill the temporary list with category names
    var categoryNames = List<String>();
    for (int index = 0; index < categoryList.length; index++) {
      categoryNames.add(categoryList[index].name);
    }

    //create instance for the _categoryNames list
    setState(() {
      _categoryNames = categoryNames;
    });
  }

  //this method will return a container to make a space between widgets
  _getContainer() {
    return Container(
      width: 5,
    );
  }

  //this method will get the header logo
  _getLogo() {
    AssetImage assetImage = AssetImage("images/event_logo.png");
    Image image = Image(
      image: assetImage,
      width: 38,
      height: 38,
    );
    return image;
  }
}
