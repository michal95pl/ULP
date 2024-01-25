#include "communication.h"

// buf length = 13

// xxx (0,1) 000 000 000
void get_color_buf(char buf[], String data) {
  buf[0] = data[0];
  buf[1] = data[1];
  buf[2] = data[2];
  buf[3] = (data[3] - 48);
  buf[4] = ((data[4]-48) * 100 + (data[5]-48) * 10 + (data[6]-48));
  buf[5] = ((data[7]-48) * 100 + (data[8]-48) * 10 + (data[9]-48));
  buf[6] = ((data[10]-48) * 100 + (data[11]-48) * 10 + (data[12]-48));
}

void get_slider_buf(char buf[], String data)
{
  buf[0] = data[0];
  buf[1] = data[1];
  buf[2] = data[2];
  buf[3] = (data[3] - 48);
  buf[4] = ((data[4]-48) * 100 + (data[5]-48) * 10 + (data[6]-48));
}

void get_effect_button(char buf[], String data) {
  buf[0] = data[0];
  buf[1] = data[1];
  buf[2] = data[2];
  buf[3] = (data[3] - 48);
  buf[4] = (data[4] - 48);
}