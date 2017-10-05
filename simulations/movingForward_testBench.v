`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2017 08:23:10 PM
// Design Name: 
// Module Name: movingForward_testBench
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
module movingForward_testBench(
    );
    
    reg clock;
    reg canMove_reg;
    reg isMoving_forward_reg;
    reg [3:0] sensIP_Front_reg;
    reg sensorIR_front_reg;
    reg [3:0] presentINs_reg;
    wire [3:0]sendToH_BridgeINs_wire;
    wire isMoving_out_wire;
    
    movingForward testU1(
        .clock(clock),
        .canMove(canMove_reg),
        .isMoving_forward(isMoving_forward_reg),
        .sensorIR_front(sensorIR_front_reg),
        .sensIP_Front(sensIP_Front_reg),
        .presentINs(presentINs_reg),
        .sendToH_BridgeINs(sendToH_BridgeINs_wire),
        .isMoving_out(isMoving_out_wire)
        );
       
//    initial begin
//        clock <= 0;
//        canMove_reg <= 1'b1;
//        isMoving_forward_reg <= 1'b1;
//        sensIP_Front_reg  <= 4'b0000;
//        sensorIR_front_reg <= 1'b0;
        
//        #200000
//        sensIP_Front_reg  <= 4'b0000;
        
//        #200000 //2 ms for 10 ns clock tick
//        sensIP_Front_reg  <= 4'b0001;
        
//        #200000
//        sensIP_Front_reg  <= 4'b0010;
        
//        #200000
//        sensIP_Front_reg  <= 4'b0011;
        
//        #200000
//        sensIP_Front_reg  <= 4'b0100;
        
//        #200000
//        sensIP_Front_reg  <= 4'b0101;
        
//        #200000
//        sensIP_Front_reg  <= 4'b0110;
        
//        #200000
//        sensIP_Front_reg  <= 4'b0111;
        
//        #200000
//        canMove_reg <= 0;
//        sensIP_Front_reg  <= 4'b1000;
        
//        #200000
//        sensIP_Front_reg  <= 4'b1001;
        
//        #200000
//        sensIP_Front_reg  <= 4'b1010;
        
//        #200000
//        sensIP_Front_reg  <= 4'b1011;
        
//        #200000
//        sensIP_Front_reg  <= 4'b1100;
        
//        #200000
//        sensIP_Front_reg  <= 4'b1110;
        
//        #200000
//        sensIP_Front_reg  <= 4'b1111;
        
//        #200000
//        sensIP_Front_reg  <= 4'b0110;
//        sensorIR_front_reg <= 1'b1;
        
//        #200000
//        sensorIR_front_reg <= 1'b0;
//        sensIP_Front_reg  <= 4'b0000;
        
//        //isMoving_in_reg <= 1'b1;
//        #550000000
////        sensIP_Front_reg  <= 4'b0001;
////        #200000
        
//        //isMoving_in_reg <= 1'b0;
//        isMoving_forward_reg <= 1'b0;
//        sensorIR_front_reg <= 1'b0; 
//    end
    
initial begin
    clock <= 0;
    canMove_reg <= 1'b1;
    isMoving_forward_reg <= 1'b1;
    sensIP_Front_reg  <= 4'b0000;
    presentINs_reg <= 4'b0000; 
    sensorIR_front_reg <= 1'b0;
    //notMovingAndWaitingForAudio_reg <= 0;
    
    
    #200000
    sensIP_Front_reg  <= 4'b0000;
    
    #200000 //2 ms for 10 ns clock tick
    sensIP_Front_reg  <= 4'b0001;
    
    #200000
    sensIP_Front_reg  <= 4'b0010;
    
    #200000
    sensIP_Front_reg  <= 4'b0011;
    
    #200000
    sensIP_Front_reg  <= 4'b0100;
    
    #200000
    sensIP_Front_reg  <= 4'b0101;
    
    #200000
    sensIP_Front_reg  <= 4'b0110;
    
    #200000
    sensIP_Front_reg  <= 4'b0111;
    
    #200000
    sensIP_Front_reg  <= 4'b1000;
    
    #200000
    sensIP_Front_reg  <= 4'b1001;
    
    #200000
    sensIP_Front_reg  <= 4'b1010;
    
    #200000
    isMoving_forward_reg <= 1'b0;
    sensIP_Front_reg  <= 4'b1011;
    presentINs_reg <= 4'b1001; 
    
    #200000
    isMoving_forward_reg <= 1'b1;
    sensIP_Front_reg  <= 4'b1100;
    
    #200000
    sensIP_Front_reg  <= 4'b1110;
    
    #200000
    sensIP_Front_reg  <= 4'b1111;
    
    #200000
    sensIP_Front_reg  <= 4'b0110;
    sensorIR_front_reg <= 1'b1;
    
    #200000
    sensorIR_front_reg <= 1'b0;
    sensIP_Front_reg  <= 4'b0000;
    
    //isMoving_in_reg <= 1'b1;
    #800000000
//        sensIP_Front_reg  <= 4'b0001;
//        #200000
    
    //isMoving_in_reg <= 1'b0;
    canMove_reg <= 1;
    isMoving_forward_reg <= 1'b1;
    //sensorIR_front_reg <= 1'b0;
    sensIP_Front_reg  <= 1'b1001;
end
    
    always@(posedge clock) begin //simulates input from decision making module
        if (~isMoving_out_wire) begin
            canMove_reg <= 0;
        end
        else begin
            canMove_reg <= 1;
        end
        end
        
////    always@(posedge clock) begin
//        if ( isMoving_forward_reg )
//            presentINs_reg <= sendToH_BridgeINs_wire;
//        else
//            presentINs_reg <= presentINs_reg;
//    end
    always begin
        # 1 clock = ~clock;
    end
endmodule
