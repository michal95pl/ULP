// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class LedWidget {
  
  static String _setEventMode = "Color";
  static final List _eventModes = ['Color', 'Gradient', 'Rainbow', 'WDB', 'POL', 'STR', 'CRR'];
  static bool _colorChannel = true;

  static int _sliderStripGainValue = 255;
  static final List _sliderSpeedValue = [100, 100];

  static String intToString(int number) {
    String data = "";

    for (int i=0; i < (3 - number.toString().length); i++) {
      data += "0";
    }

    data += number.toString();

    return data;

  }

  static Expanded changeModeButton(var page, var sockEvent, bool sockEventState) {
    return Expanded(child:
      DropdownButton<String>(
        dropdownColor: const Color.fromARGB(255, 28, 28, 28),
        value: _setEventMode,
        icon: (_setEventMode == "Color")? const Icon(Icons.construction) : const Icon(Icons.whatshot, color: Color.fromARGB(255, 255, 81, 0)),
        elevation: 16,
        style: const TextStyle(color: Color.fromARGB(255, 158, 206, 106)),

        underline: Container(
          height: 2,
          color: const Color.fromARGB(255, 255, 0, 119),
        ),

        onChanged: sockEventState ? 
          (String? newValue) {
            _setEventMode = newValue!;
            sockEvent.write("SM__" + intToString(_eventModes.indexOf(_setEventMode)) + "k");
              page.setState(() {});
          } : null,

        items: <String>['Color', 'Gradient', 'Rainbow', 'WDB', 'POL', 'STR', 'CRR'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),

      )
    );
  }

  static Expanded sliderBrightness(var page, var sockEvent, bool sockEventState) {
    return Expanded(flex: 0, child:
      SizedBox(
          height: 350,
          child: SfSliderTheme(
              data: SfSliderThemeData(
                activeTickColor: Colors.blue,
              ),
              child: SfSlider.vertical(
                value: _sliderStripGainValue,
                onChanged: sockEventState
                    ? (dynamic value) async {
                        _sliderStripGainValue = value.toInt();
                        await sockEvent.write("SG__" +
                            intToString(_sliderStripGainValue) +
                            "k");
                        page.setState(() {});
                      }
                    : null,
                min: 0.0,
                max: 255.0,
                stepSize: 15,
                interval: 15,
                showTicks: true,
                activeColor: Colors.blue,
              )))
    );
  }

  /// idSend <- id effects (name of effects)
  static Expanded sliderSpeed(var page, var sockEvent, bool sockEventState) {
    return Expanded(flex: 0, child:
      SizedBox(
          height: 350,
          child: SfSliderTheme(
              data: SfSliderThemeData(
                activeTickColor: Colors.blue,
              ),
              child: SfSlider.vertical(
                value: _setEventMode == 'Rainbow'? _sliderSpeedValue[0] :  _sliderSpeedValue[1],
                onChanged: sockEventState && (_setEventMode == 'Rainbow' || _setEventMode == 'CRR')
                    ? (dynamic value) async {

                        if (_setEventMode == 'Rainbow') {
                          _sliderSpeedValue[0] = value.toInt();
                          await sockEvent.write('SSR_' +
                                intToString(_sliderSpeedValue[0]) +
                                "k");
                        } else if (_setEventMode == 'CRR') {
                          _sliderSpeedValue[1] = value.toInt();
                          await sockEvent.write('SSC_' +
                                intToString(_sliderSpeedValue[1]) +
                                "k");
                        }
                        page.setState(() {});
                      }
                    : null,
                min: 0.0,
                max: 150.0,
                stepSize: 10,
                interval: 10,
                showTicks: true,
                activeColor: Colors.blue,
              )))
    );
  }

  // first / second color
  static Expanded colorModeButton(var page, bool active) {
    return  Expanded(child:
      ElevatedButton(
        onPressed: active? null : (){
          _colorChannel = !_colorChannel;
          page.setState(() {});
        },
        child: const Text('ChM'),
        style: ElevatedButton.styleFrom(
          backgroundColor: _colorChannel? const Color.fromARGB(255, 0, 195, 255) : const Color.fromARGB(255, 187, 0, 255), // background
        )
      )
    );

  }

  /// true -> first color,
  /// false -> second color
  static bool getColorChannel() {
    return _colorChannel;
  }

  /// get led strip effect mode: 'Color', 'Gradient', 'Rainbow', 'WDB', 'POL', 'STR', 'CRR'
  static String getEventMode() {
    return _setEventMode;
  }

}