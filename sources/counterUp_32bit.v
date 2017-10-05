`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/10/2017 03:28:06 PM
// Design Name: 
// Module Name: counterUp_32bit
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


module counterUp_32bit( //counter_up( clk, counterPeriod, countedUpTo )
    input clock, reset,
    input [31:0] counterPeriod,
    output [31:0] countedUpTo
    );
   
    reg [31:0] countedUpTo_reg;
    
//    initial begin
//        countedUpTo_reg <= 0;
//    end
    initial
    countedUpTo_reg <=0;
    
//  always@(posedge clk or negedge clk)
    always@(posedge clock) begin
        if ( !reset && !(counterPeriod == 32'd0 ) && ( countedUpTo_reg < ( counterPeriod - 1) ) ) 
            countedUpTo_reg <= countedUpTo_reg + 1;
        else
            countedUpTo_reg <= 0; 
    end
    
 assign countedUpTo = countedUpTo_reg;
endmodule
