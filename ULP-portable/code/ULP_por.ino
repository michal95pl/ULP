#include <WiFi.h>
#include <FastLED.h>

// oled
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

CRGB led_strip[21];
CRGB display_buffer[256];

Adafruit_SSD1306 display(128, 32, &Wire, -1);

// ULP lib
#include "recive.h"
#include "display.h"
#include "led_strip.h"


WiFiServer server(81);
WiFiClient client;

TaskHandle_t Task1;

void oled() {
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(0, 10);
  display.println("ULP made by M.L");
  display.display(); 
}

void setup() {

  // debug
  Serial.begin(9600); // debug
  Serial.println("test"); // debug test

  // oled
  Wire.begin(6, 7);
  display.begin(SSD1306_SWITCHCAPVCC, 0x3C);
  delay(50);
  oled();

  WiFi.mode(WIFI_AP); // access point 
  WiFi.softAP("ULP-LED", "2462123456"); // set wifi pass

  FastLED.addLeds<NEOPIXEL, 18> (led_strip, 21); // init leds
  FastLED.addLeds<NEOPIXEL, 19> (display_buffer, 256); // init display

  strip_startup_effect1(led_strip);
  server.begin(); // start wifi server
  strip_startup_effect2(led_strip);

  xTaskCreatePinnedToCore(coreLed, "Task1", 10000, NULL, 1, &Task1, 0); // run 2 core
  display_startup_effect (display_buffer, 255);

}

struct {
  uint16_t data[2309];
  uint16_t length=0;
} data_income;

// 3 index char (000) to 1 index of number
void decoder(uint16_t data[], uint16_t &length) {

  uint16_t real_lenth = 4;

  for (uint16_t i=4; i < length; ) {
    
    data[real_lenth++] = ((data[i++] - 48)* 100) + ((data[i++] - 48) * 10) + (data[i++]-48);
  }
  length = real_lenth;
}


// core 0
void loop() {
  WiFiClient client = server.available();

  while (client.connected()) {

    data_income.length = 0;

    while(client.available() > 0) {
      uint16_t c = client.read();
      if(c == 'k')
        break; 
      data_income.data[ data_income.length++ ] = c;
    }

    if (data_income.length > 4) {
      
      decoder(data_income.data, data_income.length);

      if (data_income.data[0] == 'D' && data_income.data[1] == 'B' && data_income.data[2] == 'F' && data_income.data[3] == 'D') {
        encode_data(display_buffer, data_income.data, data_income.length, display_brightness);
        if (strip_mode == 0)
          FastLED.show();
      }
      else {
        strip_decode(data_income.data, data_income.length);
      }

    }
    

  }

}

// standarization function: CRGB to array[3]
void CRGB_to_array(const CRGB &color, int array[]) {
  array[0] = color.r;
  array[1] = color.g;
  array[2] = color.b;
}

int gradient_standard_first[] = {0,0,0};
int gradient_standard_second[] = {0,0,0};

// led strip effects
void coreLed(void *parameter) {

  
  while(true) {

    switch(strip_mode) {
      case 0: {strip_color(led_strip, strip_main_color, strip_brightness); break;}
      // todo: rebuild gradient
      case 1: {
        CRGB_to_array(strip_first_gradientColor, gradient_standard_first);
        CRGB_to_array(strip_second_gradientColor, gradient_standard_second);

        gradientCreate(gradient_standard_first, gradient_standard_second); 
        gradientStatic(led_strip, gradient_standard_first, gradient_standard_second, strip_brightness);
        break;
      }
      // todo: rebuild gradient
      case 2: {strip_rainbow(led_strip, effects_speed[0], strip_brightness); break;}
      case 6: {
        CRGB_to_array(strip_first_gradientColor, gradient_standard_first);
        CRGB_to_array(strip_second_gradientColor, gradient_standard_second);
        strip_cross(led_strip, effects_speed[1], gradient_standard_first, gradient_standard_second, strip_brightness); 
        break;
      }
      default: break; // error
    }
    delay(1);
  }

}
