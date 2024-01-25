#include "oled.h"

Adafruit_SSD1306 display(128, 64, &Wire, -1);

void oled_init() 
{
  if(!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
    while(1);
  }
}

void oled_start_effect()
{
  display.clearDisplay();
  display.setTextColor(WHITE);
  display.setCursor(20, 17);
  display.setTextSize(5);
  display.print("ULP");
  display.display();

  delay(3000);
  display.clearDisplay();
  display.setCursor(25, 22);
  display.setTextSize(1);
  display.println("Made by M.L");

  display.setCursor(67, 32);
  display.print("V2.0");
  display.display();
  delay(3000);

  display.clearDisplay();
}

uint8_t connected_save = 1;

void main_page(String ip)
{
  display.setCursor(0, 5);
  display.print("IP: " + ip + ":83");

  oled_connected_state(0);

  display.display();
}

void oled_connected_state(uint8_t state) {

  display.setCursor(0, 20);
  if (state != connected_save) {
    display.fillRect(0, 20, 75, 10, BLACK);
    
    if (state == 0)
      display.print("disconnected");
    else
      display.print("connected");

    connected_save = state;
    display.display();
  }
}