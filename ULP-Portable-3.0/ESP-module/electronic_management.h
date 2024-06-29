#ifndef electronic_management_h

  #include "LM75.h"
  #include "esp_system.h"


  #define FAN_ENABLE_PIN 16
  #define BUCK_REGULATOR_5V_ENABLE_PIN 47
  #define CURRENT_FAULT_PIN 38
  #define POWER_DELIVERY_STATUS_PIN 21
  #define POWER_GOOD_5V_BUCK 48
  #define POWER_GOOD_STM32_LDO 5

  /**
    return erorr code:
    0 - OK,
    1 - 5V buck regulator problem,
    2 - STM32 linear regulator problem,
    3 - stm32 not response,
    4 - too high output current (short circuit)
  **/
  uint8_t manage_electronics(TwoWire* wire);

  void init_electronics();

#endif