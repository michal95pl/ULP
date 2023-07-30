// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_print

import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'data_containers.dart';
import 'event_page/ledWidget.dart';
import 'event_page/monitorWidget.dart';

class Event_page extends StatefulWidget {
  const Event_page({Key? key}) : super(key: key);

  @override
  _Event_page createState() => _Event_page();
  
}


class _Event_page extends State<Event_page> {

  static HSVColor _mainColor = HSVColor.fromColor(const Color.fromARGB(255, 0, 0, 0));

  static HSVColor _firstGradientColor = HSVColor.fromColor(const Color.fromARGB(255, 0, 0, 0));
  static HSVColor _secondGradientColor = HSVColor.fromColor(const Color.fromARGB(255, 0, 0, 0));
  
  bool open_page = true;

  // check connection socket 
  Future connection_state() async {
    SettingEventMainData.listen_thread = SettingEventMainData.bcSocket.listen(
      (data) {},
      onDone: () {
        sockEvent_state = false;
        setState(() {});
      },
    );
  }

  static String intToString(int number) {
    String data = "";

    for (int i=0; i < (3 - number.toString().length); i++) {
      data += "0";
    }

    data += number.toString();

    return data;

  }
  
  /// provide color container 
  static HSVColor colorSwitcher(bool displayMode, String ledStripMode) {
    
    if (displayMode) {return DisplayTools.color_pixel;}
    else {

      if (LedWidget.getColorChannel()) {
        switch(ledStripMode) {
          case "Color": return _mainColor;
          case "Gradient": return _firstGradientColor;
          case "CRR": return _firstGradientColor;
          default: return HSVColor.fromColor(const Color.fromARGB(255, 0, 0, 0));  
        }
      } else {
        switch(ledStripMode) {
          case "Color": return _mainColor;
          case "Gradient": return _secondGradientColor;
          case "CRR": return _secondGradientColor;
          default: return HSVColor.fromColor(const Color.fromARGB(255, 0, 0, 0));  
        }
      }
      
    }

  }

  Expanded colorPicker() {
    return Expanded(
      child: PaletteHuePicker(

        color: colorSwitcher(DisplayTools.getPixelMode(), LedWidget.getEventMode()),

        onChanged: (color) {

          // display color
          if (DisplayTools.getPixelMode()) {
            DisplayTools.color_pixel = color;
            setState(() {});
          }

          else if (sockEvent_state && (LedWidget.getEventMode() == "Gradient" || LedWidget.getEventMode() == "CRR")) {
            
            if (LedWidget.getColorChannel()) {
              _firstGradientColor = color;
              setState(() {});
              try {
                sockEvent.write("SGCF" +
                                intToString(_firstGradientColor.toColor().red) + 
                                intToString(_firstGradientColor.toColor().green) +
                                intToString(_firstGradientColor.toColor().blue) +
                                "k"
                                ).timeout(const Duration(milliseconds: 100));
                sockEvent_state = true;
              } on NoSuchMethodError {
                //sockEvent_state = false;
              }
            } 

            else {
              _secondGradientColor = color;
              setState(() {});
              try {
                sockEvent.write("SGCS" +
                                intToString( _secondGradientColor.toColor().red) + 
                                intToString( _secondGradientColor.toColor().green) +
                                intToString( _secondGradientColor.toColor().blue) +
                                "k"
                                ).timeout(const Duration(milliseconds: 100));
                sockEvent_state = true;
              } on NoSuchMethodError {
                //sockEvent_state = false;
              }
            }
            
          }

          // main led strip color
          else if (sockEvent_state && LedWidget.getEventMode() == "Color") {
            _mainColor = color;
            setState(() {});
            try {
              sockEvent.write("SMC_" +
                                intToString(_mainColor.toColor().red) + 
                                intToString(_mainColor.toColor().green) +
                                intToString(_mainColor.toColor().blue) +
                                "k"
                                ).timeout(const Duration(milliseconds: 100));
              sockEvent_state = true;
            } on NoSuchMethodError {
              //sockEvent_state = false;
            }
          }


        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    // check connection while open page
    if ( SettingEventMainData.listen_thread != null && open_page && sockEvent_state ) {
      //SettingEventMainData.bcSocket.close();
      connection_state();
    }
    open_page = false;

    return GestureDetector(
        onTapDown: (details) => DisplayTools.pixelPaint(details, this),
        
        child: Scaffold(
          drawer: drawer_nav(context, 2),

          body: Container(
              color: const Color.fromARGB(255, 36, 39, 53),
              child: Column(children: [

                const SizedBox(height: 50),

                PixelPainter.show(),

                PixelPainter.saveDisplayWidgets(this),

                Row(children: [
                  LedWidget.changeModeButton(this, sockEvent, sockEvent_state),
                  DisplayTools.pixel_mode_button(this),
                  LedWidget.colorModeButton(this, DisplayTools.getPixelMode()),
                  PixelPainter.changePageButton(this),
                  PixelPainter.sendButton(this, sockEvent, sockEvent_state)
                ]),
                
                Row(children: [
                  LedWidget.sliderBrightness(this, sockEvent, sockEvent_state),
                  DisplayTools.sliderBrightness(this, sockEvent, sockEvent_state),
                  LedWidget.sliderSpeed(this, sockEvent, sockEvent_state),
                  colorPicker()
                ])

              ])
          ),
        )
    );
  }
}
