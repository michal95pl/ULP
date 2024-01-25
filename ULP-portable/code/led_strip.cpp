#include <FastLED.h>
#include "led_strip.h"

uint8_t color_mode1[3] = {0,0,0};
uint8_t cntLed = 0; // cross
unsigned long long int rTimer = 0; // timer
int gradient[21][3], multi[3] = {0,0,0}; int r,g,b; int temp_gradient[21][3]; // gradient
int color1_temp[3] = {0,0,0}, color2_temp[3] = {0,0,0};

bool states2[6] = {true, false, false, false, false, false}; // rainbow states
int ar2=255,br2=0,cr2=0, nr2 = 0; // rainbow

CRGB set_brightness(CRGB color, uint16_t brightness) {
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

void strip_startup_effect1(CRGB displayBuffer[]) {
  for(int i=0; i < 20; i++){
    if(i > 1) { 
      displayBuffer[i-2] = CRGB(0,0,0);
    }

    if(i > 0) {
      displayBuffer[i-1] = CRGB(0,0,0);     
    }
        
    displayBuffer[i] = CRGB(255,255,255);
    displayBuffer[i+1] = CRGB(255,255,255);   
    FastLED.show();
    delay(20);
  }

  delay(50);

  for(int i=20; i >= 0; i--){
    if(i < 19) {
      displayBuffer[i+2] = CRGB(0,0,0);      
    }
      
    if(i < 20) {  
      displayBuffer[i+1] = CRGB(0,0,0);    
    }
      
    displayBuffer[i-1] = CRGB(255,255,255);
    displayBuffer[i] = CRGB(255,255,255);

    FastLED.show();
    delay(20);
  }
  
  displayBuffer[0] = CRGB(0,0,0);
  FastLED.show();
}

void strip_startup_effect2(CRGB displayBuffer[]) {
  for(int i=0; i <= 255; i+=15){
    for(int j=0; j<21; j++){
      displayBuffer[j] = CRGB(0,0,i);
    }
    FastLED.show();
    delay(20);
  }

  delay(50);
    
  for(int i=255; i >= 0; i-=15){
    for(int j=0; j<21; j++){
      displayBuffer[j] = CRGB(0,0,i);
    }
    FastLED.show();
    delay(20);
  }
}

void strip_color(CRGB leds[], CRGB color, uint8_t brightness) {

  for(int i=0; i<21; i++) {
    leds[i] = set_brightness(color, brightness);
  }
    

  if(color_mode1[0] != color.r || color_mode1[1] != color.g || color_mode1[2] != color.b) {
      FastLED.show();
      color_mode1[0] = color.r; color_mode1[1] = color.g; color_mode1[2] = color.b;
    }
}

void gradientCreate(int color1[3], int color2[3]) {

  r = color1[0]; g = color1[1]; b = color1[2];

  for(int i=0; i<3; i++){
    multi[i] = round(abs(color1[i]-color2[i])/18);
  }

  for(int i=0; i<21; i++){
    if(i > 0 && i < 20){
      if(color1[0] > color2[0] && r > color2[0]) {r -= multi[0];}
      else if(r < color2[0]) {r += multi[0];}

      if(color1[1] > color2[1] && r > color2[1]) {g -= multi[1];}
      else if(g < color2[1]) {g += multi[1];}

      if(color1[2] > color2[2] && b > color2[2]) {b -= multi[2];}
        else if(b < color2[2]) {b += multi[2];}
      }

      if(r > 255){r=255;}
      if(g > 255){g=255;}
      if(b > 255){b=255;}

      if(i == 0) { for(int n=0; n<3;n++){gradient[0][n] = color1[n];} }
      else if(i == 20) {for(int n=0; n<3;n++){gradient[20][n] = color2[n];}}
      else {
        gradient[i][0] = r;
        gradient[i][1] = g;
        gradient[i][2] = b;
      }
    }
  }

void gradientStatic(CRGB leds[], int color1[3], int color2[3], uint8_t brightness) {
  for(int i = 0; i<21; i++){ 
    leds[i] = set_brightness( CRGB(gradient[i][0], gradient[i][1], gradient[i][2]), brightness);
  }

  if(color1[0] != color1_temp[0] || color1[1] != color1_temp[1] || color1[2] != color1_temp[2] ||
    color2[0] != color2_temp[0] || color2[1] != color2_temp[1] || color2[2] != color2_temp[2]) {
    FastLED.show();
  }
}

void strip_rainbow(CRGB leds[], int speed, uint8_t brightness) {

  if((millis() - rTimer) >= speed){
    if(states2[0] == true){
      br2 += 51;
      if(br2 == 255){states2[0] = false; states2[1] = true;}
    }

    if(states2[1] == true){
      ar2 -= 51;
      if(ar2 == 0){states2[1] = false; states2[2] = true;}
    }

    if(states2[2] == true){
      cr2 += 51;
      if(cr2 == 255){states2[2] = false; states2[3] = true;}
    }

    if(states2[3] == true){
      br2 -= 51;
      if(br2 == 0){states2[3] = false; states2[4] = true;}
    }

    if(states2[4] == true){
      ar2 += 51;
      if(ar2 == 255){states2[4] = false; states2[5] = true;}
    }

    if(states2[5] == true){
      cr2 -= 51;
      if(cr2 == 0){states2[5] = false; states2[0] = true;}
    }

    nr2 += 1;
    if(nr2 == 21){nr2 = 0;}


    leds[nr2] = set_brightness(CRGB(ar2,br2,cr2), brightness);
    FastLED.show();
    rTimer = millis();
  }  
}

void strip_cross(CRGB leds[], int speed, int color1[], int color2[], uint8_t brightness) {
    
  if((millis() - rTimer) >= speed){

    for (short i = cntLed - 3; i < cntLed+1; i++)
      if (i >= 0) {
        leds[i] = CRGB(0,0,0);
        leds[21 - i-1] = CRGB(0,0,0);
      }

    for (short i = cntLed; i < cntLed + 3; i++)
      if (i < 21) {
        leds[i] = set_brightness( CRGB(color1[0],color1[1],color1[2]), brightness);
        leds[21 - i-1] = set_brightness( CRGB(color2[0],color2[1],color2[2]), brightness);
      }
      
    cntLed++;
    if (cntLed >= 21)
      cntLed = 0;
           
    FastLED.show();
    rTimer = millis();
  }        
}
