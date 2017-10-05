`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/30/2017 04:10:14 PM
// Design Name: 
// Module Name: CounterUp_TestBench
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

module CounterUp_TestBench(
    );
    
    
    reg clock = 0;
    reg reset = 0;
    reg [27:0] counterPeriod = 0;
    wire [27:0] countedUpTo;
    
    parameter [27:0] PERIOD = 28'd1000000; //1,000,000 for 100 Hz; 1000 FOR 100 Khz
    parameter [27:0] HALF_PERIOD = PERIOD >> 1;
    parameter [27:0] QUARTER_PERIOD = PERIOD >> 2;
    parameter [27:0] PERC75_PERIOD = HALF_PERIOD + QUARTER_PERIOD;
    
    counter_up U2(
    .clock(clock),
    .reset(reset),
    .counterPeriod(counterPeriod),
    .countedUpTo(countedUpTo)
    );
     
    initial 
    begin
        clock <=0;
        counterPeriod <= 28'd0;
        reset <= 0;
        #1000000
        
        counterPeriod <= PERIOD;
        #1000000
        
        reset = 1;
        reset = 0;
        counterPeriod = HALF_PERIOD;
        #1000000
        
        reset <= 1;
        reset <= 0;
        counterPeriod <= QUARTER_PERIOD;
        #1000000
        
        reset <= 1;
        reset <= 0;
        counterPeriod <= PERC75_PERIOD;
        #1500000
        
        reset = 1;
        reset = 0;
        counterPeriod = 0;
    end
       
    always 
    #1 clock = ~clock; //1 tick is equivalent to 10^-8 s (period of 100 MHz)
         
endmodule
