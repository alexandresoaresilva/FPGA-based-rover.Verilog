`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:

module mov_forward_v2(
    input clock,
   // input sensorIR_front,
    input [3:0] sensIP_Front, //gets inputs from IP sensor module\
    input [3:0] previousMotion,
    
    output [3:0]sendToH_BridgeINs,//, //sends inputs to routing module
    
    input [1:0] enables_in,
    //input currentSensing,
    
    output [1:0] enables_out,
    output [1:0] isTurning_leftOrRight_out
    );

    parameter INTERTIAL_STOP  =   4'b0000;
    parameter HARD_STOP    =      4'b1111;
    parameter REVERSE =           4'b0110;
    parameter FORWARD   =         4'b1001; 
//    parameter TURN_RIGHT   =       4'b0101; 
//    parameter TURN_LEFT    =      4'b1010;
    parameter TURN_RIGHT   =       4'b1001; 
    parameter TURN_LEFT    =      4'b1001;

    parameter TURNING_LEFT = 2'b01;
    parameter TURNING_RIGHT = 2'b11;
    parameter NOT_TURNING =  2'bX0;
    
    reg [3:0] sendToH_BridgeINs_reg;
    reg [3:0] sendToH_BridgeINs_reg_turning_reg;
    wire [3:0] sendToH_BridgeINs_reg_turning_wire;
    wire [3:0] intertial_stop_wire;
    //wire currentSensing_wire;
    reg [1:0] enables_out_reg;
    reg [1:0] isturning_LeftOrRight_reg;// isturning_RighOrLeft[0] == if 0, not turning; if 1, turning
                                    // isturning_RighOrLeft[1] 0 for left, 1 for right
    wire [3:0] sendToH_BridgeINs_reg_turning_wire;
    
//tests for IR sensor and IP sensors

    always@(posedge clock) 
    begin
//        if (~isturning_wire) begin
//        if (~sensorIR_front)
//            sendToH_BridgeINs_reg <= HARD_STOP;
//        else begin
                case(sensIP_Front)
                    4'b0000 : sendToH_BridgeINs_reg <= intertial_stop_wire;
//                    4'b0000 : sendToH_BridgeINs_reg <= INTERTIAL_STOP;
                    4'b0110 : sendToH_BridgeINs_reg <= FORWARD;
                    4'b1111 : sendToH_BridgeINs_reg <= FORWARD;
                    //turns right
                    4'b0001 : isturning_LeftOrRight_reg <= TURNING_RIGHT;
                    4'b0010 : isturning_LeftOrRight_reg <= TURNING_RIGHT;
                    4'b0011 : isturning_LeftOrRight_reg <= TURNING_RIGHT;
                    4'b0111 : isturning_LeftOrRight_reg <= TURNING_RIGHT;
                    //==========================================================
                    4'b0100 : isturning_LeftOrRight_reg <= TURNING_LEFT;
                    4'b1000 : isturning_LeftOrRight_reg <= TURNING_LEFT;
                    4'b1100 : isturning_LeftOrRight_reg <= TURNING_LEFT;
                    4'b1110 : isturning_LeftOrRight_reg <= TURNING_LEFT;
                    //default : sendToH_BridgeINs_reg <= previousMotion
                    //================================= weird combinations
                    4'b1001 : sendToH_BridgeINs_reg <= previousMotion;
                    4'b1011 : sendToH_BridgeINs_reg <= previousMotion;
                    4'b0101 : sendToH_BridgeINs_reg <= previousMotion;
                    4'b1010 : sendToH_BridgeINs_reg <= previousMotion;
                    4'b1101 : sendToH_BridgeINs_reg <= previousMotion;
                    //===========================================
                    default : sendToH_BridgeINs_reg <= previousMotion;// 4'b0000;
                endcase
                //isturning_LeftOrRight_reg <= 2'b00;
                if (isturning_LeftOrRight_reg[0]) begin //it's TURNING
                    sendToH_BridgeINs_reg = sendToH_BridgeINs_reg_turning_wire;
                end
                else begin//NOT turning 
                     sendToH_BridgeINs_reg = sendToH_BridgeINs_reg;
                     isturning_LeftOrRight_reg = 2'b00;
                end
           // end //end of if for NOT turning
    end //end of always@(posedge clock) 
    
    turn turn_movFrwrd(
        .clock(clock),
        .isTurning_leftOrRight(isturning_LeftOrRight_reg),
            // isturning_RighOrLeft[1] 0 for left, 1 for right
            // isturning_RighOrLeft[0] == if 0, not turning; if 1, turning
        .sendToH_Bridge_turn(sendToH_BridgeINs_reg_turning_wire)
        //.isTurning_out(isturning_wire)
        );
    
    stopping frwd_stop(
            .clock(clock),
            .sensIP(sensIP_Front),
            .present_INs(sendToH_BridgeINs_reg),
            .enables_in(enables_in),
            .enables_out(enables_out),
            .intertial_stop(intertial_stop_wire)
        );
        
    assign enables_out = enables_out_reg;
    assign sendToH_BridgeINs = sendToH_BridgeINs_reg;
    assign isTurning_leftOrRight_out = isturning_LeftOrRight_reg;
endmodule