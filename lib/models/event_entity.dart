class EventEntity {
  int eventId;
  String entityId;

  EventEntity(this.eventId, this.entityId);

  //return a map obj to be able to save the EventEntities obj in the db
  toMap() {
    var map = Map<String, dynamic>();
    map['event_id'] = eventId;
    map['entity_id'] = entityId;
    return map;
  }

  //create the EventEntities instance form the map obj when fetched from db
  EventEntity.fromMap(map) {
    eventId = map['event_id'];
    entityId = map['entity_id'];
  }
}
