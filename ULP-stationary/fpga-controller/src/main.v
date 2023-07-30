 module led (
    input clk,
    input clock_data,
    input data,
    input reset,
    output test,
    output test2,
    output test3
);

    reg [35:0] data_timer = 0;
    reg [35:0] data_recived = 0;

    // reciver
    always @ (posedge clock_data or posedge reset) begin
            
        if (reset == 1'b1)
            data_timer = 1'b0;
        else begin
            data_recived[data_timer] = data;
            data_timer = data_timer + 1;
        end
    end

    
    // pwm, comunication bus
    reg [9:0] pwm_period1 = 0;
    reg [9:0] pwm_period2 = 0;
    reg [9:0] pwm_period3 = 0;

    always @ (posedge reset) begin

        pwm_period1 = data_recived[15:6];
        pwm_period2 = data_recived[25:16];
        pwm_period3 = data_recived[35:26];

    end

    
    PWM(pwm_period1, clk, test);
    PWM(pwm_period2, clk, test2);
    PWM(pwm_period3, clk, test3);



endmodule


module PWM(
    input [9:0] pwm_period,
    input clk,
    output reg out_pwm
);

    reg [9:0] pwm_timer = 0;
    reg [9:0] test_per = 0;

    always @ (posedge clk) begin
        
        if (test_per >= 50) begin

            if ((pwm_timer <= pwm_period) && (pwm_period != 0))
                out_pwm = 1'b1;
            else
                out_pwm = 1'b0;
                
            pwm_timer = pwm_timer + 1;
            test_per = 0;
        end else begin
            test_per = test_per + 1;
        end

    end

endmodule
