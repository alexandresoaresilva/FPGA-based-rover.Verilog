`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/02/2017 04:13:57 PM
// Design Name: 
// Module Name: BasysConnections_testBench
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


module BasysConnections_testBench(
    );
        reg clock;
        //reg [15:0] SW;
        reg [3:0] IPsensFront_in;
        reg [3:0] IPsensBack_in;
        
        wire [1:0] motorSpeed;
        wire [3:0] movingDirection;
    
    basysConnections UUT(
        .clock(clock),
        //.SW(SW),
        .JA8(motorSpeed[1]),
        .JA7(motorSpeed[0]),
        .JA4(movingDirection[3]),
        .JA3(movingDirection[2]),
        .JA2(movingDirection[1]),
        .JA1(movingDirection[0]), //MSB to LSB

        .JC1(IPsensFront_in[0]),
        .JC2(IPsensFront_in[1]),
        .JC3(IPsensFront_in[2]),
        .JC4(IPsensFront_in[3]),
        
//        .JC7(IPsensBack_in[0]),
//        .JC8(IPsensBack_in[1]), //MSB to LSB
//        .JC9(IPsensBack_in[2]),
//        .JC10(IPsensBack_in[3]) //MSB to LSB
        );
         
        
//        initial
//        begin
//            //SW <= 0;
//            clock <= 0;
////            SW <= 16'b1000000000000000;
//            #1000000
////            SW <= 16'b1000100111111111; //100%
//            #1000000
////            SW <= 16'b1000101000010001; //25%
//            #1000000
////            SW <= 16'b1000011000100001; //25% and 50%
//            #1000000
////            SW <= 16'b1000011000100010; //50% 
//            #1000000
////            SW <= 16'b1000111100010001;
//            #1000000
////            SW <= 16'b1000111100100010;
//        end

     initial begin
        clock <= 0;
        IPsensFront_in = ~4'b0000;
//        IPsensBack_in = ~4'b0000;
        #1000000
               
        IPsensFront_in <= ~4'b0001;
//        IPsensBack_in <= ~4'b0000;
        #1000000

        IPsensFront_in <= ~4'b0010;
//        IPsensBack_in <=  ~4'b0001;
        #1000000
        
        IPsensFront_in <= ~4'b0100;
//        IPsensBack_in <= ~4'b0010;
        #1000000

        IPsensFront_in <= ~4'b0110;
//        IPsensBack_in <=  ~4'b0010;
        #1000000
        
        IPsensFront_in <= ~4'b0111;
//        IPsensBack_in <=  ~4'b0000;
        #1000000
        IPsensFront_in <= ~4'b1000;
    end

        
        always begin
            #1 clock = ~clock;
        end     
    
endmodule
