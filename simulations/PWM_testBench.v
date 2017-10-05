`timescale 10ns / 1ps //unit of time is the minimu period of the 100 MHz clock
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2017 10:26:52 AM
// Design Name: 
// Module Name: PWM_testBench
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
module PWM_testBench(         
);
    reg clock = 0;
    reg [2:0] speed;
    //reg [27:0] counterPeriodInClckTicks_reg;
    wire PWM_pulse;
    wire [27:0] debugCustomClkCounter_wire;
    
    defparam UUT.PERIOD = 28'd2500; 
    
    PWM_v3 UUT
    (
        .clock(clock),
        //input enable,
        //.counterPeriodInClckTicks(counterPeriodInClckTicks_reg),
        .dutyCycle(speed),
        //input [3:0] periodClockTicks,//for diving main 100 MHz frequency
        .PWM_pulse(PWM_pulse),
        .debugCounter(debugCustomClkCounter_wire)
    );
    
    initial 
    begin
        //clock <= 0;
        speed <= 3'd1;
        #5000
        
        speed <= 3'd2;
        #5000
        
        speed <= 3'd3;
        #5000
        
        speed <= 3'd4;
        #5000
        
        speed <= 3'd5; 
        #5000
        
        speed <= 3'd6;
        #5000
        
        speed <= 3'd7; 
        #5000
        
        speed <= 3'd0;
    end
    
    always begin
    #1 clock = ~clock; //1 tick is equivalent to 10^-8 s (period of 100 MHz)
    end

endmodule
