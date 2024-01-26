// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'main.dart';

class Main_page extends StatefulWidget {
  const Main_page({Key? key}) : super(key: key);

  @override
  _Main_page createState() => _Main_page();
}

class _Main_page extends State<Main_page> {
  
  // choosed effect
  static List drop_data = ['color', 'color', 'color', 'color', 'color', 'color'];

  // all available effect for each channel
  static List drop_items = [
    ['color', 'vu', 'eq'],
    ['color', 'vu', 'eq'],
    ['color', 'vu', 'eq'],
    ['color', 'vu', 'rbw'],
    ['color', 'vu', 'rbw'],
    ['color', 'vu', 'rbw']
  ];

  // disabled sliders
  static List disable_sliders = [false, false, false, false, false, false, true];

  // main colors
  static List colors = [
    HSVColor.fromColor(Colors.blue),
    HSVColor.fromColor(Colors.blue),
    HSVColor.fromColor(Colors.blue),
    HSVColor.fromColor(Colors.blue),
    HSVColor.fromColor(Colors.blue),
    HSVColor.fromColor(Colors.blue)
  ];

  // eq colors (addressable led)
  static List colors_eq = [
    [HSVColor.fromColor(Colors.white), HSVColor.fromColor(Colors.white)],
    [HSVColor.fromColor(Colors.white), HSVColor.fromColor(Colors.white)],
    [HSVColor.fromColor(Colors.white), HSVColor.fromColor(Colors.white)]
  ];

  static List colors_grad = [
    [HSVColor.fromColor(Colors.white), HSVColor.fromColor(Colors.white)],
    [HSVColor.fromColor(Colors.white), HSVColor.fromColor(Colors.white)],
    [HSVColor.fromColor(Colors.white), HSVColor.fromColor(Colors.white)]
  ];
  
  // VU effects
  static List colors_vu = [
    [HSVColor.fromColor(Colors.white), HSVColor.fromColor(Colors.white)],
    [HSVColor.fromColor(Colors.white), HSVColor.fromColor(Colors.white)],
    [HSVColor.fromColor(Colors.white), HSVColor.fromColor(Colors.white)],
    [HSVColor.fromColor(Colors.white), HSVColor.fromColor(Colors.white)],
    [HSVColor.fromColor(Colors.white), HSVColor.fromColor(Colors.white)],
    [HSVColor.fromColor(Colors.white), HSVColor.fromColor(Colors.white)]
  ];

  static List main_slider_data = [0, 0, 0, 0, 0, 0, 255];
  static List rainbow_speed = [10, 10, 10, 10, 10, 10];

  List ev_d_s = [60, 60, 60, 60, 60, 60];

  int setting_state = 0; // editable channel index
  List<double> slider_eq_c = [0.0, 0.0, 0.0]; // cut
  List<double> slider_eq_s = [100.0, 100.0, 100.0]; // sensetive
  List slider_vu_sc = [100, 100, 100, 100];

  String complete_string_int(String data) {
    String ret = "";
    for (int i=0; i < 3-data.length; i++) {
      ret += "0";
    }

    ret += data;
    return ret;
  }

  Expanded sliders(n) {
    // if cl = true - choosed master slider
    bool cl = false;
    if (n == 6) {
      cl = true;
    }

    return Expanded(
        child: SizedBox(
            height: 350,
            child: SfSliderTheme(
                data: SfSliderThemeData(
                    activeTickColor: cl ? Colors.red : Colors.blue,
                    inactiveTickColor: const Color.fromARGB(255, 0, 0, 0)),
                child: SfSlider.vertical(
                  value: main_slider_data[n],
                  onChanged: disable_sliders[n] ? (dynamic values) async {

                          if (main_slider_data[6] >= values && n != 6) {      
                            // save data
                            setState(() {
                              main_slider_data[n] = values as double;
                            });

                            // send data
                            if (n < 3) {
                              await sock_d1.write(
                                  "db_" + (n.toString()) + complete_string_int((values.toInt()).toString()) + "k"
                              );
                            } else if (n == 6) {
                              // master slider
                              for (int i = 0; i < 6; i++) {
                                if (main_slider_data[i] > main_slider_data[6]) {
                                  main_slider_data[i] = main_slider_data[6];

                                  if (i < 3 && sock_d1_state) {
                                    await sock_d1.write("db_" + (i.toString()) + complete_string_int((values.toInt()).toString()) + "k");
                                  }

                                  setState(() {
                                    main_slider_data[i] = values as double;
                                  });
                                }
                              }
                            }
                          }
                        }
                      : null,
                  min: 0.0,
                  max: 255.0,
                  stepSize: 15,
                  interval: 15,
                  showTicks: true,
                  activeColor: cl ? Colors.red.shade800 : null,
                  inactiveColor: const Color.fromARGB(255, 102, 102, 102),
                ))));
  }

