#ifndef INC_ULP_Effects_H_
#define INC_ULP_Effects_H_

	#include <stdint.h>
	#include "ULP_ws2812b.h"
	#include "ULP_utilities.h"
	#include "main.h" // for hal delay

	struct startup_veriables {
		uint16_t counter_1; // first effect, bidirectional 2 pixel wave
		uint16_t counter_2;
		int8_t brightness;
		uint8_t semaphore;
		uint32_t save_timer;
	};

	uint8_t startup_effect(uint8_t led_array[][3], struct startup_veriables *data, uint32_t timer, uint16_t led_length);
	void startup_effect_init(struct startup_veriables *data);
	void vu_effect(uint8_t led_array[][3], uint8_t data, uint8_t r_a, uint8_t g_a, uint8_t b_a, uint8_t r_b, uint8_t g_b, uint8_t b_b, uint16_t led_length);
	void eq_effect(uint8_t led_array[][3], uint8_t r_a, uint8_t g_a, uint8_t b_a, uint8_t r_b, uint8_t g_b, uint8_t b_b,uint8_t data[7], uint8_t cut, uint16_t sensetive, uint16_t led_length);

#endif
