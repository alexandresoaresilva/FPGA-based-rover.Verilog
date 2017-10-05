`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2017 06:41:54 PM
// Design Name: 
// Module Name: signalSync_testBench
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

    
module signalSync_testBench();
    
      reg clk, async = 0; 
      wire rise, fall;
    
          signalSync UUT(
          .clock(clk),
          .asynchronous_signal(async),
          .rising_edge(rise),
          .falling_edge(fall)
      );
    
    initial begin
    
        
     clk <= 0;
      async <= 0;
    end
    
    // Produce a randomly-changing async signal.
    
      //integer seed = 1;
       time delay = 0;      
    
    initial
    begin
      while ($time < 1000) 
      begin @(negedge clk)
        // wait for a random number of ns
        delay = $dist_uniform(2,50,150);
        #delay;
        async = ~async;
      end
    end
    
    always
    begin
        #10
        clk = ~clk;
    end
    
    endmodule