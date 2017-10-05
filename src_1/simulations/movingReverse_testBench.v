`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/24/2017 11:28:57 AM
// Design Name: 
// Module Name: movingReverse_testBench
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


module movingReverse_testBench(
    );
    
    reg clock;
    reg canMove_reg;
    reg isMoving_forward_reg;
    reg sensorIR_back_reg;
    reg [3:0] sensIP_back_reg;
    reg [3:0] presentINs_Reg;
    wire [3:0]sendToH_BridgeINs_wire;
    wire isMoving_out_wire;
    
    movingReverse testU1(
        .clock(clock),
        .canMove(canMove_reg),
        .isMoving_forward(isMoving_forward_reg),
        .sensorIR_back(sensorIR_back_reg),
        .sensIP_back(sensIP_back_reg),
        .presentINs(presentINs_Reg),
        .sendToH_BridgeINs(sendToH_BridgeINs_wire),
        .isMoving_out(isMoving_out_wire)
        //.notMovingAndWaitingForAudio(notMovingAndWaitingForAudio_reg)
        );
       
    initial begin
        clock <= 0;
        canMove_reg <= 1'b1;
        isMoving_forward_reg <= 1'b0;
        sensIP_back_reg  <= 4'b0000;
        sensorIR_back_reg <= 1'b0;
        //notMovingAndWaitingForAudio_reg <= 0;
        presentINs_Reg <= 4'b0000;
        
        #200000
        sensIP_back_reg  <= 4'b0000;
        
        #200000 //2 ms for 10 ns clock tick
        sensIP_back_reg  <= 4'b0001;
        
        #200000
        sensIP_back_reg  <= 4'b0010;
        
        #200000
        sensIP_back_reg  <= 4'b0011;
        
        #200000
        sensIP_back_reg  <= 4'b0100;
        
        #200000
        sensIP_back_reg  <= 4'b0101;
        
        #200000
        sensIP_back_reg  <= 4'b0110;
        
        #200000
        sensIP_back_reg  <= 4'b0111;
        
        #200000
        sensIP_back_reg  <= 4'b1000;
        
        #200000
        sensIP_back_reg  <= 4'b1001;
        
        #200000
        sensIP_back_reg  <= 4'b1010;
        
        #200000
        sensIP_back_reg  <= 4'b1011;
        
        #200000
        sensIP_back_reg  <= 4'b1100;
        
        #200000
        sensIP_back_reg  <= 4'b1110;
        
        #200000
        sensIP_back_reg  <= 4'b1111;
        
        #200000
        sensIP_back_reg  <= 4'b0110;
        sensorIR_back_reg <= 1'b1;
        
        #200000
        sensorIR_back_reg <= 1'b0;
        sensIP_back_reg  <= 4'b0000;
        
        //isMoving_in_reg <= 1'b1;
        #550000000
//        sensIP_Front_reg  <= 4'b0001;
//        #200000
        
        //isMoving_in_reg <= 1'b0;
        isMoving_forward_reg <= 1'b0;
        canMove_reg <= 1;
        sensorIR_back_reg <= 1'b0;
        sensIP_back_reg  <= 4'b1001;
        #200000
        isMoving_forward_reg <= 1'b0;
        canMove_reg <= 0;
        sensorIR_back_reg <= 1'b0;
        sensIP_back_reg  <= 4'b0000;
        
    end
    
    always@(posedge clock) begin
        if (~isMoving_out_wire)
            canMove_reg <= 0;
        else
             canMove_reg <= canMove_reg;
    end
    
        always begin
        # 1 clock = ~clock;
        end    
endmodule
