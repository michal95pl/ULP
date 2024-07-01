#include "ULP_ws2812b.h"

uint16_t colorPixel(uint8_t r, uint8_t g, uint8_t b, uint16_t buffer[], uint16_t offset)
{
	uint8_t j;

	// green color
	j = 7;
	for (uint8_t i = 128; i >= 1; i /= 2)
	{
		buffer[offset++] = (((g & i) >> j) == 1 ? MAX_LED_VALUE : MIN_LED_VALUE);
	    j -= 1;
	}

	// red color
	j = 7;
	for (uint8_t i = 128; i >= 1; i /= 2)
	{
		buffer[offset++] = (((r & i) >> j) == 1 ? MAX_LED_VALUE : MIN_LED_VALUE);
		j -= 1;
	}

	// blue color
	j = 7;
	for (uint8_t i = 128; i >= 1; i /= 2)
	{
		buffer[offset++] = (((b & i) >> j) == 1 ? MAX_LED_VALUE : MIN_LED_VALUE);
		j -= 1;
	}

	// return first index value for next pixel
	return offset;
}

uint8_t convert_brightness(uint8_t color, uint8_t b) {
	uint16_t temp = color * b;
	return (uint8_t)(temp / 255);
}

/**
 * color_arr[number pixel][r, g, b] - color array
 * pixel_array[] - pixel buffer to send. Length array: (24 * length strip + 44 (reset time) + 1(stop flag))
 * brightness 0 to 255
 */
void color_array_to_pixels(uint8_t color_arr[][3], uint16_t pixel_buffer[], uint16_t led_length, uint8_t brightness)
{
	uint16_t indx_pixel_array = 0;

	for (uint16_t i=0; i < led_length; i++)
		indx_pixel_array = colorPixel(convert_brightness(color_arr[i][0], brightness), convert_brightness(color_arr[i][1], brightness), convert_brightness(color_arr[i][2], brightness), pixel_buffer, indx_pixel_array);

	for (uint8_t i=0; i < 45; i++)
		pixel_buffer[indx_pixel_array++] = 0;
}

/**
 * set one color on strip
 */
void set_color_strip(uint8_t color_arr[][3], uint8_t r, uint8_t g, uint8_t b, uint16_t length)
{
	for (uint16_t i=0; i < length; i++)
	{
		color_arr[i][0] = r;
		color_arr[i][1] = g;
		color_arr[i][2] = b;
	}
}

void clear_led_strip(uint8_t color_arr[][3], uint16_t length)
{
	set_color_strip(color_arr, 0, 0, 0, length);
}

void set_color(uint8_t color_arr[][3], uint16_t led, uint8_t r, uint8_t g, uint8_t b)
{
	color_arr[led][0] = r;
	color_arr[led][1] = g;
	color_arr[led][2] = b;
}

/**
 * return buffer size, input number pixel
 */
uint16_t buffer_size(uint16_t led_count)
{
	// 24bit color + 44 bit reset time + 1bit null for stop pwm
	return (led_count * 24) + 45;
}
