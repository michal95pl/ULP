#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#include "oled.h"

Adafruit_SSD1306 display(128, 32, &Wire, -1);

void oled_begin() 
{
  Wire.begin(6, 7);
  display.begin(SSD1306_SWITCHCAPVCC, 0x3C);
  display.setRotation(2);
}

void oled_startPage() 
{
  display.clearDisplay();
  display.setTextSize(4);
  display.setTextColor(WHITE);
  display.setCursor(35, 5);
  display.println("ULP");
  display.display();

  delay(1000);

  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(10, 5);
  display.println("made and design by");
  display.setCursor(10, 20);
  display.println("Michal Lichtarski");
  display.display();

  delay(1000);
  display.clearDisplay();

  display.setCursor(0, 5);
  display.println("running led thread...");
  display.display();
}

void clear_oled()
{
  display.clearDisplay();
  display.display();
}



bool connection_state_mem = true;
bool connection_state = false;

void oled_connection_state() 
{
  if (connection_state != connection_state_mem) 
  {
    display.fillRect(0, 5, 128, 10, BLACK);
    display.setTextSize(1);
    display.setCursor(0, 5);

    if (connection_state)
      display.println("connected");
    else
      display.println("disconnected");

    display.display();
    connection_state_mem = connection_state;
  }
}



uint8_t mode_mem = 0; // default value
uint8_t mode = 1;

void oled_mode_selection()
{

  if (mode_mem != mode)
  {
    display.fillRect(0, 15, 128, 17, BLACK);
    display.setTextSize(2);
    display.setCursor(0, 15);

    switch(mode) 
    {
      case 1: {display.println("color"); break;}
      case 2: {display.println("gradient"); break;}
      case 3: {display.println("rainbow"); break;}
      case 7: {display.println("cross"); break;}
    }

    display.display();
    mode_mem = mode;
  }
}

// oled in 1 thread (avoid sync threads)
void oled_loop()
{
  oled_connection_state();
  oled_mode_selection();
}

// setters
void set_mode(uint8_t m) { mode = m + 1;} // increment by 1, because default value is 0
void set_connection_state(bool s) { connection_state = s;}
