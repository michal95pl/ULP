// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'dart:io';

class PixelPainter extends CustomPainter {
  
  // [page number][y][x][r,g,b]
  static var display_buffor = List.generate(4, (i) => List.generate(8, (i) =>  List.generate(8, (i) => [0,0,0], growable: false),  growable: false), growable: false);
  

  static int _page_number = 0;

  static int getPageNumber() {
    return _page_number;
  }

  static Row show() {
    return Row(children: [
      SizedBox(
        height: 320,
        child: CustomPaint(foregroundPainter: PixelPainter())
      )
    ]);
  }

  static Expanded changePageButton(var page) {
    return Expanded(child:
      ElevatedButton(onPressed: (){
        _page_number == 3? _page_number=0 : _page_number++;
        page.setState(() {});
      },
        child: Text( (_page_number + 1).toString() ),
      )
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

  static Expanded sendButton(var page, var sockEvent, bool sockEventState) {
    return Expanded(child:
      ElevatedButton(onPressed: sockEventState
                    ? () {
                        String dataa = "DBFD";
    
                        for (int y=0; y < 8; y++) {
                          for (int s=0; s < 4; s++) {
                            for (int x=0; x < 8; x++) {
                              dataa += intToString(display_buffor[s][y][x][0].toInt());
                              dataa += intToString(display_buffor[s][y][x][1].toInt());
                              dataa += intToString(display_buffor[s][y][x][2].toInt());
                            }
                          }
                        }

                        sockEvent.write(dataa + "k");
                      
                        page.setState(() {});
                      }
                    : null,
                  
        child: const Text("Snd"),
      )
    );
  }
  

  @override
  void paint(Canvas canvas, Size size) {
    
    double y1 = 0, y2 = 35;
    for (int j = 0; j < 8; j++) {
      double x1 = 0, x2 = 35;
      for (int i = 0; i < 8; i++) {
        var paint1 = Paint()..color = Color.fromARGB(255, display_buffor[_page_number][j][i][0], display_buffor[_page_number][j][i][1], display_buffor[_page_number][j][i][2]);
        canvas.drawRect(Rect.fromLTRB(x1, y1, x2, y2), paint1);
        x2 += 40;
        x1 += 40;
      }
      y1 += 40;
      y2 += 40;
    }

  }

  @override
  bool shouldRepaint(PixelPainter oldDelegate) {
    return true;
  }

  static int numberFile = 0;

  static void loadFile(int number) async {
    final dirPath = await getApplicationDocumentsDirectory();
    final path = dirPath.path;
    File file = File('$path/d$number.bin');

    Uint8List data = file.readAsBytesSync();

    int i=0;

    for (int p=0; p < 4; p++) {
      for (int y=0; y < 8; y++) {
        for (int x=0; x < 8; x++) {
          display_buffor[p][y][x][0] = data[i++];
          display_buffor[p][y][x][1] = data[i++];
          display_buffor[p][y][x][2] = data[i++];
        }
      }
    }
    
  }

  static void saveFile(int number) async {
    
    final dirPath = await getApplicationDocumentsDirectory();
    final path = dirPath.path;
    File file = File('$path/d$number.bin');

    Uint8List data = Uint8List(768);

    int i=0;

    for (int p=0; p < 4; p++) {
      for (int y=0; y < 8; y++) {
        for (int x=0; x < 8; x++) {
          data[i++] = display_buffor[p][y][x][0];
          data[i++] = display_buffor[p][y][x][1];
          data[i++] = display_buffor[p][y][x][2];
        }
      }
    }

    file.writeAsBytes(data);

  }

  static Row saveDisplayWidgets(var page) {
    return Row(children: [
      ElevatedButton(
        child: const Text("load"),
        onPressed: (){
          PixelPainter.loadFile(numberFile);
        }), 

        ElevatedButton(
          child: const Text("save"),
          onPressed: (){
            PixelPainter.saveFile(numberFile);
        }),

        ElevatedButton(
          child: Text("F " + numberFile.toString()),
          onPressed: (){
            numberFile++;
            if (numberFile >= 4){numberFile = 0;}
            page.setState(() {});
        }),

    ]);
  }

}


class DisplayTools {

  static bool _set_pixel_mode = false;

  static HSVColor color_pixel = HSVColor.fromColor(const Color.fromARGB(255, 0, 0, 0));

  static int sliderBrightnessValue = 15;

  static String intToString(int number) {
    String data = "";

    for (int i=0; i < (3 - number.toString().length); i++) {
      data += "0";
    }

    data += number.toString();

    return data;

  }

  static void pixelPaint (TapDownDetails details, var page) async {
    int x = -1, y = -1;
    
    if (details.globalPosition.dy >= 50 &&
        details.globalPosition.dy <= 365 &&
        details.globalPosition.dx >= 0 &&
        details.globalPosition.dx <= 315) {
      int y1 = 50, y2 = 85;

      for (y = 0; y < 8; y++) {
        if (details.globalPosition.dy >= y1 &&
            details.globalPosition.dy <= y2) {
          int x1 = 0, x2 = 35;
          for (x = 0; x < 8; x++) {
            if (details.globalPosition.dx >= x1 &&
                details.globalPosition.dx <= x2) {
              break;
            }
            x1 += 40;
            x2 += 40;
          }
          break;
        }
        y1 += 40;
        y2 += 40;
      }
    }

    if (_set_pixel_mode && x != -1 && y != -1 && x < 8 && y < 8) {
      PixelPainter.display_buffor[ PixelPainter.getPageNumber() ][ y ][ x ][ 0 ] = color_pixel.toColor().red;
      PixelPainter.display_buffor[ PixelPainter.getPageNumber() ][ y ][ x ][ 1 ] = color_pixel.toColor().green; 
      PixelPainter.display_buffor[ PixelPainter.getPageNumber() ][ y ][ x ][ 2 ] = color_pixel.toColor().blue;
      page.setState(() {});
    }
    
  }

  static Expanded pixel_mode_button(var page) {
    return Expanded(child:
      ElevatedButton(
        onPressed: (){
          _set_pixel_mode = !_set_pixel_mode;
          page.setState(() {});
        },
        child: const Text('PX'),
        style: ElevatedButton.styleFrom(
        backgroundColor: _set_pixel_mode? const Color.fromARGB(255, 21, 255, 0) : const Color.fromARGB(255, 255, 0, 0), // background
      ))
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
                value: sliderBrightnessValue,
                onChanged: sockEventState
                    ? (dynamic value) async {
                        sliderBrightnessValue = value.toInt();
                        //try {
                        await sockEvent.write("DG__" +
                            intToString(sliderBrightnessValue) +
                            "k");
                        page.setState(() {});
                      }
                    : null,
                min: 0.0,
                max: 130.0,
                stepSize: 13,
                interval: 13,
                showTicks: true,
                activeColor: Colors.blue,
              )))
    );
  }

  ///true -> drawing on display
  static bool getPixelMode() {
    return _set_pixel_mode;
  }

}