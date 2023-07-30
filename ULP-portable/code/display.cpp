#include <FastLED.h>
#include "display.h"

CRGB set_display_brightness(CRGB color, uint16_t brightness) {
  uint16_t mult = (brightness * 100) / 255;
  uint16_t temp_color[] = {color.r, color.g, color.b};

  for (uint8_t i=0; i < 3; i++) {
    temp_color[i] = (temp_color[i] * mult) / 100;
  }

  color.r = temp_color[0];
  color.g = temp_color[1];
  color.b = temp_color[2];

  return color;
}

void display_draw_pixel (CRGB displayBuffer[], int x, int y, CRGB color) {

  if(x >= 0 && x <= 31 && y >= 0 && y <= 7) {
    if (x % 2 == 0) {
      int indx = (x / 2 * 15) + (x / 2);
      displayBuffer[indx+y] = color;
    } 

    else {
      int indx = (((x - 1)/2 + 1) * 15) + ((x - 1)/2);
      displayBuffer[indx-y] = color;
    }
  }
}

void display_startup_effect (CRGB displayBuffer[], uint8_t brightness) {

  for (int i=0; i <= 32; i++) {
    for (int j=0; j < 8; j++) {
      display_draw_pixel(displayBuffer, i-1, j, CRGB(0,0,0) );
      display_draw_pixel(displayBuffer, i, j, CRGB(20,20,20));
    }
    delay(10);
    FastLED.show();
  }

  for (int i=31; i >= 0; i--) {
    for (int j=0; j < 8; j++) {
      display_draw_pixel(displayBuffer, i, j, CRGB(0,0,20) );
    }
    delay(7);
    FastLED.show();
  }

  for (int n=20; n >= 0; n--) {
    for (int i=0; i < 32; i++) {
      for (int j=0; j < 8; j++) {
        display_draw_pixel(displayBuffer, i, j, CRGB(0,0,n));
      }
    }
    FastLED.show();
    delay(10);
  }

}

void encode_data(CRGB displayBuffer[], uint16_t data[], uint16_t &length, uint8_t brightness) {

  uint16_t i = 4;

  for (uint8_t y = 0; y < 8 && i < length; y++) {
    for (uint8_t x = 0; x < 32 && i < length; x++) {
      display_draw_pixel(displayBuffer, x, y, set_display_brightness( CRGB(data[i++], data[i++], data[i++]), brightness) );
    }
  }
}