  Expanded dropdown(n) {
    return Expanded(
        flex: 0,
        child: DropdownButton<String>(
          dropdownColor: const Color.fromARGB(255, 36, 36, 36).withOpacity(0.85),
          value: drop_data[n],
          elevation: 16,
          style: const TextStyle(color: Color.fromARGB(255, 142, 101, 255)),
          onChanged: (String? newValue) {
            setState(() {
              drop_data[n] = newValue;
            });

            if (n < 3 && sock_d1_state) {
              sock_d1.write("ds_" + (n.toString()) + drop_items[n].indexOf(drop_data[n]).toString() + "k");
            }

          },
          items: drop_items[n].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ));
  }

  Expanded setings(n) {
    return Expanded(
        flex: 0,
        child: SizedBox(
            height: 40,
            child: IconButton(
              icon: setting_state == n
                  ? const Icon(Icons.settings,
                      color: Color.fromARGB(255, 67, 102, 255))
                  : const Icon(
                      Icons.settings,
                      color: Color.fromARGB(255, 151, 151, 151),
                    ),
              onPressed: () {
                setting_state = n;
                setState(() {});
              },
            )));
  }

  Row color_pickers(n) {
    if (drop_data[n] == "color") {
      return Row(children: [
        Expanded(
            child: PaletteHuePicker(
                color: colors[n],
                onChanged: (dynamic color) {
                  colors[n] = color;
                  setState(() {});

                  if (n < 3 && sock_d1_state) {
                    sock_d1.write("dc_" + (n.toString())
                        + complete_string_int(colors[n].toColor().red.toString())
                        + complete_string_int(colors[n].toColor().green.toString())
                        + complete_string_int(colors[n].toColor().blue.toString())
                        + "k");
                  }
                }))
      ]);
    } else if (drop_data[n] == "eq" || drop_data[n] == "vu" || drop_data[n] == "grad") {
      return Row(children: [
        Expanded(
            child: PaletteHuePicker(
          color: drop_data[n] == "eq"? colors_eq[n][0] : (drop_data[n] == "grad"? colors_grad[n][0] : colors_vu[n][0]),
          onChanged: (color) {

            setState(() {
              if (drop_data[n] == "eq") {
                colors_eq[n][0] = color;
              } else if (drop_data[n] == "vu"){
                colors_vu[n][0] = color;
              } else if (drop_data[n] == "grad") {
                colors_grad[n][0] = color;
              }
            });
            
            if (n < 3 && sock_d1_state) {
              if (drop_data[n] == "eq") {
                sock_d1.write("dqa"
                  + (n.toString()) +
                  complete_string_int(colors_eq[n][0].toColor().red.toString()) +
                  complete_string_int(colors_eq[n][0].toColor().green.toString()) +
                  complete_string_int(colors_eq[n][0].toColor().blue.toString()) +
                  "k");
              } else if (drop_data[n] == "vu"){
                sock_d1.write("vua"
                  + (n.toString()) +
                  complete_string_int(colors_vu[n][0].toColor().red.toString()) +
                  complete_string_int(colors_vu[n][0].toColor().green.toString()) +
                  complete_string_int(colors_vu[n][0].toColor().blue.toString()) +
                  "k");
              } else if (drop_data[n] == "grad") {
                sock_d1.write("gra"
                  + (n.toString()) +
                  complete_string_int(colors_grad[n][0].toColor().red.toString()) +
                  complete_string_int(colors_grad[n][0].toColor().green.toString()) +
                  complete_string_int(colors_grad[n][0].toColor().blue.toString()) +
                  "k");
              }
            }
          },
        )),
        Expanded(
            child: PaletteHuePicker(
          color: drop_data[n] == "eq"? colors_eq[n][1] : colors_vu[n][1],
          onChanged: (color) {
            
            setState(() {
              if (drop_data[n] == "eq") {
                colors_eq[n][1] = color;
              } else {
                colors_vu[n][1] = color;
              }
            });

            if (n < 3 && sock_d1_state) {
              if (drop_data[n] == "eq") {
                sock_d1.write("dqb"
                  + (n.toString()) +
                  complete_string_int(colors_eq[n][1].toColor().red.toString()) +
                  complete_string_int(colors_eq[n][1].toColor().green.toString()) +
                  complete_string_int(colors_eq[n][1].toColor().blue.toString()) +
                  "k");
              } else if (drop_data[n] == "vu") {
                sock_d1.write("vub"
                  + (n.toString()) +
                  complete_string_int(colors_vu[n][1].toColor().red.toString()) +
                  complete_string_int(colors_vu[n][1].toColor().green.toString()) +
                  complete_string_int(colors_vu[n][1].toColor().blue.toString()) +
                  "k");
              } else if (drop_data[n] == "grad") {
                sock_d1.write("grb"
                  + (n.toString()) +
                  complete_string_int(colors_grad[n][1].toColor().red.toString()) +
                  complete_string_int(colors_grad[n][1].toColor().green.toString()) +
                  complete_string_int(colors_grad[n][1].toColor().blue.toString()) +
                  "k");
              }
            }
          },
        ))
      ]);
    } else {
      return Row(children: const [Text('')]);
    }
  }

