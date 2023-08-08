#include <FastLED.h>

#include "display_parser.h"
#include "display.h"

// todo:
void draw_line(CRGB led_strip[], CRGB color, uint8_t x1, uint8_t y1, uint8_t x2, uint8_t y2)
{
  // ver
  if (x1 == x2)
  {

  }
  // hor
  else if (y1 == y2)
  {
    
  }
}

void display_A(CRGB led_strip[], CRGB color, int x)
{
  draw_line(led_strip, color, x, 7, x, 5);
  draw_line(led_strip, color, x+1, 6, x+3, 6);
  draw_line(led_strip, color, x+4, 7, x+4, 5);
  display_draw_pixel(led_strip, x+1, 4, color);
  display_draw_pixel(led_strip, x+2, 3, color);
  display_draw_pixel(led_strip, x+3, 4, color);
}

void display_B(CRGB led_strip[], CRGB color, int x)
{
  draw_line(led_strip, color, x, 7, x, 3);
  draw_line(led_strip, color, x+1, 7, x+3, 7);
  draw_line(led_strip, color, x+1, 5, x+3, 5);
  draw_line(led_strip, color, x+1, 4, x+3, 4);
  display_draw_pixel(led_strip, x+4, 6, color);
  display_draw_pixel(led_strip, x+4, 4, color);
}

void display_C(CRGB led_strip[], CRGB color, int x)
{

  draw_line(led_strip, color, x, 6, x, 4);
  draw_line(led_strip, color, x+1, 7, x+4, 7);
  draw_line(led_strip, color, x+1, 3, x+4, 3);
}

void display_D(CRGB led_strip[], CRGB color, int x)
{
  draw_line(led_strip, color, x, 7, x, 3);
  draw_line(led_strip, color, x+1, 7, x+3, 7);
  draw_line(led_strip, color, x+1, 3, x+3, 3);
  draw_line(led_strip, color, x+4, 6, x+4, 4);
}

void display_E(CRGB led_strip[], CRGB color, int x)
{
  draw_line(led_strip, color, x, 7, x, 3);
  draw_line(led_strip, color, x+1, 7, x+4, 7);
  draw_line(led_strip, color, x+1, 5, x+2, 5);
  draw_line(led_strip, color, x+1, 3, x+4, 3);
}

void display_F(CRGB led_strip[], CRGB color, int x)
{
    draw_line(led_strip, color, x, 7, x, 3);
    draw_line(led_strip, color, x+1, 5, x+2, 5);
    draw_line(led_strip, color, x+1, 3, x+4, 3);
}

void display_G(CRGB led_strip[], CRGB color, int x)
{
    draw_line(led_strip, color, x, 6, x, 4);
    draw_line(led_strip, color, x+1, 7, x+4, 7);
    draw_line(led_strip, color, x+1, 3, x+4, 3);
    draw_line(led_strip, color, x+4, 6, x+4, 5);
    display_draw_pixel(led_strip, x+3, 2, color);
}

void display_H(CRGB led_strip[], CRGB color, int x)
{
    draw_line(led_strip, color, x, 7, x, 3);
    draw_line(led_strip, color, x+4, 7, x+4, 3);
    draw_line(led_strip, color, x+1, 5, x+3, 5);
}

void display_I(CRGB led_strip[], CRGB color, int x)
{
    draw_line(led_strip, color, x, 7, x+4, 7);
    draw_line(led_strip, color, x, 3, x+4, 3);
    draw_line(led_strip, color, x+2, 6, x+2, 4);
}

void display_J(CRGB led_strip[], CRGB color, int x)
{
    display_draw_pixel(led_strip, x, 6, color);
    draw_line(led_strip, color, x+1, 7, x+2, 7);
    draw_line(led_strip, color, x+3, 6, x+3, 4);
    draw_line(led_strip, color, x, 3, x+4, 3);
}

