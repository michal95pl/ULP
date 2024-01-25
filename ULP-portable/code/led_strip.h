#ifndef strip_lib
  #define strip_lib

  void strip_startup_effect1(CRGB displayBuffer[]);
  void strip_startup_effect2(CRGB displayBuffer[]);
  void strip_color(CRGB leds[], CRGB color, uint8_t brightness);
  void gradientCreate(int color1[3], int color2[3]);
  void gradientStatic(CRGB leds[], int color1[3], int color2[3], uint8_t brightness);
  void strip_rainbow(CRGB leds[], int speed, uint8_t brightness);
  void strip_cross(CRGB leds[], int speed, int color1[3], int color2[3], uint8_t brightness);

#endif