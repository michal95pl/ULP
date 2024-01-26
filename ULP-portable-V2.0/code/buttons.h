#ifndef buttons_lib
  #define buttons_lib

  namespace Button
  {
    void buttonsImpl(uint8_t button_id, uint16_t sensitive);
    bool get_state(uint8_t button_id);
    void change_modeImpl(uint8_t &mode);
  }
  
#endif  
