// ignore_for_file: deprecated_member_use, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_types_as_parameter_names, unused_catch_stack, unused_catch_clause

import 'setting_page.dart';
import 'event_page.dart';
import 'main_led.dart';
import 'start_page.dart';

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// sockets data:
// auto connect cpu0 ...
List autoConnect = [false, false, false];

// addressable controller
var sock_d1;
bool sock_d1_state = false;

// analog controller
var sock_a1;
bool sock_a1_state = false;

// portable led
var sockEvent;
bool sockEvent_state = false;


// txt data
var NewVersionData;
bool showJson = true;

var fileSettings;  // file
var settingsJsonData; // json

void main() async {
  // inf table
  //try {
  //final response = await http.get(Uri.parse(
  //'https://raw.githubusercontent.com/michal95pl/ULP-API/main/INF.json'));

  /*if (response.statusCode == 200) {
      NewVersionData = jsonDecode(NewVersionData = response.body);
      if (NewVersionData["show"] == "No") {
        showJson = false;
      } else {
        showJson = true;
      }
    } else {*/
  NewVersionData = "NoData";
  showJson = false;
  /*}
  } on Exception catch (SocketException) {
    NewVersionData = "NoData";
    showJson = false;
  }*/

  runApp(const Distributor());

  // prepare settings file
  final dirPath = await getApplicationDocumentsDirectory();
  final path = dirPath.path;
  fileSettings = File('$path/settings.json');

  // create file if not exists
  try {
    await fileSettings.readAsString(encoding: utf8);
  } on FileSystemException {
    await fileSettings.writeAsString(
        '{"CPU1_IP":"192.168.100.100:25566","CPU2_IP":"192.168.100.100:25566","CPU3_IP":"192.168.100.100:25566","CPU1_AUTO-CONNECT":"false","CPU2_AUTO-CONNECT":"false","CPU3_AUTO-CONNECT":"false"}');
  }
  settingsJsonData =
      jsonDecode(await fileSettings.readAsString(encoding: utf8));

   // read json settings file
  if (settingsJsonData != null) {
    for (int i = 0; i < 3; i++) {
      autoConnect[i] = (settingsJsonData["CPU" + (i + 1).toString() + "_AUTO-CONNECT"] == "true");
    }
  }

  // init display files
  /*for (int i=0; i < 4; i++) {
    File fileSettings = File('$path/d$i.bin');
    try {
      await fileSettings.readAsString(encoding: utf8);
    } on FileSystemException {
      var temp = List.filled(768, 0);
      await fileSettings.writeAsBytes(temp);
    }
  }*/

}

class Distributor extends StatelessWidget {
  const Distributor({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Start_app(),
      title: 'ULP',
      initialRoute: '/',
      routes: {
        '/mainpage': (context) => const Main_page(),
        '/settings': (context) => const Setting_page(),
        '/eventPage': (context) => const Event_page()
      },
    );
  }
}

Theme drawer_nav(BuildContext context, int setIndex) {
  return Theme(
      data: ThemeData(
          canvasColor: const Color.fromARGB(255, 28, 28, 28).withOpacity(0.77)),
      child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            height: 380,
            width: 210,
            child: Drawer(
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(20)),
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  const DrawerHeader(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('drawer.jpg'),
                            fit: BoxFit.cover)),
                    child: null,
                  ),
                  ListTile(
                    leading: Icon(Icons.home,
                        color: (setIndex == 1)
                            ? const Color.fromARGB(255, 149, 61, 255)
                            : const Color.fromARGB(255, 189, 189, 189)),
                    title: Text("main",
                        style: TextStyle(
                            color: (setIndex == 1)
                                ? const Color.fromARGB(255, 149, 61, 255)
                                : const Color.fromARGB(255, 189, 189, 189))),
                    onTap: (setIndex != 1)
                        ? () {
                            Navigator.pushNamed(context, "/mainpage");
                          }
                        : null,
                  ),
                  ListTile(
                    leading: Icon(Icons.extension,
                        color: (setIndex == 2)
                            ? const Color.fromARGB(255, 149, 61, 255)
                            : const Color.fromARGB(255, 189, 189, 189)),
                    title: Text("event",
                        style: TextStyle(
                            color: (setIndex == 2)
                                ? const Color.fromARGB(255, 149, 61, 255)
                                : const Color.fromARGB(255, 189, 189, 189))),
                    onTap: (setIndex != 2)
                        ? () {
                            Navigator.pushNamed(context, "/eventPage");
                          }
                        : null,
                  ),
                  ListTile(
                    leading: Icon(Icons.settings,
                        color: (setIndex == 3)
                            ? const Color.fromARGB(255, 149, 61, 255)
                            : const Color.fromARGB(255, 189, 189, 189)),
                    title: Text("settings",
                        style: TextStyle(
                            color: (setIndex == 3)
                                ? const Color.fromARGB(255, 149, 61, 255)
                                : const Color.fromARGB(255, 189, 189, 189))),
                    onTap: (setIndex != 3)
                        ? () {
                            Navigator.pushNamed(context, "/settings");
                          }
                        : null,
                  ),
                ],
              ),
            ),
          )));
}
