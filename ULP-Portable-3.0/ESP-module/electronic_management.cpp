#include "electronic_management.h"

// contains time when fan turned on
uint32_t fan_timer = 0;
uint32_t buck_regulator_timer = 0;
uint8_t buck_regulator_enable = 0;

void temperature_protection(TwoWire* wire)
{
  float esp_temp = temperatureRead();
  float pcb_temp = readTemperature(wire);

  if (esp_temp >= 50 || pcb_temp >= 50) 
  {
    digitalWrite(FAN_ENABLE_PIN, 1);
    fan_timer = millis();
  }
  // fan is enable at least 5s
  else if ((millis() - fan_timer) >= 5000)
  {
    digitalWrite(FAN_ENABLE_PIN, 0);
  }
}

uint8_t check_electronics()
{
  // run 5v power rail
  if (!digitalRead(POWER_DELIVERY_STATUS_PIN))
  {
    digitalWrite(BUCK_REGULATOR_5V_ENABLE_PIN, 1);
    buck_regulator_enable = 1;
    buck_regulator_timer = millis();
  }
  else
  {
    digitalWrite(BUCK_REGULATOR_5V_ENABLE_PIN, 0);
    buck_regulator_enable = 0;
  }


  if (!digitalRead(CURRENT_FAULT_PIN))
  {
    digitalWrite(BUCK_REGULATOR_5V_ENABLE_PIN, 0);
    return 4;
  }

  // wait 2s after run buck regulator to check if works
  if (buck_regulator_enable && !digitalRead(POWER_GOOD_5V_BUCK) && (millis() - buck_regulator_timer) > 2000)
  {
    digitalWrite(BUCK_REGULATOR_5V_ENABLE_PIN, 0);
    return 1;
  }

  if (buck_regulator_enable)
  {
    if (!digitalRead(POWER_GOOD_STM32_LDO) && (millis() - buck_regulator_timer) > 2000)
      return 2;
  }
  else if (!digitalRead(POWER_GOOD_STM32_LDO))
  {
    return 2;
  }    

  return 0;
}

uint8_t manage_electronics(TwoWire* wire)
{
  temperature_protection(wire);

  return check_electronics();
}

void init_electronics()
{
  pinMode(FAN_ENABLE_PIN, OUTPUT);
  pinMode(BUCK_REGULATOR_5V_ENABLE_PIN, OUTPUT);
  pinMode(CURRENT_FAULT_PIN, INPUT_PULLDOWN);
  pinMode(POWER_DELIVERY_STATUS_PIN, INPUT_PULLDOWN);
  pinMode(POWER_GOOD_5V_BUCK, INPUT_PULLDOWN);
  pinMode(POWER_GOOD_STM32_LDO, INPUT_PULLDOWN);
}