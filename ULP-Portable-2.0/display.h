#ifndef display_lib
  #define display_lib

  void display_draw_pixel (CRGB displayBuffer[], int x, int y, CRGB color);
  void display_startup_effect (CRGB displayBuffer[], uint8_t brightness);
  void encode_data(CRGB displayBuffer[], uint16_t data[], uint16_t &length, uint8_t brightness);
  void display_clear(CRGB displayBuffer[]);
  
#endif