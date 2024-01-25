/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2023 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "dma.h"
#include "tim.h"
#include "usart.h"
#include "gpio.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

#include "ULP_ws2812b.h"
#include "ULP_Effects.h"
#include "ULP_utilities.h"

/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */
/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/

/* USER CODE BEGIN PV */

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */

struct Color {
	uint8_t r;
	uint8_t g;
	uint8_t b;
};

uint8_t dma_flag[3] = {1, 1, 1};
uint8_t application_buffer[7];
uint8_t pc_buffer[8];

// led variables
struct Color main_color[3] = {{0,0,0}, {0,0,0}, {0,0,0}};
struct Color vu_color_a[3] = {{0,0,0}, {0,0,0}, {0,0,0}};
struct Color vu_color_b[3] = {{0,0,0}, {0,0,0}, {0,0,0}};
struct Color eq_color_a[3] = {{0,0,0}, {0,0,0}, {0,0,0}};
struct Color eq_color_b[3] = {{0,0,0}, {0,0,0}, {0,0,0}};


uint8_t brightness[3] = {0, 0, 0};
uint8_t channel_effect[3] = {0, 0, 0}; // 0 - color, 1 - vu meter, 2 - eq

uint8_t channel_flag[3] = {0, 0, 0}; // if flag is 1 - channel should be refresh asap

uint8_t vu_data = 0;
uint8_t vu_flag[3] = {0, 0, 0}; // if 1 - refresh led asap

uint8_t eq_data[7] = {0, 0, 0, 0, 0, 0, 0};
uint8_t eq_cut[3] = {0,0,0};
uint16_t eq_sensetive[3] = {100,100,100};

void HAL_TIM_PWM_PulseFinishedCallback(TIM_HandleTypeDef *htim)
{

	if (htim->Channel == HAL_TIM_ACTIVE_CHANNEL_2) // A
	{
		HAL_TIM_PWM_Stop_DMA(htim, TIM_CHANNEL_2);
		dma_flag[0] = 1;
	}
	else if (htim->Channel == HAL_TIM_ACTIVE_CHANNEL_3) // B
	{
		HAL_TIM_PWM_Stop_DMA(htim, TIM_CHANNEL_3);
		dma_flag[1] = 1;
	}
	else if (htim->Channel == HAL_TIM_ACTIVE_CHANNEL_4) // C
	{
		HAL_TIM_PWM_Stop_DMA(htim, TIM_CHANNEL_4);
		dma_flag[2] = 1;
	}

}

void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
	// application
	if (huart == &huart1)
	{
		if (application_buffer[0] == 'd' && application_buffer[1] == 'c' && application_buffer[2] == '_')
		{
			main_color[application_buffer[3]].r = application_buffer[4];
			main_color[application_buffer[3]].g = application_buffer[5];
			main_color[application_buffer[3]].b = application_buffer[6];
			channel_flag[application_buffer[3]] = 1;
		}
		else if (application_buffer[0] == 'd' && application_buffer[1] == 'b' && application_buffer[2] == '_')
		{
			brightness[application_buffer[3]] = application_buffer[4];
			channel_flag[application_buffer[3]] = 1;
		}
		else if (application_buffer[0] == 'v' && application_buffer[1] == 'u' && application_buffer[2] == 'a')
		{
			vu_color_a[application_buffer[3]].r = application_buffer[4];
			vu_color_a[application_buffer[3]].g = application_buffer[5];
			vu_color_a[application_buffer[3]].b = application_buffer[6];
			vu_flag[application_buffer[3]] = 1;
		}
		else if (application_buffer[0] == 'v' && application_buffer[1] == 'u' && application_buffer[2] == 'b')
		{
			vu_color_b[application_buffer[3]].r = application_buffer[4];
			vu_color_b[application_buffer[3]].g = application_buffer[5];
			vu_color_b[application_buffer[3]].b = application_buffer[6];
			vu_flag[application_buffer[3]] = 1;
		}
		else if (application_buffer[0] == 'd' && application_buffer[1] == 's' && application_buffer[2] == '_')
		{
			channel_effect[application_buffer[3]] = application_buffer[4];
		}
		else if (application_buffer[0] == 'e' && application_buffer[1] == 'q' && application_buffer[2] == 'c')
		{
			eq_cut[application_buffer[3]] = application_buffer[4];
		}
		else if (application_buffer[0] == 'e' && application_buffer[1] == 'q' && application_buffer[2] == 'g')
		{
			eq_sensetive[application_buffer[3]] = application_buffer[4];
		}
		else if (application_buffer[0] == 'd' && application_buffer[1] == 'q' && application_buffer[2] == 'a')
		{
			eq_color_a[application_buffer[3]].r = application_buffer[4];
			eq_color_a[application_buffer[3]].g = application_buffer[5];
			eq_color_a[application_buffer[3]].b = application_buffer[6];
		}
		else if (application_buffer[0] == 'd' && application_buffer[1] == 'q' && application_buffer[2] == 'b')
		{
			eq_color_b[application_buffer[3]].r = application_buffer[4];
			eq_color_b[application_buffer[3]].g = application_buffer[5];
			eq_color_b[application_buffer[3]].b = application_buffer[6];
		}

		HAL_UART_Receive_IT(&huart1, application_buffer, 7);
	}
	// computer
	if (huart == &huart2)
	{
		HAL_UART_Receive_DMA(&huart2, pc_buffer, 8);
	}

}


