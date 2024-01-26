#include <WiFi.h>
#include <FastLED.h>

CRGB led_strip[21];
CRGB display_buffer[256];

// ULP lib
#include "recive.h"
#include "display.h"
#include "led_strip.h"
#include "oled.h"
#include "buttons.h"
#include "display_parser.h"


WiFiServer server(81);
WiFiClient client;


TaskHandle_t Task1;

// interruption, todo: better impl
void IRAM_ATTR BUTTONS_1() {Button::buttonsImpl(0, 300);}
void IRAM_ATTR BUTTONS_2() {Button::buttonsImpl(1, 300);} 
void IRAM_ATTR BUTTONS_3() {Button::buttonsImpl(2, 200);} // change mode
void IRAM_ATTR BUTTONS_5() {Button::buttonsImpl(4, 300);} // rainbow
void IRAM_ATTR BUTTONS_6() {Button::buttonsImpl(5, 300);}

// test
CRGB strobe_led_strip[21];

void setup() {

  // init buttons
  for (uint8_t i=11; i <=14; i++)
    pinMode(i, INPUT_PULLUP);
  pinMode(47, INPUT_PULLUP);
  pinMode(48, INPUT_PULLUP);

  pinMode(0, INPUT_PULLUP); // keyboard jumper

  attachInterrupt(12, BUTTONS_1, RISING);
  attachInterrupt(14, BUTTONS_2, RISING);
  attachInterrupt(47, BUTTONS_3, RISING);
  attachInterrupt(13, BUTTONS_5, RISING);
  attachInterrupt(11, BUTTONS_6, RISING);

  // debug
  Serial.begin(9600); // debug
  Serial.println("test"); // debug test

  // oled
  delay(50);
  oled_begin();
  oled_startPage();

  for (uint8_t i=0; i < 21; i++)
    strobe_led_strip[i] = CRGB(255, 255, 255);

  WiFi.mode(WIFI_AP); // access point 
  WiFi.softAP("ULP_LED", "246212345678"); // set wifi pass

  FastLED.addLeds<NEOPIXEL, 18> (led_strip, 21); // init leds, 18
  FastLED.addLeds<NEOPIXEL, 19> (display_buffer, 256); // init display, 19

  strip_startup_effect1(led_strip);
  server.begin(); // start wifi server
  strip_startup_effect2(led_strip);

  xTaskCreatePinnedToCore(coreLed, "Task1", 10000, NULL, 1, &Task1, 0); // run 2 core
  display_startup_effect (display_buffer, 255);

  clear_oled();
  Serial.println("test2"); // debug test
}

struct {
  uint16_t data[2309];
  uint16_t length=0;
} data_income;

bool show_text_flag = false;

// 3 index char (000) to 1 index of number
void decoder(uint16_t data[], uint16_t &length) {

  uint16_t real_lenth = 4;

  for (uint16_t i=4; i < length; ) {
    
    data[real_lenth++] = ((data[i++] - 48)* 100) + ((data[i++] - 48) * 10) + (data[i++]-48);
  }
  length = real_lenth;
}

char display_message[31];

// core 0
void loop() {
  WiFiClient client = server.available();

  while (client.connected()) {

    set_connection_state(true); //oled
    oled_loop();
    
    data_income.length = 0;

    while(client.available() > 0) {
      uint16_t c = client.read();
      if(c == 'k') // end data transmmition
        break; 
      data_income.data[ data_income.length++ ] = c;
    }

    if (data_income.length > 4) {

      // set flag, todo: better impl
      if (data_income.data[0] == 'D' && data_income.data[1] == 'S' && data_income.data[2] == 'T' && data_income.data[3] == '_')
      {
        uint8_t i=4;
        for (; i < data_income.length && ((i-4) < 31); i++)
        {
          display_message[i-4] = data_income.data[i];
        }
        display_message[i-4] = 'k'; // add end
        show_text_flag = true;
      }
      else
      {
        decoder(data_income.data, data_income.length);

        if (data_income.data[0] == 'D' && data_income.data[1] == 'B' && data_income.data[2] == 'F' && data_income.data[3] == 'D') {
          encode_data(display_buffer, data_income.data, data_income.length, display_brightness);
          show_text_flag = false;
          if (strip_mode == 0)
          FastLED.show();
        }
        else {
          strip_decode(data_income.data, data_income.length);
        }
      }
        
    }
  }

  set_connection_state(false); //oled
  oled_loop();
}

// standarization function: CRGB to array[3]
void CRGB_to_array(const CRGB &color, int array[]) {
  array[0] = color.r;
  array[1] = color.g;
  array[2] = color.b;
}

int gradient_standard_first[] = {0, 0, 0};
int gradient_standard_second[] = {0, 0, 0};

// strobe semaphore
bool strobe_swap = false;

void swap_array(CRGB arr1[], CRGB arr2[], uint8_t len)
{
  for (uint8_t i=0; i < len; i++)
  {
    CRGB temp = arr1[i];
    arr1[i] = arr2[i];
    arr2[i] = temp;
  }
}

// led strip effects
void coreLed(void *parameter) {

  while(true) {

    if (!digitalRead(0)) {Button::change_modeImpl(strip_mode);}
      
    // strobe
    if (!digitalRead(0) && !digitalRead(48))
    {
      if (strobe_swap == false)
        swap_array(led_strip, strobe_led_strip, 21);
      FastLED.show();
      strobe_swap = true;
    }
    else
    {
      if (strobe_swap)
      {
        swap_array(led_strip, strobe_led_strip, 21);
        FastLED.show();
        strobe_swap = false;
      }

      if (!digitalRead(0) && Button::get_state(5)) {strip_mode = 2; effects_speed[0] = 70;} // slow rainbow bind
      else if (!digitalRead(0) && Button::get_state(4)) {strip_mode = 6; effects_speed[1] = 10;} // fast cross bind
      else if (!digitalRead(0) && Button::get_state(0)) {strip_mode = 1; strip_brightness = 80;} // default mode (low brighteness)

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
        case 2: {strip_rainbow(led_strip, effects_speed[0], strip_brightness); break;}
        case 6: {
          CRGB_to_array(strip_first_gradientColor, gradient_standard_first);
          CRGB_to_array(strip_second_gradientColor, gradient_standard_second);
          strip_cross(led_strip, effects_speed[1], gradient_standard_first, gradient_standard_second, strip_brightness); 
          break;
        }
        default: break; // error
      }

      set_mode(strip_mode); // oled
    }

    if (show_text_flag)
      show_text(display_buffer, display_text_color, display_message);

    delay(1);
  }

}
