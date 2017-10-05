`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/01/2017 06:23:34 PM
// Design Name: 
// Module Name: switch_testBench
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


module switch_testBench(
    );
    
    reg clock;
    reg [3:0] SW;
    wire [3:0] switchesUp;
    wire PWM_pulse;
    
    switch UUT(
        .clock(clock),
        .SW(SW),
        .switchesUp(switchesUp)
    );
    
    PWM pwmInst(
        .clock(clock),
        .enable(1),
        .speed(SW),
        .PWM_pulse(PWM_pulse)
     );
     
    initial
    begin
        clock <=0;
        SW <= 0;
        #10
        SW <= 1;
        #1000001
        SW <= 2;
        #1000001
        SW <= 3;
        #1000001
        SW <= 4;
        #1000001
        SW <= 0;
    end
    
//    initial
//    begin

//    SW <= 4'b0001;
//    #100
//    SW <= 4'b0010;
//    #100
//    SW <= 4'b0011;
//    #100
//    SW <= 4'b0100;
//    #100
//    SW <= 4'b0101;
//    #100
//    SW <= 4'b0110;
//    #100
//    SW <= 4'b0111;
//    #100
//    SW <= 4'b1000;
//    #100
//    SW <= 4'b1001;
//    #100
//    SW <= 4'b1010;
//    #100
//    SW <= 4'b1011;
//    #100
//    SW <= 4'b1100;
//    #100
//    SW <= 4'b1101;
//    #100
//    SW <= 4'b1110;
//    #100
//    SW <= 4'b1111;
//    #100
//    SW <= 4'b0110;
//    #100
//    SW <= 4'b1001;
//    #100
//    SW <= 4'b0001;
//    #100
//    SW <= 4'b0000;
    
//    end
    
    
    always begin
    #1 clock = ~clock; //1 tick is equivalent to 10^-8 s (period of 100 MHz)
    end
    
    
    
endmodule