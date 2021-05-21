


List<Bus> allAddedBuses = [
  Bus(route: "Тернопыль - Чорткыв",time: DateTime(DateTime.now().year, 15, 00), throughVil: true, listIdx: 0),

];

class Bus {
  String route;
  DateTime time;
  bool throughVil = false;
  int listIdx;

  Bus({this.route, this.time, this.throughVil, this.listIdx}) {
    assert(route != null);
    if (listIdx == null) {
      listIdx = allAddedBuses.length + 1;
    }
  }
}