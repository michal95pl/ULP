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
  List slider_data = [0, 0, 0, 0, 0, 0, 255];
  List rainbow_speed = [10, 10, 10, 10, 10, 10];
  List cross_speed = [10, 10];

  List drop_data = ['color', 'color', 'color', 'color', 'color', 'color'];
  List drop_items = [
    ['color', 'eq', 'cross', 'rbw'],
    ['color', 'vu', 'rbw'],
    ['color', 'vu', 'rbw'],
    ['color', 'vu', 'rbw'],
    ['color', 'vu', 'rbw'],
    ['color', 'vu', 'rbw']
  ];
  List disable_sliders = [false, false, false, false, false, false, true];
  List przycisk_state = [true, false, false, false, false, false];
  List colors = [
    HSVColor.fromColor(Colors.blue),
    HSVColor.fromColor(Colors.blue),
    HSVColor.fromColor(Colors.blue),
    HSVColor.fromColor(Colors.blue),
    HSVColor.fromColor(Colors.blue),
    HSVColor.fromColor(Colors.blue)
  ];
  List colors_eq = [
    HSVColor.fromColor(Colors.white),
    HSVColor.fromColor(Colors.white)
  ];
  List cross = [
    HSVColor.fromColor(Colors.white),
    HSVColor.fromColor(Color.fromARGB(255, 0, 0, 0))
  ];
  List colors_eq_b = [
    HSVColor.fromColor(Colors.black),
    HSVColor.fromColor(Colors.black)
  ];
  List colors_ev0 = [
    HSVColor.fromColor(Colors.white),
    HSVColor.fromColor(Colors.white),
    HSVColor.fromColor(Colors.white),
    HSVColor.fromColor(Colors.white),
    HSVColor.fromColor(Colors.white),
    HSVColor.fromColor(Colors.white)
  ];
  List colors_ev1 = [
    HSVColor.fromColor(Colors.black),
    HSVColor.fromColor(Colors.black),
    HSVColor.fromColor(Colors.black),
    HSVColor.fromColor(Colors.black),
    HSVColor.fromColor(Colors.black),
    HSVColor.fromColor(Colors.black)
  ];
  List ev_d_s = [60, 60, 60, 60, 60, 60];
  int setting_state = 0;
  double slider_eq_cu = 11;
  double slider_eq_s = 100;
  List slider_vu_sc = [100, 100, 100, 100];

  Expanded sliders(n) {
    // cos zwiazane z master slider
    bool cl = false;
    if (n == 6) {
      cl = true;
    }

    return Expanded(
        child: Container(
            height: 350,
            child: SfSliderTheme(
                data: SfSliderThemeData(
                    activeTickColor: cl ? Colors.red : Colors.blue,
                    inactiveTickColor: const Color.fromARGB(255, 0, 0, 0)),
                child: SfSlider.vertical(
                  value: slider_data[n],
                  onChanged: disable_sliders[n]
                      ? (dynamic values) async {
                          if (slider_data[6] >= values && n != 6) {
                            // save data
                            setState(() {
                              slider_data[n] = values as double;
                            });

                            // send data

                            if (n == 0) {
                              await sock_d1.write(
                                  "db_" + (values.toInt()).toString() + "k");
                            } else if (n == 2) {
                              await sock_a1.write(
                                  "ab_" + (values.toInt()).toString() + "k");
                            } else if (n == 3) {
                              await sock_a1.write(
                                  "bb_" + (values.toInt()).toString() + "k");
                            } else if (n == 6) {
                              setState(() {
                                slider_data[n] = values as double;
                              });

                              // master slider
                              for (int i = 0; i < 6; i++) {
                                if (slider_data[i] > slider_data[6]) {
                                  slider_data[i] = slider_data[6];

                                  if (i == 0 && sock_d1_state) {
                                    await sock_d1.write("db_" +
                                        (values.toInt()).toString() +
                                        "k");
                                  }

                                  if (i == 2 && sock_a1_state) {
                                    await sock_a1.write("ab_" +
                                        (values.toInt()).toString() +
                                        "k");
                                  }

                                  if (i == 3 && sock_a1_state) {
                                    await sock_a1.write("bb_" +
                                        (values.toInt()).toString() +
                                        "k");
                                  }

                                  setState(() {
                                    slider_data[i] = values as double;
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
                  inactiveColor: Color.fromARGB(255, 102, 102, 102),
                ))));
  }

  Expanded dropdown(n) {
    return Expanded(
        flex: 0,
        child: DropdownButton<String>(
          dropdownColor: Color.fromARGB(255, 36, 36, 36).withOpacity(0.85),
          value: drop_data[n],
          elevation: 16,
          style: const TextStyle(color: Color.fromARGB(255, 142, 101, 255)),
          onChanged: (String? newValue) {
            setState(() {
              drop_data[n] = newValue!;
            });

            if (n == 0 && sock_d1_state) {
              sock_d1.write(
                  "ds_" + drop_items[n].indexOf(drop_data[n]).toString() + "k");
            } else if (n == 2 && sock_a1_state) {
              sock_a1.write(
                  "as_" + drop_items[n].indexOf(drop_data[n]).toString() + "k");
            } else if (n == 3 && sock_a1_state) {
              sock_a1.write(
                  "bs_" + drop_items[n].indexOf(drop_data[n]).toString() + "k");
            }

            /*if (n == 4 || n == 5) {
              sock_d1.write("bas" +
                  n.toString() +
                  drop_items[n].indexOf(drop_data[n]).toString() +
                  "k");
            }*/
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
        child: Container(
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
    bool show = true;
    if (drop_data[n] == "color") {
      return Row(children: [
        Expanded(
            child: PaletteHuePicker(
                color: colors[n],
                onChanged: (dynamic color) {
                  colors[n] = color;
                  setState(() {});

                  if (n == 0 && sock_d1_state) {
                    print("dc color");
                    sock_d1.write("dc_" +
                        colors[n].toColor().red.toString() +
                        ',' +
                        colors[n].toColor().green.toString() +
                        ',' +
                        colors[n].toColor().blue.toString() +
                        ",k");
                  } else if (n == 2 && sock_a1_state) {
                    print("ac color");
                    sock_a1.write("ac_" +
                        colors[n].toColor().red.toString() +
                        ',' +
                        colors[n].toColor().green.toString() +
                        ',' +
                        colors[n].toColor().blue.toString() +
                        ",k");
                  } else if (n == 3 && sock_a1_state) {
                    sock_a1.write("bc_" +
                        colors[n].toColor().red.toString() +
                        ',' +
                        colors[n].toColor().green.toString() +
                        ',' +
                        colors[n].toColor().blue.toString() +
                        ",k");
                  }
                }))
      ]);
    } else if (drop_data[n] == "eq") {
      return Row(children: [
        Expanded(
            child: PaletteHuePicker(
          color: colors_eq[n],
          onChanged: (color) {
            colors_eq[n] = color;
            setState(() {});
            if (n == 0 && sock_d1_state) {
              sock_d1.write("dqm" +
                  colors_eq[n].toColor().red.toString() +
                  ',' +
                  colors_eq[n].toColor().green.toString() +
                  ',' +
                  colors_eq[n].toColor().blue.toString() +
                  ",k");
            }
          },
        )),
        Expanded(
            child: PaletteHuePicker(
          color: colors_eq_b[n],
          onChanged: (color) {
            colors_eq_b[n] = color;
            setState(() {});
            if (n == 0 && sock_d1_state) {
              sock_d1.write("dqb" +
                  colors_eq_b[n].toColor().red.toString() +
                  ',' +
                  colors_eq_b[n].toColor().green.toString() +
                  ',' +
                  colors_eq_b[n].toColor().blue.toString() +
                  ",k");
            }
          },
        ))
      ]);
    } else if (drop_data[n] == "vu") {
      return Row(children: [
        Expanded(
            child: PaletteHuePicker(
          color: colors_ev0[n],
          onChanged: (color) {
            colors_ev0[n] = color;
            setState(() {});

            if (n == 0 && sock_d1_state) {
              sock_d1.write("dvm" +
                  colors_ev0[n].toColor().red.toString() +
                  ',' +
                  colors_ev0[n].toColor().green.toString() +
                  ',' +
                  colors_ev0[n].toColor().blue.toString() +
                  ",k");
            } else if (n == 2 && sock_a1_state) {
              sock_a1.write("avm" +
                  colors_ev0[n].toColor().red.toString() +
                  ',' +
                  colors_ev0[n].toColor().green.toString() +
                  ',' +
                  colors_ev0[n].toColor().blue.toString() +
                  ",k");
            } else if (n == 3 && sock_a1_state) {
              sock_a1.write("bvm" +
                  colors_ev0[n].toColor().red.toString() +
                  ',' +
                  colors_ev0[n].toColor().green.toString() +
                  ',' +
                  colors_ev0[n].toColor().blue.toString() +
                  ",k");
            }
          },
        )),
        Expanded(
            child: PaletteHuePicker(
          color: colors_ev1[n],
          onChanged: (color) {
            colors_ev1[n] = color;
            setState(() {});
            if (n == 0 && sock_d1_state) {
              sock_d1.write("dvb" +
                  colors_ev1[n].toColor().red.toString() +
                  ',' +
                  colors_ev1[n].toColor().green.toString() +
                  ',' +
                  colors_ev1[n].toColor().blue.toString() +
                  ",k");
            } else if (n == 2 && sock_a1_state) {
              sock_a1.write("avb" +
                  colors_ev1[n].toColor().red.toString() +
                  ',' +
                  colors_ev1[n].toColor().green.toString() +
                  ',' +
                  colors_ev1[n].toColor().blue.toString() +
                  ",k");
            } else if (n == 3 && sock_a1_state) {
              sock_a1.write("bvb" +
                  colors_ev1[n].toColor().red.toString() +
                  ',' +
                  colors_ev1[n].toColor().green.toString() +
                  ',' +
                  colors_ev1[n].toColor().blue.toString() +
                  ",k");
            }
          },
        ))
      ]);
    } else if (drop_data[n] == "cross" && n == 0) {
      return Row(children: [
        Expanded(
            child: PaletteHuePicker(
          color: cross[0],
          onChanged: (color) {
            cross[0] = color;
            setState(() {});

            if (n == 0 && sock_d1_state) {
              sock_d1.write("dc1" +
                  cross[0].toColor().red.toString() +
                  ',' +
                  cross[0].toColor().green.toString() +
                  ',' +
                  cross[0].toColor().blue.toString() +
                  ",k");
            }
          },
        )),
        Expanded(
            child: PaletteHuePicker(
          color: cross[1],
          onChanged: (color) {
            cross[1] = color;
            setState(() {});
            if (n == 0) {
              sock_d1.write("dc2" +
                  cross[1].toColor().red.toString() +
                  ',' +
                  cross[1].toColor().green.toString() +
                  ',' +
                  cross[1].toColor().blue.toString() +
                  ",k");
            }
          },
        ))
      ]);
    } else {
      return Row(children: const [Text('')]);
    }
  }

  // nr slider, name of effect, nr section
  Row eq_sliders(n, m, k) {
    // eq cut slider (only addressable)
    if (n == 0 && m == "eq") {
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
                  value: slider_eq_cu,
                  onChanged: (dynamic values) async {
                    setState(() {
                      slider_eq_cu = values as double;
                    });
                    if (k == 0 && sock_d1_state) {
                      await sock_d1
                          .write("dqc" + (values.toInt()).toString() + "k");
                    }
                  },
                  min: 0.0,
                  max: 100.0,
                  stepSize: 4,
                  interval: 4,
                  showTicks: true,
                )))
      ]);

      // eq sensitive effect (only addressable led)
    } else if (n == 1 && m == "eq") {
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
                  value: slider_eq_s,
                  onChanged: (dynamic values) async {
                    setState(() {
                      slider_eq_s = values as double;
                    });

                    if (k == 0 && sock_d1_state) {
                      await sock_d1
                          .write("dqs" + (values.toInt()).toString() + "k");
                    }
                  },
                  min: 0.0,
                  max: 250.0,
                  stepSize: 10,
                  interval: 10,
                  showTicks: true,
                )))
      ]);
      // cut vu sliders
    } else if (n == 0 && m == "vu" && k < 6 && k > 1) {
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
    } else {
      return Row(children: const [Text('')]);
    }
  }

  Row description_channels() {
    return Row(children: const [
      SizedBox(width: 22),
      Expanded(
          flex: 0,
          child: Text('D1',
              style: TextStyle(color: Color.fromARGB(255, 158, 206, 106)))),
      SizedBox(width: 39),
      Expanded(
          flex: 0,
          child: Text('D2',
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
      SizedBox(width: 39),
      Expanded(
          flex: 0,
          child: Text('A4',
              style: TextStyle(color: Color.fromARGB(255, 158, 206, 106)))),
      SizedBox(width: 15),
      Expanded(
          flex: 0,
          child: Text('master',
              style: TextStyle(color: Color.fromARGB(255, 252, 92, 92))))
    ]);
  }

  void init() {
    disable_sliders[0] = sock_d1_state;
    disable_sliders[2] = sock_a1_state;
    disable_sliders[3] = sock_a1_state;
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
                  eq_sliders(0, drop_data[setting_state], setting_state),
                  eq_sliders(1, drop_data[setting_state], setting_state),

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
