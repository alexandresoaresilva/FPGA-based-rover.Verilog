`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2017 06:13:09 PM
// Design Name: 
// Module Name: freqDetect
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
module freqDetect(
    input clock,
    input micInput,
    input stoppedAndWaitingForDetection,
    input [7:0] IP_sensors,
    input [31:0] previousTimeForTogglingReverse_in, 
    output [3:0] virtual_IPsensors,
    output isStoppedAndDetecting_out,
    output [31:0] previousTimeForTogglingReverse_out,
    output reverse
    );
    
    parameter PERIOD = 28'd10000000;
    parameter PERIOD_PREVENTING_FAST_TOGGLING = 32'd50000000; 
    parameter QUARTER_PERIOD_PREVENTING_FAST_TOGGLING =  PERIOD_PREVENTING_FAST_TOGGLING >> 2;
    parameter HALF_PERIOD = PERIOD >> 1;
    parameter QUARTER_PERIOD = PERIOD >> 2;
    parameter T_2X_PERIOD = PERIOD << 1;
    parameter T_2X_and_HALF_PERIOD = T_2X_PERIOD + HALF_PERIOD;
    parameter T_3X_PERIOD = PERIOD + T_2X_PERIOD;
    parameter T_3X_and_HALF_PERIOD = T_3X_PERIOD + HALF_PERIOD;
    parameter T_4X_PERIOD = PERIOD << 2;
    parameter T_4X_and_QUARTER_PERIOD = T_4X_PERIOD + QUARTER_PERIOD;    
    parameter T_5X_PERIOD = PERIOD + (PERIOD << 2); 
    parameter T_5X_AND_QUARTER_PERIOD = T_5X_PERIOD + QUARTER_PERIOD;
    parameter T_5X_AND_HALF_PERIOD = T_5X_PERIOD + HALF_PERIOD;
    parameter T_6X_PERIOD = T_3X_PERIOD << 2;
    parameter T_7X_PERIOD = T_2X_PERIOD + T_5X_PERIOD;
    
    
    reg [3:0] movDirec_isTurning_leftRight_reg;
    reg [3:0] virtual_IPsensors_reg;
    reg isStoppedAndDetecting_out_reg;
    reg [31:0] previousTogglingTime_reg;
        //movDirec_isTurning_leftRight[3] == 1 : moving; 0 : not moving
        //movDirec_isTurning_leftRight[2] == 1 : forward; 0 : reverse
        //movDirec_isTurning_leftRight[1] == 1 : turning; 0 : not turning
        //movDirec_isTurning_leftRight[0] == 1 : right turn; 0 : left turn
    
    reg [27:0]  micHighs_0_reg = 28'd0;
    reg [27:0]  micHighs_1_reg = 28'd0;
    reg [27:0]  micHighs_2_reg = 28'd0;
    reg reverse_reg;
//    reg reset_32b_counter;
    
    wire [27:0] countedUpTo_wire; 
    wire rising_edge_wire, falling_edge_wire;
    wire [31:0] countedUpTo_32bit_wire;
    
    signalSync sync_reb1(
        .clock(clock),
        .asynchronous_signal(micInput),
        .rising_edge(rising_edge_wire),
        .falling_edge(falling_edge_wire) //active low, so falling edge is start of activity
    );
    
    always@(posedge clock) begin
        if (~IP_sensors ) begin // IP 00000
            
            if (stoppedAndWaitingForDetection) begin
                isStoppedAndDetecting_out_reg <= 1'b1;
                if ( (countedUpTo_wire > 25 ) && (countedUpTo_wire < PERIOD ) ) begin
                     if (rising_edge_wire)
                        micHighs_0_reg <= micHighs_0_reg + 1;
                     else
                        micHighs_0_reg <= micHighs_0_reg;
                end
                else if ( (countedUpTo_wire > PERIOD ) && (countedUpTo_wire < T_2X_PERIOD ) ) begin
                     if (rising_edge_wire)
                       micHighs_1_reg <= micHighs_1_reg + 1;
                     else
                       micHighs_1_reg <= micHighs_1_reg;
                end
                else if ( (countedUpTo_wire > T_2X_PERIOD ) && (countedUpTo_wire < T_3X_PERIOD  ) ) begin
                     if (rising_edge_wire)
                       micHighs_2_reg <= micHighs_2_reg + 1;
                     else
                       micHighs_2_reg <= micHighs_2_reg;
                end
                else if ( (countedUpTo_wire > T_3X_PERIOD ) && (countedUpTo_wire < (T_4X_PERIOD-200) ) ) begin
                    if ( ( micHighs_0_reg > 28'd45 && micHighs_0_reg < 28'd60 ) && ( micHighs_1_reg > 28'd45 && micHighs_1_reg < 28'd60)  && ( micHighs_2_reg > 28'd45 && micHighs_2_reg < 28'd60) ) 
                    begin
//                        reset_32b_counter <= 1;
                        if (~reverse_reg)
                            virtual_IPsensors_reg <= 4'b0110;
                        else
                            virtual_IPsensors_reg <= 4'b1001; //runs in reverse if reverseis activated
                    end
                    else if ( ( micHighs_0_reg > 28'd85 && micHighs_0_reg < 28'd120 ) && ( micHighs_1_reg > 28'd85 && micHighs_1_reg < 28'd120) && ( micHighs_2_reg > 28'd85 && micHighs_2_reg < 28'd120)  ) 
                    begin
//                        reset_32b_counter <= 1;
                        if (~reverse_reg)
                            virtual_IPsensors_reg <= 4'b1000;
                        else
                            virtual_IPsensors_reg <= 4'b0001; //turns to the other side
                    end
                    else if ( ( micHighs_0_reg > 28'd180 && micHighs_0_reg < 28'd220 ) && ( micHighs_1_reg > 28'd180 && micHighs_1_reg < 28'd220) && ( micHighs_2_reg > 28'd180 && micHighs_2_reg < 28'd220)  ) 
                    begin
//                        reset_32b_counter <= 1;
                        if (~reverse_reg)
                            virtual_IPsensors_reg <= 4'b0001;
                        else
                            virtual_IPsensors_reg <= 4'b1000; //turns to the other side
                   end
                   else if ( ( micHighs_0_reg > 28'd280 && micHighs_0_reg < 28'd320 ) && ( micHighs_1_reg > 28'd280 && micHighs_1_reg < 28'd320) && ( micHighs_2_reg > 28'd280 && micHighs_2_reg < 28'd320)  ) 
                   begin
                        if ( countedUpTo_32bit_wire > 32'd1 && countedUpTo_32bit_wire < 32'd3  ) begin   
                             if (~reverse_reg) begin 
                                reverse_reg <= 1;
                                virtual_IPsensors_reg <= IP_sensors[7:4];
                            end
                            else begin
                                reverse_reg <= 0;
                                virtual_IPsensors_reg <= IP_sensors[3:0];
                            end
//                            previousTogglingTime_reg <= countedUpTo_32bit_wire; //new toggling time
                        end
                        else begin
                            virtual_IPsensors_reg <= virtual_IPsensors_reg;
                            reverse_reg <= reverse_reg;
                        end     
                    end
                    else begin //default behavior
//                        reset_32b_counter <= 0;
                        if (~reverse_reg)
                            virtual_IPsensors_reg <= IP_sensors[3:0];
                        else
                            virtual_IPsensors_reg <= IP_sensors[7:4];
                    end
                end
                else if (  (countedUpTo_wire > (T_4X_PERIOD-199) ) && ( countedUpTo_wire < T_4X_PERIOD-100 ) ) begin
                    micHighs_0_reg <= 28'd0;
                    micHighs_1_reg <= 28'd0;
                    micHighs_2_reg <= 28'd0;
//                    reset_32b_counter <= 0;
                end
            end
            else begin 
                isStoppedAndDetecting_out_reg <= 1'b0;
//                reset_32b_counter <= 1;
            end
        end
    end
    
    counter_up counter_freqDetect(  //counter_up( clk, counterPeriod, countedUpTo )
        .clock(clock), 
        .reset(0),
        .counterPeriod(T_4X_PERIOD), //gets only posedges, lasts 10 ms
        .countedUpTo(countedUpTo_wire)
    );

    
    counterUp_32bit counter_32bit_freqDetect2(  //counter_up( clk, counterPeriod, countedUpTo )
            .clock(clock), 
            .reset(0),
            .counterPeriod(PERIOD_PREVENTING_FAST_TOGGLING), //gets only posedges, lasts 10 ms
            .countedUpTo(countedUpTo_32bit_wire)
        );
    assign virtual_IPsensors = virtual_IPsensors_reg;
   assign isStoppedAndDetecting_out = isStoppedAndDetecting_out_reg;
   assign reverse = reverse_reg;
   assign previousTimeForTogglingReverse_out = previousTogglingTime_reg;
endmodule