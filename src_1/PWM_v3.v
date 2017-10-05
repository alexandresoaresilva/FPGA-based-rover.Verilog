`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2017 04:37:34 AM
// Design Name: 
// Module Name: PWM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
// for creating custom clock, use instance:
    
//    defparam UUT.PERIOD = period_you_want; 
//    PWM_v3 UUT
//    (
//        .clock(clock),
//        //input enable,
//        //.counterPeriodInClckTicks(counterPeriodInClckTicks_reg),
//        .dutyCycle(3'b011), //50% duty cycle
//        //input [3:0] periodClockTicks,//for diving main 100 MHz frequency
//        .PWM_pulse(PWM_pulse),
//        .debugCounter(debugCounter_wire)
//    );
    

module PWM_v3 #( parameter [27:0] PERIOD = 500000
    ) // based on the Basys3's main clock (100 MHz)
    //counterPeriods:
    // based on the Basys3's main clock (100 MHz)
    // UPDATES ONLY ON THE POSEDGE
    //50000000 for 1 Hz
    //500000 for 100 Hz
    //2500 for 20 KHz
    //500 for 100 Khz
    // 
    (   
        input clock,
        //input [27:0] counterPeriodInClckTicks,
        input [2:0] dutyCycle,//for diving main 100 MHz frequency
        output PWM_pulse
       //, output [27:0] debugCounter //comment it out later
    );
    
    //reg [19:0] counter_reg
     //= counterPeriodInClckTicks;
     parameter HALF_PERIOD = PERIOD >> 1; //50%
     parameter QUARTER_PERIOD = PERIOD >> 2; //25%
     parameter HALF_QUARTER_PERIOD = PERIOD >> 3; //12.5%    
     parameter PERC38_PERIOD = HALF_PERIOD - HALF_QUARTER_PERIOD;//37.5%
     parameter PERC62_PERIOD = HALF_PERIOD + HALF_QUARTER_PERIOD; //62.5%
     parameter PERC75_PERIOD = HALF_PERIOD + QUARTER_PERIOD; //75%
     parameter PERC88_PERIOD = PERC75_PERIOD + HALF_QUARTER_PERIOD; //87.5%
    
    reg [27:0] PWM_duty_reg;
    reg PWM_high_reg;
    wire [27:0]  countedUpTo_wire;
    
    //parameter [27:0] BASE_PERIOD = 28'd1000000;
    
    //calculatedPeriod_wire; //1,000,000 for 100 Hz;  1000 for 100 KHz 
    
     initial
     begin
        PWM_duty_reg = 0;
        PWM_high_reg = 0;
      end
      
      always@(posedge clock)
      begin
          case(dutyCycle) //needs 16 cases for 16 switches
              3'b000 : PWM_duty_reg <= 28'd0;            //0% duty cycle
              3'b001 : PWM_duty_reg <= QUARTER_PERIOD;   //25% duty cycle
              3'b010 : PWM_duty_reg <= PERC38_PERIOD;    //37.5% duty cycle
              3'b011 : PWM_duty_reg <= HALF_PERIOD;      //50% duty cycle
              3'b100 : PWM_duty_reg <= PERC62_PERIOD;    //62.5% duty cycle
              3'b101 : PWM_duty_reg <= PERC75_PERIOD;    //75% duty cycle
              3'b110 : PWM_duty_reg <= PERC88_PERIOD;     //87.5% duty cycle
              3'b111 : PWM_duty_reg <= PERIOD;           //100% duty cycle
              default : PWM_duty_reg <= 28'd0;
          endcase
      end

      always@(negedge clock) begin
          if ( countedUpTo_wire > 0 && countedUpTo_wire < PWM_duty_reg ) begin
            PWM_high_reg <= 1;
          end
          else begin
            PWM_high_reg <= 0;
          end
      end
      
      counter_up PWM_counterUp1(  //counter_up( clk, counterPeriod, countedUpTo )
          .clock(clock), 
          .reset(1'b0),
          .counterPeriod(PERIOD),
          .countedUpTo(countedUpTo_wire)
          );
          
assign PWM_pulse = PWM_high_reg;
//assign debugCounter = countedUpTo_wire;

endmodule