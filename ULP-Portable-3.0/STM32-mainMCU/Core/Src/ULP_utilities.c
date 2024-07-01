/*
 * ULP_utilities.c
 *
 *  Created on: Dec 16, 2023
 *      Author: michal
 */

#include "ULP_utilities.h"

/**
 * x - oryginal value
 * y - 0 - 100 - brightness percentage
 */
uint8_t map(uint8_t x, uint8_t y)
{
	return (x * y) / 100;
}

/**
 * x - oryginal value
 * y 0 - 255 - color value
 */
uint8_t map_color(uint8_t x, uint8_t y)
{
	return (x * y) / 255;
}
