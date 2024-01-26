#include <Arduino.h>
#include "buttons.h"

uint64_t timers[] = {0, 0, 0, 0, 0, 0};
bool button_state[] = {false, false, false, false, false, false};

// index from 0 to 5  sensitive = latency time (avoid vibration effect)
void Button::buttonsImpl(uint8_t button_id, uint16_t sensitive) 
{
  if (button_state[button_id] == false && (millis() - timers[button_id]) >= sensitive) {
    button_state[button_id] = true;
    timers[button_id] = millis();
  }
}

bool Button::get_state(uint8_t button_id)
{
  bool temp = button_state[button_id];
  if (temp == true)
    button_state[button_id] = false;

  return temp; 
}

void Button::change_modeImpl(uint8_t &mode)
{
  if (get_state(2))
  {
    mode += 1;
    if (mode == 3)
      mode = 6;

    if (mode == 7)
      mode = 0;
  }
}