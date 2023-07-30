// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class SettingEventMainData {
  // Pipeline rcv data
  static List<num> battery_chart = [];
  static List data_rcv = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  static var listen_thread;
  static var bcSocket;

  // Led data
  static List speed_value = [50, 50, 50, 50, 50];
  
  static HSVColor colorDefault =
      HSVColor.fromColor(const Color.fromARGB(255, 0, 0, 0));
  static List gradientColor = [
    HSVColor.fromColor(Colors.blue),
    HSVColor.fromColor(Colors.red)
  ];

  //modes
  static bool devModeState = true;
  static bool precisionMeter = true;
  static int indx_battery = 0;

  //battery
  static int voltage = 0;
  static int current = 0;

  //music
  static List music_all = ["1muz"];
  static String choosed_music = "1muz";
  static bool play_music = false;
}
