/*
 * ULP_ws2812b.h
 *
 *  Created on: 29 paź 2023
 *      Author: michal
 */

#ifndef INC_ULP_WS2812B_H_
#define INC_ULP_WS2812B_H_

	#include <stdint.h>
	#include "ULP_utilities.h"

	#define MIN_LED_VALUE 27
	#define MAX_LED_VALUE 53

	void color_array_to_pixels(uint8_t color_arr[][3], uint8_t pixel_buffer[], uint16_t led_length, uint8_t brightness);
	void set_color_strip(uint8_t color_arr[][3], uint8_t r, uint8_t g, uint8_t b, uint16_t length);
	void clear_led_strip(uint8_t color_arr[][3], uint16_t length);
	uint16_t buffer_size(uint16_t led_count);
	void set_color(uint8_t color_arr[][3], uint16_t led, uint8_t r, uint8_t g, uint8_t b);

#endif /* INC_ULP_WS2812B_H_ */