void display_K(CRGB led_strip[], CRGB color, int x)
{
    draw_line(led_strip, color, x, 7, x, 3);
    draw_line(led_strip, color, x+1, 5, x+2, 5);
    display_draw_pixel(led_strip, x+3, 4, color);
    display_draw_pixel(led_strip, x+3, 6, color);
    display_draw_pixel(led_strip, x+4, 3, color);
    display_draw_pixel(led_strip, x+4, 7, color);
}

void display_L(CRGB led_strip[], CRGB color, int x)
{
    draw_line(led_strip, color, x, 7, x+4, 7);
    draw_line(led_strip, color, x, 6, x, 3);
}

void display_M(CRGB led_strip[], CRGB color, int x)
{
  draw_line(led_strip, color, x, 7, x, 3);
  draw_line(led_strip, color, x+4, 7, x+4, 3);
  display_draw_pixel(led_strip, x+1, 4, color);
  display_draw_pixel(led_strip, x+2, 5, color);
  display_draw_pixel(led_strip, x+3, 4, color);
}

void display_N(CRGB led_strip[], CRGB color, int x)
{
  draw_line(led_strip, color, x, 7, x, 3);
  draw_line(led_strip, color, x+4, 7, x+4, 3);
  display_draw_pixel(led_strip, x+1, 4, color);
  display_draw_pixel(led_strip, x+2, 5, color);
  display_draw_pixel(led_strip, x+3, 6, color);
}

void display_O(CRGB led_strip[], CRGB color, int x)
{
  draw_line(led_strip, color, x+1, 7, x+3, 7);
  draw_line(led_strip, color, x+1, 3, x+3, 3);
  draw_line(led_strip, color, x, 6, x, 4);
  draw_line(led_strip, color, x+4, 6, x+4, 4);
}

void display_P(CRGB led_strip[], CRGB color, int x)
{
  draw_line(led_strip, color, x, 7, x, 3);
  draw_line(led_strip, color, x+1, 5, x+3, 5);
  draw_line(led_strip, color, x+1, 3, x+3, 3);
  display_draw_pixel(led_strip, x+4, 4, color);
}

void display_Q(CRGB led_strip[], CRGB color, int x)
{
  draw_line(led_strip, color, x, 6, x, 4);
  draw_line(led_strip, color, x+1, 7, x+2, 7);
  draw_line(led_strip, color, x+1, 3, x+3, 3);
  draw_line(led_strip, color, x+4, 5, x+4, 4);
  display_draw_pixel(led_strip, x+2, 5, color);
  display_draw_pixel(led_strip, x+3, 6, color);
  display_draw_pixel(led_strip, x+4, 7, color);
}

void display_R(CRGB led_strip[], CRGB color, int x)
{
  draw_line(led_strip, color, x, 7, x, 3);
  draw_line(led_strip, color, x+1, 5, x+3, 5);
  draw_line(led_strip, color, x+1, 3, x+3, 3);
  draw_line(led_strip, color, x+4, 7, x+4, 6);
  display_draw_pixel(led_strip, x+4, 4, color);
}

void display_S(CRGB led_strip[], CRGB color, int x)
{
  draw_line(led_strip, color, x, 7, x+3, 7);
  draw_line(led_strip, color, x+1, 5, x+3, 5);
  draw_line(led_strip, color, x+1, 3, x+4, 3);
  display_draw_pixel(led_strip, x+4, 6, color);
  display_draw_pixel(led_strip, x, 4, color);
}

void display_T(CRGB led_strip[], CRGB color, int x)
{
  draw_line(led_strip, color, x+2, 7, x+2, 4);
  draw_line(led_strip, color, x, 3, x+4, 3);
}

void display_U(CRGB led_strip[], CRGB color, int x)
{
  draw_line(led_strip, color, x, 6, x, 3);
  draw_line(led_strip, color, x+1, 7, x+3, 7);
  draw_line(led_strip, color, x+4, 6, x+4, 3);
}

