`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/24/2017 11:24:25 AM
// Design Name: 
// Module Name: movingReverse
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


module movingReverse(

            //boolean
            input clock,
            input canMove, //1 - can move; 0 - can't move, waiting for audio signal commandl
            input isMoving_forward,//1 - moving forward; 0 - moving in reverse
        
            //sensors
            input sensorIR_back, //1 - detected vehicule in front of the rover, starts hard stop
            input [3:0] sensIP_back, //gets inputs from IP sensor module\
        
            //current IN1,IN2,IN3, AND IN4 - for keeping the current orientation
            input [3:0] presentINs,
        
            output [3:0]sendToH_BridgeINs, //sends inputs to routing module
            );
    
    //reg [5:0]motorSpeed_out_reg;
    reg [3:0]sendToH_BridgeINs_reg;
    reg [27:0] countTimeStopped_in_clkTicks;
    reg [3:0] intertialStop_reg;
    wire [27:0] countedUpTo_wire;
    reg presentINs_reg;
    
    parameter INTERTIAL_STOP  =   4'b0000;
    parameter HARD_STOP    =      4'b1111;
    parameter FORWARD =           4'b0110;
    parameter REVERSE   =         4'b1001;
    parameter TURN_RIGHT  =       4'b0101;
    parameter TURN_LEFT    =      4'b1010;
    parameter COUNT_PERIOD_HALF_SEC = 28'd25000000; //divides the clock to get 2 Hz (on posedge only), 0.5 sec period
    
    
    //tests for IR sensor and IP sensors
        always@(posedge clock) 
        begin
            if (~sensorIR_back)
                sendToH_BridgeINs_reg <= HARD_STOP;
            else //can or cannot move
            begin 
              if ( canMove ) begin
                  if (~isMoving_forward ) 
                  begin
                        case(sensIP_back)
                            4'b0000 : sendToH_BridgeINs_reg <= intertialStop_reg;
                            4'b0001 : sendToH_BridgeINs_reg <= TURN_LEFT; 
                            4'b0010 : sendToH_BridgeINs_reg <= TURN_LEFT; 
                            4'b0011 : sendToH_BridgeINs_reg <= TURN_LEFT;
                            4'b0100 : sendToH_BridgeINs_reg <= TURN_RIGHT; 
                            4'b0101 : sendToH_BridgeINs_reg <= TURN_LEFT; 
                            4'b0110 : sendToH_BridgeINs_reg <= REVERSE; 
                            4'b0111 : sendToH_BridgeINs_reg <= TURN_LEFT; 
                            4'b1000 : sendToH_BridgeINs_reg <= TURN_RIGHT; 
                            4'b1110 : sendToH_BridgeINs_reg <= TURN_RIGHT; 
                            default : sendToH_BridgeINs_reg <= sendToH_BridgeINs_reg;
                        endcase
                  end // end of if (isMoving_forward )
                  else //else of  if (isMoving_forward ) == NOT isMoving_forward
                  begin
                    sendToH_BridgeINs_reg <= presentINs_reg;
                  end
              end // end of if ( canMove )
              else // else of ( canMove ) == NOT canMove
                sendToH_BridgeINs_reg <= INTERTIAL_STOP;
            end // end of can or cannot move
        end //END of always@(posedge clock)
    
 
        assign sendToH_BridgeINs = sendToH_BridgeINs_reg;
        //assign notMovingAndWaitingForAudio = notMovingAndWaitingForAudio_reg;
    endmodule