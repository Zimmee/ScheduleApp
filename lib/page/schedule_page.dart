import 'dart:ffi';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'package:schedule_app/page/allBuses_page.dart';
import 'package:schedule_app/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/models/app_settings.dart';
import 'dart:convert';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:boxicons_flutter/boxicons_flutter.dart';

class SchedulePage extends StatefulWidget {
  final Widget timetableButton;
  const SchedulePage({this.timetableButton});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Bus> data;
  List<Bus> ldata = [];
  List<Bus> listData;
  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Container(
        decoration: BoxDecoration(color: Colors.white),
      );
    } else {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.refresh),
            onPressed: () => _loadData(),
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.fill,
                colorFilter: new ColorFilter.mode(
                    Colors.white.withOpacity(0.4), BlendMode.dstATop),
              ),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 34),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(21.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            blurRadius: 6.0,
                            spreadRadius: 1.0,
                            offset: Offset(0.0, 5.0))
                      ]),
                  child: Column(children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 24),
                      child: _buildPersentIdicator(),
                    ),
                    _nearestBus()
                  ]),
                ),
                Container(
                    child: Align(
                  child: Container(
                    height: 240,
                    child: ListView(
                      children: _buildList(),
                      scrollDirection: Axis.horizontal,
                    ),
                    margin: EdgeInsets.only(bottom: 40),
                  ),
                  alignment: Alignment.bottomCenter,
                )),
                Container(
                  alignment: Alignment.center,
                  height: 55,
                  margin: EdgeInsets.only(bottom: 17),
                  child: ButtonTheme(
                      minWidth: 170,
                      height: 55,
                      buttonColor: AppColor.pink,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllBusesPage()),
                          );
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        child: Text(
                          "Розклад",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                      )),
                )
              ],
            ),
          ));
    }
  }

  @protected
  @mustCallSuper
  void reassemble() {
    _loadData();
  }

  _buildPersentIdicator() {
    _setData();
    Bus indData = listData[0];
    Color indColor;
    double persent;
    if (_howMuchMinutes(indData.time).toString().length > 2) {
      indColor = Color(0xFF29BF12);
    } else {
      if (int.parse(_howMuchMinutes(indData.time)) > 60) {
        indColor = Color(0xFF29BF12);
      } else if (int.parse(_howMuchMinutes(indData.time)) < 30 &&
          int.parse(_howMuchMinutes(indData.time)) > 10) {
        indColor = Color(0xFFE28413);
      } else {
        indColor = Color(0xFFFF0023);
      }
    }
    if (_howMuchMinutes(indData.time).toString().length > 2) {
      persent = 0;
    } else {
      if (int.parse(_howMuchMinutes(indData.time)) > 60) {
        persent = 0;
      } else {
        persent = 1 - int.parse(_howMuchMinutes(indData.time)) / 60;
      }
    }
    print(MediaQuery.of(context).size.height);
    return Container(
      decoration:
          BoxDecoration(border: Border.all(width: 2, color: Colors.black)),
      child: CircularPercentIndicator(
        radius: MediaQuery.of(context).size.height / 6,
        animation: true,
        animationDuration: 1200,
        lineWidth: 5.0,
        percent: persent,
        center: Container(
          alignment: Alignment.center,
          child: Icon(Boxicons.bxsBus, size: 90),
        ),
        circularStrokeCap: CircularStrokeCap.butt,
        backgroundColor: indColor,
        progressColor: Color(0xFF929292),
      ),
    );
  }

  _nearestBus() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        _setData();
        return Container(
          height: constraints.maxHeight,
          child: Column(
            children: <Widget>[
              Container(
                height: constraints.maxHeight / 2,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: AutoSizeText.rich(
                  TextSpan(
                    text: (listData[0].route),
                  ),
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  minFontSize: 20,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                height: constraints.maxHeight / 2,
                child: Align(
                  alignment: Alignment.center,
                  child: AutoSizeText.rich(
                    TextSpan(
                      text: (DateFormat('HH:mm').format(listData[0].time)),
                    ),
                    style: TextStyle(
                      fontSize: 60,
                    ),
                    maxLines: 1,
                    minFontSize: 20,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  _howMuchMinutes(DateTime time) {
    var busMinute = time.minute;
    var nowMinute = DateTime.now().toLocal().minute;
    var busHour = time.hour;
    var nowHour = DateTime.now().toLocal().hour;
    if ((busHour - nowHour) * 60 + (busMinute - nowMinute) >= 60 ||
        (busHour - nowHour) < 0) {
      return DateFormat('HH:mm').format(time);
    }
    if (busMinute - nowMinute < 0) {
      if ((busMinute - nowMinute + 60).toString().length == 1) {
        return "0" + (busMinute - nowMinute + 60).toString();
      } else {
        return (busMinute - nowMinute + 60).toString();
      }
    } else {
      if ((busMinute - nowMinute).toString().length == 1) {
        return "0" + (busMinute - nowMinute).toString();
      } else {
        return (busMinute - nowMinute).toString();
      }
    }
  }

  _setData() {
    var start = -1;
    for (Bus f in data) {
      var busHour = f.time.hour;
      var nowHour = DateTime.now().toLocal().hour;
      var busMinute = f.time.minute;
      var nowMinute = DateTime.now().toLocal().minute;
      if ((busHour - nowHour == 0 && busMinute - nowMinute >= 0) ||
          busHour - nowHour > 0) {
        start = f.listIdx - 1;
        break;
      }
    }
    var end = start + 6;
    if (start == -1) {
      listData = data.sublist(0, 7);
    } else if (data.length - start < 6) {
      end = data.length;
      listData = (data.sublist(start) + data.sublist(0, 6 - (end - start) + 1));
    } else {
      listData = data.sublist(start, start + 7);
    }
    setState(() {
      listData = listData;
    });
  }

  List<Widget> _buildList() {
    _setData();
    return listData
        .sublist(1)
        .map((Bus f) => Container(
              width: 170,
              child: Column(children: <Widget>[
                Text(
                  _howMuchMinutes(f.time),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: _howMuchMinutes(f.time).toString().length > 2
                          ? 40
                          : 50,
                      fontWeight: FontWeight.bold,
                      color: _textColor(f, "minute")),
                ),
                _howMuchMinutes(f.time).toString().length == 2
                    ? Text(
                        "хвилин",
                        style: TextStyle(
                          color: _textColor(f, "text1"),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )
                    : Container(
                        height: 0,
                        width: 0,
                      ),
                Container(
                  height: 45,
                  child: AutoSizeText.rich(
                    TextSpan(
                      text: (f.route
                          .split("— ")[1]
                          .replaceAll(new RegExp(r' '), '\n')),
                    ),
                    style: TextStyle(
                      fontSize: 20,
                      color: _textColor(f, "text2"),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                  ),
                  margin: EdgeInsets.only(top: 20),
                )
              ]),
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              padding: EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(21.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        blurRadius: 6.0,
                        spreadRadius: 1.0,
                        offset: Offset(0.0, 5.0))
                  ]),
              //title: Text(f.route),
              //leading: CircleAvatar(child:Text(f.listIdx.toString())),
              //trailing: Text(DateFormat('HH:mm').format(f.time))
            ))
        .toList();
  }

  @override
  Void initState() {
    _loadData();
    super.initState();
  }

  Color _textColor(Bus f, String type) {
    if (f == listData[0]) {
      if (type == "text2") {
        return Colors.black;
      } else {
        return AppColor.pink;
      }
    } else {
      if (type == "minute") {
        return AppColor.inactiveDarkGrey;
      } else {
        return AppColor.inactiveGrey;
      }
    }
  }

  _loadData() async {
    //Parse json and creates a list of Bus instances
    String response =
        await DefaultAssetBundle.of(context).loadString("assets/data.json");
    var jsonResult = (json.decode(response) as Map) as Map<String, dynamic>;
    var jsonDataList = List<Bus>();
    jsonResult.forEach((String key, dynamic val) {
      var record = Bus(
          route: val['route'],
          time: _fromJson(val['time']),
          throughVil: val['throughVil'],
          listIdx: val['listIdx']);
      jsonDataList.add(record);
    });
    setState(() {
      data = jsonDataList;
    });
    return jsonDataList;
  }

  DateTime _fromJson(String json) {
    //Converts string to Datetime object
    var hour = int.parse(json.substring(0, 2));
    var minute = int.parse(json.substring(3));
    var time = DateTime.now();
    time = time.toLocal();
    time = DateTime(time.year, time.month, time.day, hour, minute, time.second,
        time.millisecond, time.microsecond);
    return time;
  }
}
