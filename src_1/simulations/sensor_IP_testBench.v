`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/17/2017 05:26:56 PM
// Design Name: 
// Module Name: sensor_IP_testBench
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


module sensor_IP_testBench(
    );
    reg clock;
    reg [3:0]  IPsensFront_in_reg;
    reg [3:0]  IPsensBack_in_reg;
    
    wire [3:0] IPsensFront_out_wire;
    wire [3:0] IPsensBack_out_wire;
    
  //  wire debugIP500HzClock_wire;
    
    initial begin
        clock <= 0;
        IPsensFront_in_reg = 4'b1111;
        IPsensBack_in_reg = 4'b1111;
        #200000
               
        IPsensFront_in_reg <= 4'b0000;
        IPsensBack_in_reg <= 4'b0000;
        #200000

        IPsensFront_in_reg <= 4'b1000;
        IPsensBack_in_reg <=  4'b0001;
        #200000
        
        IPsensFront_in_reg <= 4'b0100;
        IPsensBack_in_reg <= 4'b0010;
        #200000

        IPsensFront_in_reg <= 4'b0100;
        IPsensBack_in_reg <=  4'b0010;
        #200000
        
        IPsensFront_in_reg <= 4'b0000;
        IPsensBack_in_reg <=  4'b0000;
    end
    
    sensor_IP_v2 ip_U1(
        .clock(clock),
        .IPsensFront_in(IPsensFront_in_reg),
        .IPsensBack_in(IPsensBack_in_reg),
        .IPsensFront_out(IPsensFront_out_wire),
        .IPsensBack_out(IPsensBack_out_wire)
       // .debugIP500HzClock(debugIP500HzClock_wire)
   );
   
   always begin
       #1 clock = ~clock;
   end
   
endmodule
