#ifndef oled_lib
  #define oled_lib

  void oled_begin();
  void oled_startPage();
  void clear_oled();
  void set_mode(uint8_t m);
  void set_connection_state(bool s);
  void oled_loop();

#endif