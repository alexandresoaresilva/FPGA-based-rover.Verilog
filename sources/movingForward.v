`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 07/17/2017 09:08:58 PM
// Design Name:
// Module Name: decisionMaking
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
//for instantiation
//movingForward U1(
//    .clock(),
//    //boolean
//    .canMove(), //1 - can move; 0 - can't move, waiting for audio signal commandl
//    .isMoving_forward(),//1 - moving forward; 0 - moving in reverse
//    //sensors
//    .sensorIR_front(), //1 - detected vehicule in front of the rover, starts hard stop
//    .sensIP_Front(), //gets inputs from IP sensor module\
//    //current IN1,IN2,IN3, AND IN4 - for keeping the current orientation
//    .presentINs(),
//    .sendToH_BridgeINs(), //sends inputs to routing module
//    .isMoving_Forward_out() //just to make sure it's working
//    );

module movingForward(
    input clock,

    //boolean
    input canMove, //1 - can move; 0 - can't move, waiting for audio signal commandl
    input isMoving_forward,//1 - moving forward; 0 - moving in reverse

    //sensors
    input sensorIR_front, //1 - detected vehicule in front of the rover, starts hard stop
    input [3:0] sensIP_Front, //gets inputs from IP sensor module\

    //current IN1,IN2,IN3, AND IN4 - for keeping the current orientation
    input [3:0] presentINs,

    output [3:0]sendToH_BridgeINs, //sends inputs to routing module
    output isMoving_Forward_out //just to make sure it's working
    );

    //reg [5:0]motorSpeed_out_reg;
    reg [3:0]sendToH_BridgeINs_reg;
    reg [27:0] countTimeStopped_in_clkTicks;
    reg [3:0] intertialStop_reg;
    wire [27:0] countedUpTo_wire;
    reg isMoving_Forward_out_reg;
    //reg notMovingAndWaitingForAudio_reg;

    parameter INTERTIAL_STOP  =   4'b0000;
    parameter HARD_STOP    =      4'b1111;
    parameter FORWARD =           4'b0110;
    parameter REVERSE   =         4'b1001;
    parameter TURN_RIGHT  =       4'b0101;
    parameter TURN_LEFT    =      4'b1010;

//tests for IR sensor and IP sensors
    always@(posedge clock) 
    begin
        if (~sensorIR_front)
            sendToH_BridgeINs_reg <= HARD_STOP;
        else //can or cannot move
        begin 
          if ( canMove ) begin
              if (isMoving_forward ) begin
                    isMoving_Forward_out_reg <= 1;
                    case(sensIP_Front)
                        4'b0000 : sendToH_BridgeINs_reg <= intertialStop_reg;
                        4'b0001 : sendToH_BridgeINs_reg <= TURN_RIGHT;
                        4'b0010 : sendToH_BridgeINs_reg <= TURN_RIGHT;
                        4'b0011 : sendToH_BridgeINs_reg <= TURN_RIGHT;
                        4'b0100 : sendToH_BridgeINs_reg <= TURN_LEFT;
                        4'b0101 : sendToH_BridgeINs_reg <= TURN_RIGHT;
                        4'b0110 : sendToH_BridgeINs_reg <= FORWARD;
                        4'b0111 : sendToH_BridgeINs_reg <= TURN_RIGHT;
                        4'b1000 : sendToH_BridgeINs_reg <= TURN_LEFT;
                        4'b1110 : sendToH_BridgeINs_reg <= TURN_LEFT;
                        default : sendToH_BridgeINs_reg <= sendToH_BridgeINs_reg;
                    endcase
              end // end of if (isMoving_forward )
              else begin //else of  if (isMoving_forward ) == NOT isMoving_forward
                sendToH_BridgeINs_reg <= presentINs;
                isMoving_Forward_out_reg <= 0;
              end
          end // end of if ( canMove )
          else // else of ( canMove ) == NOT canMove
            sendToH_BridgeINs_reg <= INTERTIAL_STOP;
        end // end of can or cannot move
    end //END of always@(posedge clock)

    assign sendToH_BridgeINs = sendToH_BridgeINs_reg;
    assign isMoving_Forward_out = isMoving_Forward_out_reg;
endmodule