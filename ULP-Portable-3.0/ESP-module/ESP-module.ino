#include "LM75.h"

#include <Wire.h>

#include "electronic_management.h"


void setup() {

  Wire.begin(6, 7);

  Serial.begin(115200);
  while (!Serial)
     delay(10);

  init_electronics();

  delay(5000);
}

void loop() {

  uint8_t error_code = manage_electronics(&Wire);

  if (error_code != 0)
   Serial.println(error_code);

}