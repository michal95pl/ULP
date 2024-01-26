// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import 'main.dart';
import 'data_containers.dart';

class SettingPageTools {
  static String temp = "";

  static List dataDecrypt(String data) {
    temp = "";
    List outData = [];

    for (int i = 1; i < data.length - 1; i++) {
      if (data[i] == ',') {
        outData.add(int.parse(temp));
        temp = "";
      } else {
        temp += data[i];
      }
    }
    outData.add(int.parse(temp));
    return outData;
  }

  static List<num> chartDecrypt(String data) {
    temp = "";
    List<num> data_battery = [];

    for (int i = 1; i < data.length - 1; i++) {
      temp += data[i];
      if (i % 3 == 0) {
        data_battery.add(double.parse(temp));
        temp = "";
      }
    }
    return data_battery;
  }
}

class Setting_page extends StatefulWidget {
  const Setting_page({Key? key}) : super(key: key);

  @override
  _Setting_page createState() => _Setting_page();
}

class _Setting_page extends State<Setting_page> {
  // cpu field
  bool startRefresh = true;
  List controllersIP = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  bool open_page = true;

  bool low_battery = false;
  List battery_mode = ["", "4s", "3s", "USB"];

  String temp = "";

  Future recivePipeline() async {
    /*try {
      SettingEventMainData.listen_thread =
          SettingEventMainData.bcSocket.listen((data) {
        temp = String.fromCharCodes(data).trim();

        // main color r,g,b; gradient1 r,g,b; gradient2 r,g,b; state; voltage(int)/100 -> float
        if (temp[0] == 'D') {
          SettingEventMainData.data_rcv = SettingPageTools.dataDecrypt(temp);
          SettingEventMainData.colorDefault = HSVColor.fromColor(Color.fromARGB(
              255,
              SettingEventMainData.data_rcv[0],
              SettingEventMainData.data_rcv[1],
              SettingEventMainData.data_rcv[2]));
          SettingEventMainData.gradientColor[0] = HSVColor.fromColor(
              Color.fromARGB(
                  255,
                  SettingEventMainData.data_rcv[3],
                  SettingEventMainData.data_rcv[4],
                  SettingEventMainData.data_rcv[5]));
          SettingEventMainData.gradientColor[1] = HSVColor.fromColor(
              Color.fromARGB(
                  255,
                  SettingEventMainData.data_rcv[6],
                  SettingEventMainData.data_rcv[7],
                  SettingEventMainData.data_rcv[8]));

          SettingEventMainData.voltage = SettingEventMainData.data_rcv[9];
          SettingEventMainData.setMode =
              SettingEventMainData.itm[SettingEventMainData.data_rcv[10]];
          SettingEventMainData.sliderGainValue =
              SettingEventMainData.data_rcv[11];

          for (int i = 0; i < 5; i++) {
            SettingEventMainData.speed_value[i] =
                SettingEventMainData.data_rcv[12 + i];
          }

          SettingEventMainData.precisionMeter =
              SettingEventMainData.data_rcv[17] == 0 ? false : true;
          SettingEventMainData.indx_battery = SettingEventMainData.data_rcv[18];
          SettingEventMainData.current = SettingEventMainData.data_rcv[19];

          print(SettingEventMainData.data_rcv);
        } else if (temp[0] == 'B') {
          SettingEventMainData.battery_chart =
              SettingPageTools.chartDecrypt(temp);
          print(SettingEventMainData.battery_chart);
        }

        setState(() {});
      },
              // check connection socket
              onDone: () {
        sockEvent_state = false;
        setState(() {});
      });
      // ignore: empty_catches
    } catch (e) {}*/
  }

  void refreshData() {
    // set data in txt filed
    for (int i = 0; i < 3; i++) {
      controllersIP[i].text = settingsJsonData["CPU" + (i + 1).toString() + "_IP"];
      autoConnect[i] = (settingsJsonData["CPU" + (i + 1).toString() + "_AUTO-CONNECT"] == "true");
    }
  }

  List convertTo_PortIP(x) {
    List data = ["", ""];
    String s = "";

    for (int i = 0; i < x.length; i++) {
      if (x[i] == ':') {
        data[0] = s;
        s = "";
      } else {
        s += x[i];
      }
    }
    data[1] = s;
    return data;
  }

