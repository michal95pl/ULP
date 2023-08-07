#include <FastLED.h>

#include "display_parser.h"
#include "display.h"

void display_A(CRGB led_strip[], CRGB color, int x)
{
  
  for (int i=7; i >= 5; i--) 
  {
    display_draw_pixel(led_strip, x, i, color);
    display_draw_pixel(led_strip, x+4, i, color);
  }

  for (int i=x+1; i <= x+3; i++)
    display_draw_pixel(led_strip, i, 6, color);

  display_draw_pixel(led_strip, x+1, 4, color);
  display_draw_pixel(led_strip, x+2, 3, color);
  display_draw_pixel(led_strip, x+3, 4, color);
}

void display_B(CRGB led_strip[], CRGB color, int x)
{
  for (int i=7; i >= 3; i--)
    display_draw_pixel(led_strip, x, i, color);

  for (int i=x+1; i <= x+3; i++)
  {
    display_draw_pixel(led_strip, i, 7, color);
    display_draw_pixel(led_strip, i, 5, color);
    display_draw_pixel(led_strip, i, 3, color);
  }
  display_draw_pixel(led_strip, x+4, 4, color);
  display_draw_pixel(led_strip, x+4, 6, color);
}

void display_C(CRGB led_strip[], CRGB color, int x)
{

  for (int i=6; i >= 4; i--)
    display_draw_pixel(led_strip, x, i, color);

  for (int i=x+1; i <= x+4; i++)
  {
    display_draw_pixel(led_strip, i, 7, color);
    display_draw_pixel(led_strip, i, 3, color);
  }
}


void show_char(CRGB led_strip[], CRGB color, int x, char character)
{
  if (x > 0)
    switch(character){
      case 'A': {display_A(led_strip, color, x); break;}
      case 'B': {display_B(led_strip, color, x); break;}
      case 'C': {display_C(led_strip, color, x); break;}
    }
}

uint64_t timer_save = 0;
int x_slider = 0;

void show_text(CRGB led_strip[], CRGB color, char data[])
{

  if ((millis() - timer_save) >= 120)
  {
    display_clear(led_strip);

    int x = x_slider;
    for (int i=0; data[i] != 'k'; i++)
    {
      if (data[i] >= 'A' && data[i] <= 'Z')
      {
        show_char(led_strip, color, x, data[i]);
        x += 6;
      }
    }
    x_slider -= 1;
    timer_save = millis();

    FastLED.show();

    if (x_slider < 32)
      x_slider = 0;
  }
  
}