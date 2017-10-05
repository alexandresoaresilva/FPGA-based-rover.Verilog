`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Alexandre Soares
// 
// Create Date: 06/28/2017 08:02:16 PM
// Design Name: counter_up
// Module Name: counter_up
// Project Name: Red Group
// Target Devices: 
// Tool Versions: 
// Description: 28 bit UP counter for getting clocks with frequencies other than 100 MHz
//  counting up to 1,000,000 gives you 100 Hz; counting up to 100,000,000 gives you 1 sec
// CAREFUL with reset
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module counter_up(  //counter_up( clk, counterPeriod, countedUpTo )
    input clock, reset,
    input [27:0] counterPeriod,
    output [27:0] countedUpTo
    );
    
    //counterPeriods:
    // based on the Basys3's main clock (100 MHz)
    //50000000 for 1 Hz
    //500000 for 100 Hz
    //2500 for 20 KHz
    //500 for 100 Khz
    //
    
    reg [27:0] countedUpTo_reg;
    
//    initial begin
//        countedUpTo_reg <= 0;
//    end
    initial
    countedUpTo_reg <=0;
    
//  always@(posedge clk or negedge clk)
    always@(posedge clock) begin
        if ( !reset && !(counterPeriod == 28'd0 ) && ( countedUpTo_reg < ( counterPeriod - 1) ) ) 
            countedUpTo_reg <= countedUpTo_reg + 1;
        else
            countedUpTo_reg <= 0; 
    end
    
 assign countedUpTo = countedUpTo_reg;
endmodule

