#include <WiFi.h>
#include <stdint.h>
#include "oled.h"
#include "communication.h"

const char* ssid     = "ULP-S";
const char* password = "2462123456";

WiFiServer server(83);

void setup() {
  
  Serial.begin(115200);
  Serial2.begin(115200);
  
  oled_init();

  WiFi.softAP(ssid, password); // wifi starting

  oled_start_effect();

  IPAddress ip = WiFi.softAPIP();
  main_page(ip.toString());

  server.begin();
}

String data = "";
char buffer[7];

void clear_buf(char buf[]) {
  for (uint8_t i = 0; i < 7; i++)
    buf[i] = 0;
}

void loop() {
  WiFiClient client = server.available();

  while (client.connected()) {

    oled_connected_state(1);

    while(client.available() > 0) {
      char c = client.read();
      if(c == 'k') // end data transmmition
        break; 
      data += c;
    }

    if (data != "")
    {
      if (data.startsWith("dc_") || data.startsWith("dqa") || data.startsWith("vua") || data.startsWith("dqb") || data.startsWith("vub") || data.startsWith("gra") || data.startsWith("grb"))
      {
        clear_buf(buffer);
        get_color_buf(buffer, data);
        Serial2.write(buffer, 7);
        
      }
      else if (data.startsWith("db_") || data.startsWith("eqc") || data.startsWith("eqg")) // brightness, eq cut, eq gain
      {
        clear_buf(buffer);
        get_slider_buf(buffer, data);
        Serial2.write(buffer, 7);
      }
      else if (data.startsWith("ds_"))
      {
        clear_buf(buffer);
        get_effect_button(buffer, data);
        Serial2.write(buffer, 7);
      }
      data = "";
    }

  }

  oled_connected_state(0);
  
}