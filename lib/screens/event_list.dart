import 'package:events_flutter/models/category.dart';
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
  static final _regularText =
      TextStyle(fontWeight: FontWeight.w400, fontSize: 19);
  static final DatabaseHelper _databaseHelper = DatabaseHelper.createInstance();
  List<Map> _categoryList = List<Map>();
  int _selectedCategoryId;
  List<String> _entityNames = List<String>();
  var _selectedEntity;
  List<Event> _eventList = List<Event>();
  var _listCount;

  @override
  void initState() {
    super.initState();
    //i've initialized this var so the app first launch won't give error
    //and by that i can show the "جميع الفئات" word as the first choice in the
    //dropDownButton
    _categoryList = [
      {"id": 0, "name": "جميع الفئات"}
    ];
    _selectedCategoryId = 0;
    //i've initialized this var so the app first launch won't give error
    _entityNames.add("جميع الجهات");
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
    if (_categoryList.length == 1) {
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
    return DropdownButton<int>(
      items: _categoryList.map((Map item) {
        return DropdownMenuItem<int>(
          child: Container(
            child: Text(
              item["name"],
              style: _regularText,
            ),
            alignment: Alignment(0.95, 0.0),
          ),
          value: item["id"],
        );
      }).toList(),
      value: _selectedCategoryId,
      onChanged: (value) {
        setState(() {
          _selectedCategoryId = value;
          _fillEntitiesDropDownButton();
        });
      },
      isExpanded: true,
    );
  }

  //this method will fill the categories dropDownButton with category from
  //the local db.
  _fillCategoriesDropDownButton() async {
    //fill the temporary category list with categories objects.
    List<Category> categoryList = await _databaseHelper.selectCategories();

    //fill the _categoryList with category ids and names
    for (int index = 0; index < categoryList.length; index++) {
      _categoryList.add(
          {"id": categoryList[index].id, "name": categoryList[index].name});
    }
  }

  //this method will get the entities dropDownButton
  _getEntitiesDropDownButton() {
    //here i'll check if there is no specific category selected,
    // or the "مكتب دائم"
    // or the "مكتب تنفيذي" categories selected
    // so in that case i'll not need to show the entities dropDownButton
    if (_selectedCategoryId != 0 &&
        _selectedCategoryId != 1 &&
        _selectedCategoryId != 2) {
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
  }

  //this method will fill the entities dropDownButton with entities from
  //the local db.
  _fillEntitiesDropDownButton() async {
    //fill the temporary entity list with entity objects.
    var entityList = await _databaseHelper.selectEntities(_selectedCategoryId);

    //fill the temporary list with entity names
    var entityNames = List<String>();
    entityNames.add("جميع الجهات");
    for (int index = 0; index < entityList.length; index++) {
      entityNames.add(entityList[index].name);
    }

    //create instance for the _categoryNames list
    setState(() {
      _entityNames = entityNames;
    });

    debugPrint(_entityNames.toString());
  }

  //this method will get the list filled with events
  _getEventList() {
    return Container(
      height: 445,
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
                              ":الــجـهـــة",
                              style: _boldText,
                            ),
                            _getContainer(),
                            Text(
                              _eventList[index].entityName,
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
                            Expanded(
                                child: Text(
                              _eventList[index].subject,
                              style: _regularText,
                              textAlign: TextAlign.right,
                            )),
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
                              ":الــوقــــت",
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

  //this method will fill the eventList entities from the local db.
  _fillEventList() async {
    List<Event> eventList = await _databaseHelper.selectEvents(_selectedEntity);
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
