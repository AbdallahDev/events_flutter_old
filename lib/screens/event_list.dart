import 'package:events_flutter/models/category.dart';
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
  List<Map> _entityList = List<Map>();
  int _selectedEntityId;
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

    //i've initialized this var so the app when first launch won't give an error
    //and by that i can show the "جميع الجهات" word as the first choice in the
    //dropDownButton
    _entityList = [
      {"id": 0, "name": "جميع الجهات"}
    ];
    _selectedEntityId = 0;

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
      _fillEventList(0);
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
      onChanged: (selectedCategoryId) {
        setState(() {
          _selectedCategoryId = selectedCategoryId;
          //bellow i'll check if the selectedCategoryId is not 0,1 or 2,
          // because in that case i don't want to show the entities dropDownButton,
          // coz it's not needed.
          if (selectedCategoryId != 0 &&
              selectedCategoryId != 1 &&
              selectedCategoryId != 2) _fillEntitiesDropDownButton();
          _fillEventList(0);
        });
      },
      isExpanded: true,
    );
  }

  //this method will fill the entities dropDownButton with entities from
  //the local db.
  _fillEntitiesDropDownButton() async {
    //fill the temporary entity list with entity objects.
    List<Entity> entityListSelected =
        await _databaseHelper.selectEntities(_selectedCategoryId, 0);

    //bellow i'll create temporary list to fill it from the one selected from
    // the db
    List<Map> entityList = [
      {"id": 0, "name": "جميع الجهات"}
    ];
    //here i'll add to the list the first default value so it can appear as
    // a first choice in the dropDownButton
    for (int index = 0; index < entityListSelected.length; index++) {
      entityList.add({
        "id": entityListSelected[index].id,
        "name": entityListSelected[index].name
      });
    }
    //bellow i'll call the setState function to refill the _entityList with
    //the entity ids and names, and by that the entityDropDownButton will be
    // filled with the new values
    setState(() {
      _entityList = entityList;
    });
  }

  //this method will get the entities dropDownButton
  _getEntitiesDropDownButton() {
    //here i reset the value of the _selectedEntityId var to 0, coz if the user
    // choose an entity form the entity list the _selectedEntityId value will be
    // the id of that chosen entity, and when he want to select another category
    // the entity dropdownButton will crash coz the value of it is the id of an
    // entity that is not exist in this current category but in the last category,
    // so when i reset it to 0 by that i make sure the id is for an entity exist
    // in this category and all the categories and that is the first entity "جميع الجهات".
    _selectedEntityId = 0;
    //here i'll check if there is no specific category selected,
    // or the "مكتب دائم"
    // or the "مكتب تنفيذي" categories selected
    // so in that case i'll not need to show the entities dropDownButton
    if (_selectedCategoryId != 0 &&
        _selectedCategoryId != 1 &&
        _selectedCategoryId != 2) {
      return DropdownButton<int>(
        items: _entityList.map((Map item) {
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
        value: _selectedEntityId,
        onChanged: (selectedEntityId) {
          setState(() {
            _selectedEntityId = selectedEntityId;
            _fillEventList(1);
          });
        },
        isExpanded: true,
      );
    }
  }

  //this method will fill the eventList entities from the local db.
  _fillEventList(int eventsReturnType) async {
    List<Event> eventList =
        await _databaseHelper.selectEvents(_selectedCategoryId, _selectedEntityId, eventsReturnType);
    setState(() {
      _eventList = eventList;
      _listCount = eventList.length;
    });
  }

  //this method will get the list filled with events
  _getEventList() {
    return Container(
      height: 370,
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

  //this method will return a container to make a space between widgets
  _getContainer() {
    return Container(
      width: 5,
    );
  }
}
