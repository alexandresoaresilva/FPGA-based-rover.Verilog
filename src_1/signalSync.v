`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Alexandre Soares
// 
// Create Date: 07/11/2017 05:46:43 PM
// Design Name: 
// Module Name: signalSync
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// //Code from https://www.doulos.com/knowhow/fpga/synchronisation/downloads/edge_detect.v
// rising edge of the signal --> one rising edge for identification -- > then another for the "rising_edge" high
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////

//just variable names were modified
module signalSync(
    input clock,
    input asynchronous_signal,
    output rising_edge,
    output falling_edge
);

  reg [1:3] resync;
  reg fall, rise;
    
  initial 
  begin
    fall <= 0;
    rise <= 0;
    resync <= 0;
  end
  
  //sampling frequency must be double
  //two clock cycles from signal to get a logical high
  
  always @(posedge clock)
  begin
    // detect rising and falling edges.
    // rise <= resync[2] & !resync[3];
    fall <= resync[3] & !resync[2];
    rise <= resync[2] & !resync[3];
    // update history shifter.
    resync <= {asynchronous_signal , resync[1:2]};
  end
  
  
  assign rising_edge = rise;
  assign falling_edge = fall;
endmodule