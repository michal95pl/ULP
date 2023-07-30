#ifndef recive_lib
  #define recive_lib

  extern uint8_t strip_mode;
  extern CRGB strip_main_color;
  extern CRGB strip_first_gradientColor;
  extern CRGB strip_second_gradientColor;
  extern uint8_t display_brightness;
  extern uint8_t strip_brightness;
  //0 -> rainbow, 1 -> cross
  extern uint8_t effects_speed[];

  void strip_decode(uint16_t data[], uint16_t length);

#endif