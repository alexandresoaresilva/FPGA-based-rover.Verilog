`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/24/2017 05:43:43 PM
// Design Name: 
// Module Name: deciding_H_BridgeCommands
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


module routing_H_BridgeCommands(
    input clock,
    input [1:0] isMoving_isItForward,//0 - is it moving?, 1 -is it in the forward direction
    input canMove,
    input [7:0] sensIP,//0-3 front, 4-7 back
    input [1:0] sensIR_frontBack, //0 is front, 1 is back
    //input [3:0] mic_decision,
    output [3:0] movingDirection_finalDecision
    //output canMove
    );
    reg movingDirection_finalDecision_reg;
    wire sendToH_BridgeINs_Forward_wire;
    wire sendToH_BridgeINs_Reverse_wire;
    parameter DEFAULT_FORWARD = 4'b0110;
    
    
    reg [3:0] sensIP_reg;
    

     
     
     always@(posedge clock) begin
        if (isMoving_isItForward[1])
            sensIP_reg <= sensIP[3:0];
            movingDirection_finalDecision_reg <= sendToH_BridgeINs_Forward_wire;
        else
            sensIP_reg = sensIP[7:4];
            movingDirection_finalDecision_reg <= sendToH_BridgeINs_Reverse_wire
        end
    
    assign movingDirection_finalDecision = movingDirection_finalDecision_reg; 
endmodule