  Row connectButtons(indx) {
    return Row(children: [
      Text("cpu" + (indx + 1).toString() + ": ",
          style: const TextStyle(color: Colors.white, fontSize: 16)),
      const SizedBox(width: 8),
      ElevatedButton(
          onPressed: () async {
            // addressable
            if (indx == 0) {
              List netData = convertTo_PortIP(settingsJsonData["CPU1_IP"]);
              sock_d1_state = true;
              try {
                sock_d1 =
                    await Socket.connect(netData[0], int.parse(netData[1]))
                        .timeout(const Duration(milliseconds: 100));
              } on Exception catch (TimeoutException, SocketException) {
                sock_d1_state = false;
              }
            } else if (indx == 1) {
              List netData = convertTo_PortIP(settingsJsonData["CPU2_IP"]);
              sock_a1_state = true;
              try {
                sock_a1 =
                    await Socket.connect(netData[0], int.parse(netData[1]))
                        .timeout(const Duration(milliseconds: 100));
              } on Exception catch (TimeoutException, SocketException) {
                sock_a1_state = false;
              }
            }
            // portable
            else if (indx == 2) {
              List netData = convertTo_PortIP(settingsJsonData["CPU3_IP"]);

              sockEvent_state = true;
              try {
                sockEvent =
                    await Socket.connect(netData[0], int.parse(netData[1]))
                        .timeout(const Duration(milliseconds: 100));
              } on Exception catch (TimeoutException, SocketException) {
                sockEvent_state = false; 
              }

              if (sockEvent_state) {
                //SettingEventMainData.bcSocket = sockEvent.asBroadcastStream();
                //recivePipeline();
              }
            }
            setState(() {});
          },
          child: const Text('connect'),
          style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 158, 206, 106))),
    ]);
  }

  Row mainInfoIcon() {
    return Row(children: [
      Container(
          color: const Color.fromARGB(255, 24, 24, 24),
          height: 60,
          width: 150,
          // battery chart
          child: SfSparkLineChart(
            color: const Color.fromARGB(255, 158, 206, 106),
            data: SettingEventMainData.battery_chart,
          )),
      const SizedBox(width: 20),
      Icon(sock_d1_state ? Icons.sensors : Icons.sensors_off,
          color: sock_d1_state
              ? const Color.fromARGB(255, 158, 206, 106)
              : Colors.red.shade800,
          size: 30),
      const SizedBox(width: 20),
      Icon(sock_a1_state ? Icons.sensors : Icons.sensors_off,
          color: sock_a1_state
              ? const Color.fromARGB(255, 158, 206, 106)
              : Colors.red.shade800,
          size: 30),
      const SizedBox(width: 20),
      Icon(sockEvent_state ? Icons.sensors : Icons.sensors_off,
          color: sockEvent_state
              ? const Color.fromARGB(255, 158, 206, 106)
              : Colors.red.shade800,
          size: 30),
    ]);
  }

  Row setCpu(indx) {
    return Row(children: [
      Text('cpu: ' + (indx + 1).toString() + ' IP: ',
          style: const TextStyle(color: Colors.white, fontSize: 17)),
      SizedBox(
          width: 200,
          height: 30,
          child: TextFormField(
              controller: controllersIP[indx],
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  filled: true,
                  fillColor: Colors.white))),

      const SizedBox(width: 5),

      Checkbox(
        activeColor: Colors.green,
        value: autoConnect[indx],
        onChanged: (bool? value) {
          setState(() {
            autoConnect[indx] = value!;
          });
        },
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (startRefresh == true) {
      refreshData();
      startRefresh = false;
    }

    /*if (SettingEventMainData.devModeState &&
        SettingEventMainData.listen_thread != null &&
        open_page) {
      recivePipeline();
    }*/
    open_page = false;

    return Scaffold(
      drawer: drawer_nav(context, 3),
      body: Container(
        color: const Color.fromARGB(255, 36, 39, 53),
        child: Column(children: [
          const SizedBox(height: 35),
          Row(children: [
            const Text('Battery chart:  ',
                style: TextStyle(
                    color: Color.fromARGB(255, 158, 206, 106), fontSize: 13)),
            Text((SettingEventMainData.voltage / 10).toString() + 'V  ',
                style: TextStyle(
                    color: low_battery
                        ? const Color.fromARGB(255, 255, 0, 0)
                        : const Color.fromARGB(255, 158, 206, 106),
                    fontSize: 13)),
            Text(((SettingEventMainData.current / 10) + 0.1).toString() + 'A  ',
                style: const TextStyle(
                    color: Color.fromARGB(255, 158, 206, 106), fontSize: 13)),
            Text(battery_mode[SettingEventMainData.indx_battery + 1],
                style: const TextStyle(
                    color: Color.fromARGB(255, 158, 206, 106), fontSize: 13))
          ]),
          mainInfoIcon(),
          const SizedBox(height: 10),
          setCpu(0),
          const SizedBox(height: 15),
          setCpu(1),
          const SizedBox(height: 15),
          setCpu(2),
          const SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 158, 206, 106)),
              onPressed: () async {
                var dataSend = {
                  "CPU1_IP": controllersIP[0].text,
                  "CPU2_IP": controllersIP[1].text,
                  "CPU3_IP": controllersIP[2].text,
                  "CPU1_AUTO-CONNECT": autoConnect[0].toString(),
                  "CPU2_AUTO-CONNECT": autoConnect[1].toString(),
                  "CPU3_AUTO-CONNECT": autoConnect[2].toString()
                };
                await fileSettings.writeAsString(jsonEncode(dataSend));
                settingsJsonData =
                    jsonDecode(await fileSettings.readAsString(encoding: utf8));
                refreshData();
              },
              child: const Text('save and set'),
            ),
          ]),
          const SizedBox(height: 20),
          connectButtons(0), // addressable
          connectButtons(1), // analog
          connectButtons(2), // portable
          const SizedBox(height: 30),

        ]),
      ),
    );
  }
}
