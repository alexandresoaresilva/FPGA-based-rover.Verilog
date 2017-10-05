`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2017 05:49:31 PM
// Design Name: 
// Module Name: sync_rebuiltSignal
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
//////////////////////////////////////////////////////////////////////////////////

module sync_rebuiltSignal(
    input clock,
    input [3:0] sensors,
    output [3:0] rebuiltSignal
    );
    
    reg [3:0] rebuiltSignal_reg;
    wire [3:0] rising_edge_wire;
    wire [3:0] falling_edge_wire;    
    
    //syncing sensors /////////////
    signalSync sync_reb0(
        .clock(clock),
        .asynchronous_signal(sensors[0]),
        .rising_edge(rising_edge_wire[0]),
        .falling_edge(falling_edge_wire[0]) //active low, so falling edge is start of activity
    );
    always@(posedge clock) begin
        if (rising_edge_wire[0])
            rebuiltSignal_reg[0] <= 1;
        else if (falling_edge_wire[0])
            rebuiltSignal_reg[0] <= 0; 
//        else
//            rebuiltSignal_reg[0] <= rebuiltSignal_reg[0]; 

    end
    
    signalSync sync_reb1(
        .clock(clock),
        .asynchronous_signal(sensors[1]),
        .rising_edge(rising_edge_wire[1]),
        .falling_edge(falling_edge_wire[1]) //active low, so falling edge is start of activity
    );
    
    always@(posedge clock) begin
        if (rising_edge_wire[1])
            rebuiltSignal_reg[1] <= 1;
        else if (falling_edge_wire[1])
            rebuiltSignal_reg[1] <= 0; 
//        else
//            rebuiltSignal_reg[1] <= rebuiltSignal_reg[1]; 

    end
    
    signalSync sync_reb2(
        .clock(clock),
        .asynchronous_signal(sensors[2]),
        .rising_edge(rising_edge_wire[2]),
        .falling_edge(falling_edge_wire[2]) //active low, so falling edge is start of activity
    );
    
    always@(posedge clock) begin
        if (rising_edge_wire[2])
            rebuiltSignal_reg[2] <= 1;
        else if (falling_edge_wire[2])
            rebuiltSignal_reg[2] <= 0;
//        else
//            rebuiltSignal_reg[2] <= rebuiltSignal_reg[2]; 
 
    end
    
    signalSync sync_reb3(
        .clock(clock),
        .asynchronous_signal(sensors[3]),
        .rising_edge(rising_edge_wire[3]),
        .falling_edge(falling_edge_wire[3]) //active low, so falling edge is start of activity
    );
    
    always@(posedge clock) begin
        if (rising_edge_wire[3])
            rebuiltSignal_reg[3] <= 1;
        else if (falling_edge_wire[3])
            rebuiltSignal_reg[3] <= 0; 
//        else
//            rebuiltSignal_reg[3] <= rebuiltSignal_reg[3]; 
    end
    
    
    assign rebuiltSignal = rebuiltSignal_reg;
endmodule
