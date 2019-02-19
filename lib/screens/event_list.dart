import 'package:events_flutter/models/entity.dart';
import 'package:events_flutter/models/event.dart';
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
  static final _regularText =
      TextStyle(fontWeight: FontWeight.w400, fontSize: 19);
  static final DatabaseHelper _databaseHelper = DatabaseHelper.createInstance();
  List<String> _categoryNames;
  var _selectedCategory;
  List<String> _entityNames;
  var _selectedEntity;
  var _dropDownButtonContainerMargin = EdgeInsets.only(
    left: _minimumMargin * 7,
    top: _minimumMargin * 2,
    right: _minimumMargin * 7,
    bottom: _minimumMargin * 1,
  );
  var _containerMargin = EdgeInsets.only(top: _minimumMargin * 2);
  static final _boldText = TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: 19,
  );
  List<Event> _eventList;
  var _listCount;

  @override
  void initState() {
    super.initState();
    //i've initialized this var so the app first launch won't give error
    _categoryNames = ["جميع الفئات"];
    _selectedCategory = _categoryNames[0];
    //i've initialized this var so the app first launch won't give error
    _entityNames = ["جميع الجهات"];
    _selectedEntity = _entityNames[0];
    //i've initialized this var so the app first launch won't give error
    _listCount = 0;
  }

  @override
  Widget build(BuildContext context) {
    //here i'll check if the category length is equal to 1, coz i've initialized
    // the list with 1 item in the initState method, and i'll replace it later
    // with more items, but i don't want the list to be filled every time the
    // state of the widget changes
    if (_categoryNames.length == 1) {
      _fillCategoriesDropDownButton();
      _fillEntitiesDropDownButton();
      _fillEventList();
    }

    return Scaffold(
      appBar: _getAppBar(),
      body: Container(
          margin: EdgeInsets.only(
              left: _minimumMargin * 2,
              top: _minimumMargin,
              right: _minimumMargin * 2),
          child: Column(
            children: <Widget>[
              Container(
                margin: _dropDownButtonContainerMargin,
                child: _getCategoriesDropDownButton(),
              ),
              Container(
                margin: _dropDownButtonContainerMargin,
                child: _getEntitiesDropDownButton(),
              ),
              Container(
                margin: _containerMargin,
                child: _getEventList(),
              ),
            ],
          )),
    );
  }

  //this method will get the appBar widget
  _getAppBar() {
    return AppBar(
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

  //this method will get the categories dropDownButton
  _getCategoriesDropDownButton() {
    return DropdownButton<String>(
      items: _categoryNames.map((String item) {
        return DropdownMenuItem<String>(
          child: Container(
            child: Text(
              item,
              style: _regularText,
            ),
            alignment: Alignment(0.95, 0.0),
          ),
          value: item,
        );
      }).toList(),
      value: _selectedCategory,
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
        });
      },
      isExpanded: true,
    );
  }

  //this method will fill the categories dropDownButton with category from
  //the local db.
  _fillCategoriesDropDownButton() async {
    //fill the temporary category list with categories objects.
    var categoryList = await _databaseHelper.selectCategories();

    //fill the temporary list with category names
    var categoryNames = List<String>();
    categoryNames.add("جميع الفئات");
    for (int index = 0; index < categoryList.length; index++) {
      categoryNames.add(categoryList[index].name);
    }

    //create instance for the _categoryNames list
    setState(() {
      _categoryNames = categoryNames;
    });
  }

  //this method will get the entities dropDownButton
  _getEntitiesDropDownButton() {
    return DropdownButton<String>(
      items: _entityNames.map((String item) {
        return DropdownMenuItem<String>(
          child: Container(
            child: Text(
              item,
              style: _regularText,
            ),
            alignment: Alignment(0.95, 0.0),
          ),
          value: item,
        );
      }).toList(),
      value: _selectedEntity,
      onChanged: (value) {
        setState(() {
          _selectedEntity = value;
        });
      },
      isExpanded: true,
    );
  }

  //this method will fill the entities dropDownButton with entities from
  //the local db.
  _fillEntitiesDropDownButton() async {
    //fill the temporary entity list with entity objects.
    var entityList = await _databaseHelper.selectEntities();

    //fill the temporary list with entity names
    var entityNames = List<String>();
    for (int index = 0; index < entityList.length; index++) {
      entityNames.add(entityList[index].name);
    }

    //create instance for the _categoryNames list
    setState(() {
      _entityNames = entityNames;
    });
  }

  //this method will get the list filled with events
  _getEventList() {
    return Container(
      height: 390,
      child: ListView.builder(
        itemCount: _listCount,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Card(
                elevation: 2,
                child: Container(
                  child: ListTile(
                    title: Column(
                      children: <Widget>[
                        Row(
                          textDirection: TextDirection.rtl,
                          children: <Widget>[
                            //title
                            Text(
                              ":اللــجـــنة",
                              style: _boldText,
                            ),
                            _getContainer(),
                            Text(
                              _eventList[index].id.toString(),
                              style: _regularText,
                            ),
                          ],
                        ),
                        Row(
                          textDirection: TextDirection.rtl,
                          children: <Widget>[
                            //title
                            Text(
                              ":الموضوع",
                              style: _boldText,
                            ),
                            _getContainer(),
                            Text(
                              _eventList[index].subject,
                              style: _regularText,
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
                      ],
                    ),
                  ),
                )),
          );
        },
      ),
    );
  }

  //this method will fill the eventList entities from the local db.
  _fillEventList() async {
    List<Event> eventList = await _databaseHelper.selectEvents();
    setState(() {
      _eventList = eventList;
      _listCount = eventList.length;
    });
  }

  //this method will return a container to make a space between widgets
  _getContainer() {
    return Container(
      width: 5,
    );
  }
}
