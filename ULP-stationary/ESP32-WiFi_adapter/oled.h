#ifndef oled_lib
  #define oled_lib

  #include <Wire.h>
  #include <stdint.h>
  #include <Adafruit_SSD1306.h>

  void oled_init();
  void oled_start_effect();
  void main_page(String ip);
  void oled_connected_state(uint8_t state);

#endif