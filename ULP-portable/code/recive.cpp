#include <FastLED.h>
#include "recive.h"

/* ########## translator ##########

  _ - reserved for additionall adress

  SG__ - strip gain
  DG__ - display gain
  SEF_ - strip effect speed
  SMC_ - strip main color
  SGCF - strip gradient color first
  SGCS - strip gradient color second
  SM__ - strip mode
  SSR_ - strip speed rainbow
  SSC_ - strip speed cross
  DST_ - display set text
  DSTC - display set text colour

*/ 

uint8_t strip_mode = 0;
CRGB strip_main_color = CRGB(0,0,0);
CRGB strip_first_gradientColor = CRGB(255,0,0);
CRGB strip_second_gradientColor = CRGB(0,0,255);
uint8_t effects_speed[] = {50, 50};
uint8_t display_brightness = 26;
uint8_t strip_brightness = 255;
CRGB display_text_color = CRGB(50, 50, 50);

void strip_decode (uint16_t data[], uint16_t length) {

  if (length > 4) {
    if (data[0] == 'S' && data[1] == 'M' && data[2] == 'C' && data[3] == '_')
      strip_main_color.setRGB(data[4], data[5], data[6]);
       
    else if (data[0] == 'S' && data[1] == 'G' && data[2] == 'C' && data[3] == 'F')
      strip_first_gradientColor.setRGB(data[4], data[5], data[6]);

    else if (data[0] == 'S' && data[1] == 'G' && data[2] == 'C' && data[3] == 'S')
      strip_second_gradientColor.setRGB(data[4], data[5], data[6]);

    else if (data[0] == 'S' && data[1] == 'M' && data[2] == '_' && data[3] == '_')
      strip_mode = data[4];

    else if (data[0] == 'S' && data[1] == 'S' && data[2] == 'R' && data[3] == '_')
      effects_speed[0] = data[4];
    
    else if (data[0] == 'S' && data[1] == 'S' && data[2] == 'C' && data[3] == '_')
      effects_speed[1] = data[4];
    
    else if (data[0] == 'S' && data[1] == 'G' && data[2] == '_' && data[3] == '_')
      strip_brightness = data[4];

    else if (data[0] == 'D' && data[1] == 'G' && data[2] == '_' && data[3] == '_')
      display_brightness = data[4];
    
    else if (data[0] == 'D' && data[1] == 'S' && data[2] == 'T' && data[3] == 'C')
      display_text_color.setRGB(data[4], data[5], data[6]);
  }

}