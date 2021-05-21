// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:schedule_app/utils/flutter_ui_utils.dart' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:schedule_app/page/schedule_page.dart';
import 'package:schedule_app/styles.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setEnabledSystemUIOverlays([])
      .then((_) => runApp(MyApp()));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      fontFamily: "Montserrat",
      primaryColor: AppColor.inactiveGrey,
      accentColor: AppColor.pink,
    );
    return MaterialApp(
      title: 'Schedule App',  
      theme: theme,
      home: SchedulePage(),
    );
  }
}

