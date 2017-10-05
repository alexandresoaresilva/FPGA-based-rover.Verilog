`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/17/2017 12:44:52 PM
// Design Name: 
// Module Name: sensor_IP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//  inverts inputs to get active high logical outputs
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module sensor_IP_v2(
    input clock,
    input [3:0]  IPsensFront_in,
    input [3:0]  IPsensBack_in,
    
    output [3:0] IPsensFront_out,
    output [3:0] IPsensBack_out
);
    reg [3:0] IPsensFront_reg;
    reg [3:0] IPsensBack_reg;
    wire [3:0] IPsensFront_synced_wire;
    wire [3:0] IPsensBack_synced_wire;
    
    always@(posedge clock) begin 
        IPsensFront_reg <= ~IPsensFront_in;
        IPsensBack_reg <= ~IPsensBack_in;
    end
     
    sync_rebuiltSignal sycIP_front(
        .clock(clock),
        .sensors(IPsensFront_reg),
        .rebuiltSignal(IPsensFront_synced_wire)
        );
    
    sync_rebuiltSignal sycIP_back(
        .clock(clock),
        .sensors(IPsensBack_reg),
        .rebuiltSignal(IPsensBack_synced_wire)
        );        

    assign IPsensFront_out = IPsensFront_synced_wire;//front sensors
    assign IPsensBack_out = IPsensBack_synced_wire;
endmodule