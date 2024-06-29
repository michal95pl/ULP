#ifndef LM75_H

  #define LM75_H

  #define LM75_ADDRESS 0x4B

  #include <Wire.h>

  float readTemperature(TwoWire* wire);

#endif