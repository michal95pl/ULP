/*
 * ULP_Effects.c
 *
 *  Created on: Dec 15, 2023
 *      Author: michal
 */

#include "ULP_Effects.h"


void startup_effect_init(struct startup_veriables *data)
{
	data->counter_1=0;
	data->counter_2 = 0;
	data->semaphore = 0;
	data->brightness = 100;
	data->save_timer = 0;
}

// return 1 - finish effect
uint8_t startup_effect_first(struct startup_veriables *data, uint8_t led_array[][3], uint16_t led_length)
{

	// clear led
	if (data->counter_1 >= 1)
		set_color(led_array, data->counter_1-1, 0, 0, 0);

	if (data->counter_1 >= 2)
		set_color(led_array, data->counter_1-2, 0, 0, 0);

	// show wave
	set_color(led_array, data->counter_1, 255, 255, 255);
	set_color(led_array, data->counter_1+1, 255, 255, 255);

	// clear led
	if (led_length-1- (data->counter_1)+1 < led_length)
		set_color(led_array, led_length-1-(data->counter_1)+1, 0, 0, 0);

	if (led_length-1-(data->counter_1)-1+1 < led_length)
		set_color(led_array, led_length-1-(data->counter_1)-1+1, 0, 0, 0);

	// show wave
	set_color(led_array, led_length-1-(data->counter_1), 255, 255, 255);
	set_color(led_array, led_length-1-(data->counter_1)-1, 255, 255, 255);

	data->counter_1 += 1;

	if (data->counter_1 > led_length/2)
	{
		clear_led_strip(led_array, led_length);
		return 1;
	}
	else
		return 0;
}

// return 1 - finish effect
uint8_t startup_effect_second(struct startup_veriables *data, uint8_t led_array[][3], uint16_t led_length)
{
	if ((led_length/2) + (data->counter_2) < led_length)
		set_color(led_array, (led_length/2) + (data->counter_2), 66, 135, 245);

	if ((led_length/2) - (data->counter_2)-1 >= 0)
		set_color(led_array, (led_length/2) - (data->counter_2)-1, 66, 135, 245);

	(data->counter_2) += 1;

	if ((data->counter_2) == led_length/2)
		return 1;
	else
		return 0;
}

// return 1 - finish effect
uint8_t startup_effect_third(struct startup_veriables *data, uint8_t led_array[][3], uint16_t led_length)
{
	set_color_strip(led_array, map(66, data->brightness), map(135, data->brightness), map(245, data->brightness), led_length);
	(data->brightness) -= 3;

	if (data->brightness <= 0)
	{
		clear_led_strip(led_array, led_length);
		return 1;
	}
	else
		return 0;
}

// return 1 - finish effect
uint8_t startup_effect(uint8_t led_array[][3], struct startup_veriables *data, uint32_t timer, uint16_t led_length)
{
	switch(data->semaphore)
	{
	case 0: {
		if (timer - (data->save_timer) >= 15) // delay
		{
			data->semaphore += startup_effect_first(data, led_array, led_length);
			data->save_timer = timer;
			(data->save_timer) = timer;
		}
		break;
	}
	case 1: {data->semaphore += startup_effect_second(data, led_array, led_length); break;}
	case 2: {data->semaphore += startup_effect_third(data, led_array, led_length); break;}
	default: return 1;
	}
	return 0;
}

void vu_effect(uint8_t led_array[][3], uint8_t data, uint8_t r_a, uint8_t g_a, uint8_t b_a, uint8_t r_b, uint8_t g_b, uint8_t b_b, uint16_t led_length)
{
	for (uint8_t i=0; i < led_length; i++)
	{
		if (i < data)
		{
			led_array[i][0] = r_a;
			led_array[i][1] = g_a;
			led_array[i][2] = b_a;
		}
		else
		{
			led_array[i][0] = r_b;
			led_array[i][1] = g_b;
			led_array[i][2] = b_b;
		}
	}
}


// generate linear function, non float (divide by 100)
int32_t linear_a(uint8_t x1, uint8_t x2, uint8_t y1, uint8_t y2)
{
	int32_t val1 = y2;
	val1 -= y1;

	int32_t val2 = x2;
	x2 -= x1;

	return (val1 * 100) / val2;
}

// non float divide by 100
int32_t linear_b(int32_t a, uint8_t y1, uint8_t x1)
{
	int32_t val1 = y1;
	val1 *= 100;

	return val1 - (a*x1);
}

void eq_effect(uint8_t led_array[][3], uint8_t r_a, uint8_t g_a, uint8_t b_a, uint8_t r_b, uint8_t g_b, uint8_t b_b,uint8_t data[7], uint8_t cut, uint16_t sensetive, uint16_t led_length)
{
	uint8_t data_index = 0;
	for (uint8_t i=0; i < led_length; )
	{
		int32_t a = linear_a(i, i + 25, data[data_index], data[data_index+1]);
		int32_t b = linear_b(a, data[data_index], i);
		data_index++;

		if (data_index >= 6)
			data_index = 0;

		for (uint8_t j=0; j < 25; j++)
		{
			if (((a*i + b) / 100) > cut)
			{
				uint32_t d = (a*i + b);
				d *= sensetive;
				d /= 10000; // int to "float"

				if (d > 255)
					d = 255;

				led_array[i][0] = map_color(d, r_a);
				led_array[i][1] = map_color(d, g_a);;
				led_array[i][2] = map_color(d, b_a);;
			} else
			{
				led_array[i][0] = r_b;
				led_array[i][1] = g_b;
				led_array[i][2] = b_b;
			}

			i++;
		}

	}
}

