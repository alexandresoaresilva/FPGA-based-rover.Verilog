`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/15/2017 08:37:52 PM
// Design Name: 
// Module Name: H_Bridge_testBench
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

//`define INTERTIAL_STOP    4'b0000
//`define HARD_STOP         4'b1111
//`define FORWARD           4'b0110
//`define REVERSE           4'b1001
//`define TURN_RIGHT        4'b0101
//`define TURN_LEFT         4'b1010

module H_Bridge_testBench(
    );
    reg clock_Main_reg; 
    reg [3:0]movingDirection_reg;  
    reg [5:0]motorSpeed_reg, currentSensing_reg;        
    wire enA_wire, enB_wire, in1_wire, in2_wire, in3_wire, in4_wire;
    //.debugCountedUpTo,
    //wire debugcustom20KHzClock_wire;
    //wire [27:0] countedUpTo_wire;
    //wire [27:0] debugCustomClkCounter_wire;
    //wire [27:0] debugCounterTread1_wire;
    //wire [27:0] debugCounterTread2_wire;
    
    parameter INTERTIAL_STOP  =   4'b0000;
    parameter HARD_STOP    =      4'b1111;
    parameter FORWARD =           4'b0110;
    parameter REVERSE   =         4'b1001;
    parameter TURN_RIGHT  =       4'b0101;
    parameter TURN_LEFT    =      4'b1010;
        
    // [2:0] motorSpeed == first rover tread
        // [5:3] motorSpeed == second rover tread
    
    H_Bridge_v2 H1(
    .clock(clock_Main_reg),
    .movingDirection(movingDirection_reg),
    .motorSpeed(motorSpeed_reg),
    .currentSensing(currentSensing_reg),
    .enA(enA_wire), 
    .enB(enB_wire),
    .in1(in1_wire),
    .in2(in2_wire),
    .in3(in3_wire),
    .in4(in4_wire)
//    .debugCounterTread1(debugCounterTread1_wire),
//    .debugCounterTread2(debugCounterTread2_wire),
//    .debugCustomClkCounter(debugCustomClkCounter_wire),
//    .debugcustom20KHzClock(debugcustom20KHzClock_wire)
    );
    
    initial
    begin
        clock_Main_reg <= 0;
        //debugcustom20KHzClock <=0;
       // [3:0]
        movingDirection_reg <= INTERTIAL_STOP;
        motorSpeed_reg[2:0] <= 3'b000;
        motorSpeed_reg[5:3] <= 3'b000; 
        currentSensing_reg <= 0;
        //{enA_wire, enB_wire, in1_wire, in2_wire, in3_wire, in4_wire} = 6'b000000;
        #10
        
        movingDirection_reg <= FORWARD;
        motorSpeed_reg[2:0] <= 3'b111;
        motorSpeed_reg[5:3] <= 3'b111; 
        currentSensing_reg <= 0;
        #500000
        
        movingDirection_reg <= REVERSE;
        motorSpeed_reg[2:0] <= 3'b110;
        motorSpeed_reg[5:3] <= 3'b110; 
        currentSensing_reg <= 0;
        #500000
        
        movingDirection_reg <= TURN_RIGHT;
        motorSpeed_reg[2:0] <= 3'b101;
        motorSpeed_reg[5:3] <= 3'b101; 
        currentSensing_reg <= 0;
        #500000
        
        movingDirection_reg <= TURN_LEFT;
        motorSpeed_reg[2:0] <= 3'b100;
        motorSpeed_reg[5:3] <= 3'b100; 
        currentSensing_reg <= 0;  
        #500000
        
        movingDirection_reg <= TURN_LEFT;
        motorSpeed_reg[2:0] <= 3'b111;
        motorSpeed_reg[5:3] <= 3'b111; 
        currentSensing_reg <= 1;
        #500000
        
        movingDirection_reg <= FORWARD;
        motorSpeed_reg[2:0] <= 3'b011;
        motorSpeed_reg[5:3] <= 3'b011; 
        currentSensing_reg <= 0;
        #500000
        
        movingDirection_reg <= FORWARD;
        motorSpeed_reg[2:0] <= 3'b110;
        motorSpeed_reg[5:3] <= 3'b110; 
        currentSensing_reg <= 0;
        #500000
        
        movingDirection_reg <= FORWARD;
        motorSpeed_reg[2:0] <= 3'b111;
        motorSpeed_reg[5:3] <= 3'b111; 
        currentSensing_reg <= 0;
        #500000
        
        movingDirection_reg <= INTERTIAL_STOP;
        motorSpeed_reg[2:0] <= 3'b000;
        motorSpeed_reg[5:3] <= 3'b000; 
        currentSensing_reg <= 0;
    end

    
    always
        #1 clock_Main_reg = ~clock_Main_reg;
        
endmodule
