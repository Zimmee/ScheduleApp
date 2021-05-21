import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/models/app_settings.dart';
import 'package:schedule_app/styles.dart';
import 'dart:convert';
import 'package:schedule_app/utils/flutter_ui_utils.dart' as ui;

class AllBusesPage extends StatefulWidget {
  final Widget timetableButton;
  const AllBusesPage({this.timetableButton});

  @override
  _AllBusesPageState createState() => _AllBusesPageState();
}

class _AllBusesPageState extends State<AllBusesPage> {
  List<Bus> data = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            ui.appBarHeight(context),
          ),
          child: AppBar(
            backgroundColor: AppColor.pink,
            title: Text("Розклад"),
            centerTitle: true,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                      child: ListView.separated(
                shrinkWrap: true,
                itemCount: data.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final Bus bus = data[index];
                  return ListTile(
                    title: Text(
                      bus.route,
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: Text(
                      DateFormat('HH:mm').format(bus.time),
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                  );
                },
              ))),
            ],
          ),
        ));
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

  @override
  void initState() {
    super.initState();
    _loadData();
  }
}
