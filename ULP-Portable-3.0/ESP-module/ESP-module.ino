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

  float current_real = 0;

  for (uint8_t i=0; i < 5; i++)
  {
    float voltage = analogRead(8) * (3.3/4095.0);
    float current = 9.226 * voltage - 14.946;
    current_real += current;
    delay(100);
  }
  
  Serial.println(current_real / 5);

  delay(500);

}