void display_V(CRGB led_strip[], CRGB color, int x)
{
  draw_line(led_strip, color, x, 5, x, 3);
  draw_line(led_strip, color, x+4, 5, x+4, 3);
  display_draw_pixel(led_strip, x+1, 6, color);
  display_draw_pixel(led_strip, x+2, 7, color);
  display_draw_pixel(led_strip, x+3, 6, color);
}

void display_W(CRGB led_strip[], CRGB color, int x)
{
  draw_line(led_strip, color, x, 7, x, 3);
  draw_line(led_strip, color, x+4, 7, x+4, 3);
  display_draw_pixel(led_strip, x+1, 6, color);
  display_draw_pixel(led_strip, x+2, 5, color);
  display_draw_pixel(led_strip, x+3, 6, color);
}

void display_X(CRGB led_strip[], CRGB color, int x)
{
  display_draw_pixel(led_strip, x, 7, color);
  display_draw_pixel(led_strip, x, 3, color);
  display_draw_pixel(led_strip, x+1, 6, color);
  display_draw_pixel(led_strip, x+1, 4, color);
  display_draw_pixel(led_strip, x+2, 5, color);
  display_draw_pixel(led_strip, x+3, 6, color);
  display_draw_pixel(led_strip, x+3, 4, color);
  display_draw_pixel(led_strip, x+4, 7, color);
  display_draw_pixel(led_strip, x+4, 3, color);
}

void display_Y(CRGB led_strip[], CRGB color, int x)
{
  draw_line(led_strip, color, x+2, 7, x+2, 5);
  display_draw_pixel(led_strip, x, 3, color);
  display_draw_pixel(led_strip, x+1, 4, color);
  display_draw_pixel(led_strip, x+3, 4, color);
  display_draw_pixel(led_strip, x+4, 3, color);
}

void display_Z(CRGB led_strip[], CRGB color, int x)
{
  draw_line(led_strip, color, x, 7, x+4, 7);
  draw_line(led_strip, color, x, 4, x+4, 4);
  display_draw_pixel(led_strip, x+1, 6, color);
  display_draw_pixel(led_strip, x+2, 5, color);
  display_draw_pixel(led_strip, x+3, 4, color);
}

void show_char(CRGB led_strip[], CRGB color, int x, char character)
{
  switch(character){
    case 'A': {display_A(led_strip, color, x); break;}
    case 'B': {display_B(led_strip, color, x); break;}
    case 'C': {display_C(led_strip, color, x); break;}
    case 'D': {display_D(led_strip, color, x); break;}
    case 'E': {display_E(led_strip, color, x); break;}
    case 'F': {display_F(led_strip, color, x); break;}
    case 'G': {display_G(led_strip, color, x); break;}
    case 'H': {display_H(led_strip, color, x); break;}
    case 'I': {display_I(led_strip, color, x); break;}
    case 'J': {display_J(led_strip, color, x); break;}
    case 'K': {display_K(led_strip, color, x); break;}
    case 'L': {display_L(led_strip, color, x); break;}
    case 'M': {display_M(led_strip, color, x); break;}
    case 'N': {display_N(led_strip, color, x); break;}
    case 'O': {display_O(led_strip, color, x); break;}
    case 'P': {display_P(led_strip, color, x); break;}
    case 'Q': {display_Q(led_strip, color, x); break;}
    case 'R': {display_R(led_strip, color, x); break;}
    case 'S': {display_S(led_strip, color, x); break;}
    case 'T': {display_T(led_strip, color, x); break;}
    case 'U': {display_U(led_strip, color, x); break;}
    case 'V': {display_V(led_strip, color, x); break;}
    case 'W': {display_W(led_strip, color, x); break;}
    case 'X': {display_X(led_strip, color, x); break;}
    case 'Y': {display_Y(led_strip, color, x); break;}
    case 'Z': {display_Z(led_strip, color, x); break;}
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
