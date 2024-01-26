import 'package:flutter/material.dart';

import 'main.dart';

class Start_app extends StatefulWidget {
  const Start_app({Key? key}) : super(key: key);

  @override
  _Start_app createState() => _Start_app();
}

// ignore: camel_case_types
class _Start_app extends State<Start_app> {
  int lenJson = 0;
  Row TxtJson(String text) {
    return Row(children: [
      const SizedBox(height: 20),
      const Text(' - ',
          style: TextStyle(
              fontSize: 30, color: Color.fromARGB(255, 187, 154, 247))),
      Text(text,
          style: const TextStyle(
              fontSize: 15, color: Color.fromARGB(255, 39, 195, 222)))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    try {
      lenJson = (NewVersionData["added"] as Map<String, dynamic>).length;
    } catch (e) {
      showJson = false;
    }

    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage('background.jpg'), fit: BoxFit.cover),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
              Text('ULP', style: TextStyle(fontSize: 90, color: Colors.white))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
              Text('Made and designed by Michał Lichtarski \n for wypas impry',
                  style: TextStyle(fontSize: 10, color: Colors.white))
            ]),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showJson == true)
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 36, 40, 59)
                            .withOpacity(0.8),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              NewVersionData["main-text"],
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 69, 166, 222)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        for (int i = 1; i <= lenJson; i++)
                          TxtJson(NewVersionData["added"][i.toString()]),
                      ],
                    ),
                  )
              ],
            ),
            if (showJson == true) const SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blue.shade900),
                onPressed: () {
                  Navigator.pushNamed(context, '/eventPage');
                },
                child: const Text('    open    '),
              ),
            ]),
          ])),
    );
  }
}
