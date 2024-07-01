/*
 * ULP_strip_effects.h
 *
 *  Created on: Jun 30, 2024
 *      Author: micha
 */

#ifndef INC_ULP_STRIP_EFFECTS_H_
#define INC_ULP_STRIP_EFFECTS_H_

	#include <stdint.h>

	void strip_startup_init();
	uint8_t run_strip_startup_effect(uint8_t colour_array[][3], uint8_t strip_length);
	void get_gradient(uint8_t r1, uint8_t g1, uint8_t b1, uint8_t r2, uint8_t g2, uint8_t b2, uint8_t colour_array[][3], uint8_t strip_length);
	void move_pixel_right(uint8_t colour_array[][3], uint8_t strip_length);

#endif /* INC_ULP_STRIP_EFFECTS_H_ */
