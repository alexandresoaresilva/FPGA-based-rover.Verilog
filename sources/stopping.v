`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/24/2017 06:40:43 PM
// Design Name: 
// Module Name: stopping
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


module stopping(
        input clock,
        input [3:0] present_INs,
        output stoppedAndWaitingForDetection //boolean
    );
    
    reg waitingForAudioSignal_reg;
    wire [27:0] countedUpTo_wire;
    reg [3:0] isStopped;
    
    parameter COUNT_PERIOD_HALF_SEC = 28'd200000000;
    parameter P_25_MILLI_SEC = COUNT_PERIOD_HALF_SEC >> 1;
    parameter P_12_MILLI_SEC = COUNT_PERIOD_HALF_SEC >> 2;
    parameter P_38_MILLI_SEC = P_12_MILLI_SEC + P_25_MILLI_SEC; //ACTUALLy 37.5 ms
    
    
    always@(posedge clock)begin //tests for intersections
        if ( countedUpTo_wire > 0 && countedUpTo_wire < P_12_MILLI_SEC ) begin
            if ( present_INs == 4'b0000 ) 
                isStopped[0] <= 1;
            else
                isStopped[0] <= 0;
        end
        
        else if ( countedUpTo_wire > P_12_MILLI_SEC && countedUpTo_wire < P_25_MILLI_SEC ) begin
            if ( present_INs == 4'b0000 ) 
                isStopped[1] <= 1;
            else
                isStopped[1] <= 0;     
        end
        else if ( countedUpTo_wire > P_25_MILLI_SEC && countedUpTo_wire < P_38_MILLI_SEC ) begin
            if ( present_INs == 4'b0000 ) 
                isStopped[2] <= 1;
            else
                isStopped[2] <= 0;
        end
        
        else if ( P_38_MILLI_SEC > P_25_MILLI_SEC && countedUpTo_wire < COUNT_PERIOD_HALF_SEC ) begin
            if ( present_INs == 4'b0000 ) 
                isStopped[3] <= 1;
            else
                isStopped[3] <= 0;            
        end
        
        if ( isStopped == 4'b1111 )
            waitingForAudioSignal_reg <= 1'b1;
        else
            waitingForAudioSignal_reg <= 1'b0;
    end //end of always@(posedge clock) begin
    
    counter_up stopCounter(  //counter_up( clk, counterPeriod, countedUpTo )
        .clock(clock),
        .reset(1'b0),
        .counterPeriod(COUNT_PERIOD_HALF_SEC),//.5 second
        .countedUpTo(countedUpTo_wire)
    );
    
    assign stoppedAndWaitingForDetection = waitingForAudioSignal_reg;
endmodule