  // nr slider(0..), name of effect, nr section
  Row eq_sliders(n, m, k) {
    // eq cut slider (only addressable), k == 0 - cut
    if (n < 3 && m == "eq" && k == 0) {
      return Row(children: [
        const Expanded(
            flex: 0,
            child: Text('cut',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)))),
        const SizedBox(width: 10),
        Expanded(
            child: SizedBox(
                width: 350,
                child: SfSlider(
                  value: slider_eq_c[n],
                  onChanged: (dynamic values) async {
                    setState(() {
                      slider_eq_c[n] = values as double;
                    });
                    if (sock_d1_state) {
                      await sock_d1.write("eqc" + n.toString() + complete_string_int(slider_eq_c[n].toInt().toString()) + "k");
                    }
                  },
                  min: 0.0,
                  max: 100.0,
                  stepSize: 4,
                  interval: 4,
                  showTicks: true,
                )))
      ]);

      // eq sensitive effect (only addressable led), k == 1 - sensitive
    } else if (n < 3 && m == "eq" && k == 1) {
      return Row(children: [
        const Expanded(
            flex: 0,
            child: Text('sensitive',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)))),
        const SizedBox(width: 10),
        Expanded(
            child: SizedBox(
                width: 350,
                child: SfSlider(
                  value: slider_eq_s[n],
                  onChanged: (dynamic values) async {
                    setState(() {
                      slider_eq_s[n] = values as double;
                    });

                    if (sock_d1_state) {
                      await sock_d1
                          .write("eqg" + n.toString() + complete_string_int(slider_eq_s[n].toInt().toString()) + "k");
                    }
                  },
                  min: 100.0,
                  max: 300.0,
                  stepSize: 10,
                  interval: 10,
                  showTicks: true,
                )))
      ]);
      // cut vu sliders
    }/* else if (n == 0 && m == "vu" && k < 6 && k > 1) {
      return Row(children: [
        const Expanded(
            flex: 0,
            child: Text('cut',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)))),
        const SizedBox(width: 10),
        Expanded(
            child: Container(
                width: 350,
                child: SfSlider(
                  value: ev_d_s[k],
                  onChanged: (dynamic values) async {
                    setState(() {
                      ev_d_s[k] = values as double;
                    });

                    if (k == 2 && sock_a1_state) {
                      await sock_a1
                          .write("avc" + (values.toInt()).toString() + "k");
                    } else if (k == 3 && sock_a1_state) {
                      await sock_a1
                          .write("bvc" + (values.toInt()).toString() + "k");
                    }
                  },
                  min: 0.0,
                  max: 250.0,
                  stepSize: 10,
                  interval: 10,
                  showTicks: true,
                )))
      ]);

      // sensitive vu slider (only analog led)
    } else if (n == 1 && m == "vu" && k < 6 && k > 1) {
      return Row(children: [
        const Expanded(
            flex: 0,
            child: Text('sensitive',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)))),
        const SizedBox(width: 10),
        Expanded(
            child: Container(
                width: 350,
                child: SfSlider(
                  value: slider_vu_sc[k - 2],
                  onChanged: (dynamic values) async {
                    setState(() {
                      slider_vu_sc[k - 2] = values as double;
                    });
                    if (k == 2 && sock_a1_state) {
                      await sock_a1
                          .write("avs" + (values.toInt()).toString() + "k");
                    } else if (k == 3 && sock_a1_state) {
                      await sock_a1
                          .write("bvs" + (values.toInt()).toString() + "k");
                    }
                  },
                  min: 0.0,
                  max: 250.0,
                  stepSize: 10,
                  interval: 10,
                  showTicks: true,
                )))
      ]);
      // rainbow speed
    } else if (n == 0 && m == "rbw") {
      return Row(children: [
        const Expanded(
            flex: 0,
            child: Text('speed',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)))),
        const SizedBox(width: 10),
        Expanded(
            child: Container(
                width: 350,
                child: SfSlider(
                  value: rainbow_speed[k],
                  onChanged: (dynamic values) async {
                    setState(() {
                      rainbow_speed[k] = values as double;
                    });

                    if (k == 0 && sock_d1_state) {
                      await sock_d1
                          .write("drs" + (values.toInt()).toString() + "k");
                    } else if (k == 2 && sock_a1_state) {
                      await sock_a1
                          .write("ars" + (values.toInt()).toString() + "k");
                    } else if (k == 3 && sock_a1_state) {
                      await sock_a1
                          .write("brs" + (values.toInt()).toString() + "k");
                    }
                  },
                  min: 0.0,
                  max: 250.0,
                  stepSize: 10,
                  interval: 10,
                  showTicks: true,
                )))
      ]);

      // cross speed
    } else if (n == 0 && m == "cross" && k < 3) {
      return Row(children: [
        const Expanded(
            flex: 0,
            child: Text('speed',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)))),
        const SizedBox(width: 10),
        Expanded(
            child: Container(
                width: 350,
                child: SfSlider(
                  value: cross_speed[k],
                  onChanged: (dynamic values) async {
                    setState(() {
                      cross_speed[k] = values as double;
                    });

                    if (k == 0 && sock_d1_state) {
                      await sock_d1
                          .write("dcs" + (values.toInt()).toString() + "k");
                    }
                  },
                  min: 0.0,
                  max: 250.0,
                  stepSize: 10,
                  interval: 10,
                  showTicks: true,
                )))
      ]);
    }*/ else {
      return Row(children: const [Text('')]);
    }
  }

  Row description_channels() {
    return Row(children: const [
      SizedBox(width: 22),
      Expanded(
          flex: 0,
          child: Text('DA',
              style: TextStyle(color: Color.fromARGB(255, 158, 206, 106)))),
      SizedBox(width: 39),
      Expanded(
          flex: 0,
          child: Text('DB',
              style: TextStyle(color: Color.fromARGB(255, 158, 206, 106)))),
      SizedBox(width: 39),
      Expanded(
          flex: 0,
          child: Text('DC',
              style: TextStyle(color: Color.fromARGB(255, 158, 206, 106)))),
      SizedBox(width: 39),
      Expanded(
          flex: 0,
          child: Text('A1',
              style: TextStyle(color: Color.fromARGB(255, 158, 206, 106)))),
      SizedBox(width: 39),
      Expanded(
          flex: 0,
          child: Text('A2',
              style: TextStyle(color: Color.fromARGB(255, 158, 206, 106)))),
      SizedBox(width: 39),
      Expanded(
          flex: 0,
          child: Text('A3',
              style: TextStyle(color: Color.fromARGB(255, 158, 206, 106)))),
      SizedBox(width: 15),
      Expanded(
          flex: 0,
          child: Text('master',
              style: TextStyle(color: Color.fromARGB(255, 252, 92, 92))))
    ]);
  }

  void init() {
    for (int i=0; i < 3; i++) {disable_sliders[i] = sock_d1_state;}
  }

  @override
  Widget build(BuildContext context) {
    // activated zone slider
    init();

    return Scaffold(
        drawer: drawer_nav(context, 1),
        body: SingleChildScrollView(
            reverse: true,
            scrollDirection: Axis.vertical,
            child: Container(
                height: 1000,
                color: const Color.fromARGB(255, 36, 39, 53),
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  const SizedBox(height: 50),

                  // number of channel, choosed effect
                  eq_sliders(setting_state, drop_data[setting_state], 0),
                  eq_sliders(setting_state, drop_data[setting_state], 1),

                  color_pickers(setting_state),

                  // effects list
                  Row(children: [
                    const SizedBox(width: 13),
                    for (int i = 0; i < 6; i++) dropdown(i),
                    const Expanded(child: Text(''))
                  ]),

                  // edit zone settings
                  Row(children: [
                    const SizedBox(width: 6),
                    setings(0),
                    const SizedBox(width: 8),
                    setings(1),
                    const SizedBox(width: 8),
                    setings(2),
                    const SizedBox(width: 8),
                    setings(3),
                    const SizedBox(width: 8),
                    setings(4),
                    const SizedBox(width: 8),
                    setings(5)
                  ]),

                  const SizedBox(height: 25),

                  // txt info
                  description_channels(),

                  // sliders
                  Row(children: [
                    for (int i = 0; i < 7; i++) sliders(i),
                  ]),
                ]))));
  }
}
