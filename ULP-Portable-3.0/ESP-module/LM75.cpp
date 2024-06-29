#include "LM75.h"

float readTemperature(TwoWire* wire) {

  (*wire).beginTransmission(LM75_ADDRESS);
  (*wire).write(0);
  (*wire).endTransmission();

  (*wire).requestFrom(LM75_ADDRESS, 2);

  while((*wire).available() != 2);

  uint8_t msb = (*wire).read();
  uint8_t lsb = (*wire).read();

  (*wire).endTransmission();

  int16_t temp = (msb << 8) | (lsb);
  temp >>= 7;

  float temperature = temp * 0.5;
  return temperature;
}