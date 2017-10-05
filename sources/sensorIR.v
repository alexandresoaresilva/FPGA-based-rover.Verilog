`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2017 05:30:08 PM
// Design Name: 
// Module Name: sensorIR
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


module sensorIR(
    input clock,
    input [1:0] IR_sensors,
    output reg IR_sensed
    );
    
    reg [1:0] rebuiltSignal_reg;
    wire [1:0] rising_edge_wire;
    wire [1:0] falling_edge_wire;
    
    signalSync sync_IR0(
            .clock(clock),
            .asynchronous_signal(~IR_sensors[0]),
            .rising_edge(rising_edge_wire[0]),
            .falling_edge(falling_edge_wire[0]) //active low, so falling edge is start of activity
        );
        
     signalSync sync_IR1(
            .clock(clock),
            .asynchronous_signal(~IR_sensors[1]),
            .rising_edge(rising_edge_wire[1]),
            .falling_edge(falling_edge_wire[1]) //active low, so falling edge is start of activity
        );
    always@(posedge clock) begin
            if (rising_edge_wire[0])
                rebuiltSignal_reg[0] <= 1;
            else if (falling_edge_wire[0])
                rebuiltSignal_reg[0] <= 0;
    end
    
    always@(posedge clock) begin
            if (rising_edge_wire[1])
                rebuiltSignal_reg[1] <= 1;
            else if (falling_edge_wire[1])
                rebuiltSignal_reg[1] <= 0;
    end
       
    always@(negedge clock) begin
        if ( rebuiltSignal_reg )
            IR_sensed <= 1;
        else
            IR_sensed <= 0;
    end 
        
endmodule