// A
uint8_t color_array_A[150][3];
uint8_t pixel_bit_buffer_A[(150 * 24) + 45];

// B
uint8_t color_array_B[150][3];
uint8_t pixel_bit_buffer_B[(150 * 24) + 45];

// C
uint8_t color_array_C[150][3];
uint8_t pixel_bit_buffer_C[(150 * 24) + 45];

/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{
  /* USER CODE BEGIN 1 */
  /* USER CODE END 1 */

  /* MCU Configuration--------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_DMA_Init();
  MX_USART2_UART_Init();
  MX_TIM1_Init();
  MX_USART1_UART_Init();
  MX_TIM2_Init();
  /* USER CODE BEGIN 2 */
  HAL_TIM_Base_Start(&htim2);
  HAL_UART_Receive_IT(&huart1, application_buffer, 7);
  HAL_UART_Receive_DMA(&huart2, pc_buffer, 8);

  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */


  clear_led_strip(color_array_A, 150);
  clear_led_strip(color_array_B, 150);
  clear_led_strip(color_array_C, 150);

  // startup effect (all channels)
  struct startup_veriables startup_ver;

  startup_effect_init(&startup_ver);

  while (startup_effect(color_array_C, &startup_ver, TIM2->CNT, 150) == 0)
  {
	  while(dma_flag[2] == 0 || dma_flag[1] == 0 || dma_flag[0] == 0);

	  color_array_to_pixels(color_array_C, pixel_bit_buffer_C, 150, 100);

	  // all channel (connected together channel)
	  HAL_TIM_PWM_Start_DMA(&htim1, TIM_CHANNEL_2, (uint32_t*)pixel_bit_buffer_C, buffer_size(150));
	  HAL_TIM_PWM_Start_DMA(&htim1, TIM_CHANNEL_3, (uint32_t*)pixel_bit_buffer_C, buffer_size(150));
	  HAL_TIM_PWM_Start_DMA(&htim1, TIM_CHANNEL_4, (uint32_t*)pixel_bit_buffer_C, buffer_size(150));

	  dma_flag[0] = 0; dma_flag[1] = 0; dma_flag[2] = 0;
  }

  while (1)
  {
	  for (uint8_t i=0; i < 7; i++)
	  {
		 eq_data[i] = pc_buffer[i+1];
	  }


	  // channel A:
	  if (dma_flag[0] == 1)
	  {
		  // color
		  if (channel_effect[0] == 0)
		  {
			  set_color_strip(color_array_A, main_color[0].r, main_color[0].g, main_color[0].b, 150);
		  }
		  else if (channel_effect[0] == 1)
		  {
			  vu_effect(color_array_A, pc_buffer[0], vu_color_a[0].r, vu_color_a[0].g, vu_color_a[0].b, vu_color_b[0].r, vu_color_b[0].g, vu_color_b[0].b, 150);
		  }
		  else if (channel_effect[0] == 2)
		  {
			  eq_effect(color_array_A, eq_color_a[0].r, eq_color_a[0].g, eq_color_a[0].b, eq_color_b[0].r, eq_color_b[0].g, eq_color_b[0].b, eq_data, eq_cut[0], eq_sensetive[0], 150);
		  }

		 color_array_to_pixels(color_array_A, pixel_bit_buffer_A, 150, brightness[0]);
		 HAL_TIM_PWM_Start_DMA(&htim1, TIM_CHANNEL_2, (uint32_t*)pixel_bit_buffer_A, buffer_size(150));
		 dma_flag[0] = 0;

	  }

	  // channel B:
	  if (dma_flag[1] == 1)
	  {
		 // color
		 if (channel_effect[1] == 0)
		 {
			 set_color_strip(color_array_B, main_color[1].r, main_color[1].g, main_color[1].b, 150);
		 }
		 else if (channel_effect[1] == 1)
		 {
			 vu_effect(color_array_B, pc_buffer[0], vu_color_a[1].r, vu_color_a[1].g, vu_color_a[1].b, vu_color_b[1].r, vu_color_b[1].g, vu_color_b[1].b, 150);
		 }
		 else if (channel_effect[1] == 2)
		 {
		 	eq_effect(color_array_B, eq_color_a[1].r, eq_color_a[1].g, eq_color_a[1].b, eq_color_b[1].r, eq_color_b[1].g, eq_color_b[1].b, eq_data, eq_cut[1], eq_sensetive[1], 150);
		 }

		 color_array_to_pixels(color_array_B, pixel_bit_buffer_B, 150, brightness[1]);
		 HAL_TIM_PWM_Start_DMA(&htim1, TIM_CHANNEL_3, (uint32_t*)pixel_bit_buffer_B, buffer_size(150));
		 dma_flag[1] = 0;
	  }

	  // channel C:
	  if (dma_flag[2] == 1)
	  {
		  // color
		 if (channel_effect[2] == 0 && channel_flag[2] == 1)
		 {
		 	set_color_strip(color_array_C, main_color[2].r, main_color[2].g, main_color[2].b, 150);
		 }
		 else if (channel_effect[2] == 1)
		 {
			 vu_effect(color_array_C, pc_buffer[0], vu_color_a[2].r, vu_color_a[2].g, vu_color_a[2].b, vu_color_b[2].r, vu_color_b[2].g, vu_color_b[2].b, 150);
		 }
		 else if (channel_effect[2] == 2)
		 {
			eq_effect(color_array_C, eq_color_a[2].r, eq_color_a[2].g, eq_color_a[2].b, eq_color_b[2].r, eq_color_b[2].g, eq_color_b[2].b, eq_data, eq_cut[2], eq_sensetive[2], 150);
		 }

		 color_array_to_pixels(color_array_C, pixel_bit_buffer_C, 150, brightness[2]);
		 HAL_TIM_PWM_Start_DMA(&htim1, TIM_CHANNEL_4, (uint32_t*)pixel_bit_buffer_C, buffer_size(150));
		 dma_flag[2] = 0;
	  }

    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
  }
  /* USER CODE END 3 */
}

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

  /** Configure the main internal regulator output voltage
  */
  HAL_PWREx_ControlVoltageScaling(PWR_REGULATOR_VOLTAGE_SCALE1);

  /** Initializes the RCC Oscillators according to the specified parameters
  * in the RCC_OscInitTypeDef structure.
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI;
  RCC_OscInitStruct.HSIState = RCC_HSI_ON;
  RCC_OscInitStruct.HSIDiv = RCC_HSI_DIV1;
  RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_DEFAULT;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSI;
  RCC_OscInitStruct.PLL.PLLM = RCC_PLLM_DIV1;
  RCC_OscInitStruct.PLL.PLLN = 8;
  RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV2;
  RCC_OscInitStruct.PLL.PLLQ = RCC_PLLQ_DIV2;
  RCC_OscInitStruct.PLL.PLLR = RCC_PLLR_DIV2;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_2) != HAL_OK)
  {
    Error_Handler();
  }
}

/* USER CODE BEGIN 4 */

/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */
  __disable_irq();
  while (1)
  {
  }
  /* USER CODE END Error_Handler_Debug */
}

#ifdef  USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */
