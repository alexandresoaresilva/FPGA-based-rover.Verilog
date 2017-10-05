`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/28/2017 03:01:38 PM
// Design Name: 
// Module Name: turn
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


module turn(
    input clock,
    input [1:0] isTurning_leftOrRight,
        // isturning_RighOrLeft[0] == if 0, not turning; 
                                // == if 1, turning
        // isturning_RighOrLeft[1] 0 for left, 1 for right
    input stopLongTurning,
    output [3:0] sendToH_Bridge_turn,//,
    output [3:0] sendToH_Bridge_turn_long,
    output isTurning_long_out
    );
    
        
    parameter TURN_RIGHT   =       4'b0101;
    parameter TURN_LEFT    =      4'b1010;
    
    reg [3:0] sendToH_Bridge_turn_reg;
    reg [3:0] sendToH_Bridge_turn_long_reg;
    wire [27:0] countedUpTo_wire;
    wire [27:0] countedUpTo2_wire;
    reg isturning_long_reg;
    
    always@(posedge clock) begin
        if ( countedUpTo_wire < (28'd10000000) ) begin
            if (isTurning_leftOrRight[1]) begin
                    if ( ~isTurning_leftOrRight[0]) begin
                        sendToH_Bridge_turn_reg <= TURN_LEFT;
                    end
                    else begin
                        sendToH_Bridge_turn_reg <= TURN_RIGHT;
                    end
            end //of (isTurning_leftOrRight[1]) begin
        end //of  if ( countedUpTo_wire < (28'd10000000) ) begin
      
    end
    
   always@(posedge clock) begin        
        if ( countedUpTo2_wire < (28'd20000000) ) begin
            if (isTurning_leftOrRight[1]) begin
                    isturning_long_reg <= 1;
                    if ( ~isTurning_leftOrRight[0]) begin
                        sendToH_Bridge_turn_long_reg <= TURN_LEFT;
                        
                    end
                    else begin
                        sendToH_Bridge_turn_long_reg <= TURN_RIGHT;
                    end
            end //  if (isTurning_leftOrRight[1]) begin
            else
                isturning_long_reg <= 0;
                
        if (stopLongTurning)
            isturning_long_reg <= 0;
        else
            isturning_long_reg <= 1;

        end //if ( countedUpTo2_wire < (28'd40000000) ) begin
    end // of    always@(posedge clock) begin
    
    
    counter_up counter_turn(  //counter_up( clk, counterPeriod, countedUpTo )
        .clock(clock), 
        .reset(1'b0),
        .counterPeriod(28'd10000000), //200 ms (gets double the time to complete as it executes half the edges
        .countedUpTo(countedUpTo_wire)
    );
    
       counter_up counter_turn_long(  //counter_up( clk, counterPeriod, countedUpTo )
         .clock(clock), 
         .reset(1'b0),
         .counterPeriod(28'd40000000), //400 ms (gets double the time to complete as it executes half the edges
         .countedUpTo(countedUpTo2_wire)
     );
    assign sendToH_Bridge_turn = sendToH_Bridge_turn_reg;
    assign sendToH_Bridge_turn_long = sendToH_Bridge_turn_long_reg;
    assign isTurning_long_out = isturning_long_reg;

endmodule
