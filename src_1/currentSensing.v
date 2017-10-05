`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2017 11:24:33 AM
// Design Name: 
// Module Name: currentSensing
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
module currentSensing(
    input clock,
    input [1:0] currentSensA_B,
    input isTurning,
    output currentOverload
    
    //output sendtoH_Bridge_INs
    );
    
    
    parameter [27:0] TENTH_of_PERIOD = 28'd1000000;
    
    parameter [27:0] PERIOD = ( TENTH_of_PERIOD << 3 ) + ( TENTH_of_PERIOD << 1);
    parameter [27:0] HALF_PERIOD = PERIOD >> 1;
    parameter [27:0]  QUARTER_PERIOD = PERIOD >> 2;
    parameter [27:0] t_13_PERC_PERIOD = PERIOD >> 2;
    
    parameter [27:0] T_2X_PERIOD = PERIOD << 1;
    parameter [27:0]  T_2X_and_HALF_PERIOD = T_2X_PERIOD + HALF_PERIOD;
    parameter [27:0] T_3X_PERIOD = PERIOD + T_2X_PERIOD;
    parameter [27:0] T_3X_and_HALF_PERIOD = T_3X_PERIOD + HALF_PERIOD;
    parameter [27:0] T_4X_PERIOD = PERIOD << 2;
    parameter [27:0] T_4X_and_QUARTER_PERIOD = T_4X_PERIOD + QUARTER_PERIOD;    
    parameter [27:0] T_5X_PERIOD = T_3X_PERIOD + T_2X_PERIOD;
    parameter [27:0] T_5X_AND_QUARTER_PERIOD = T_5X_PERIOD + QUARTER_PERIOD;
    parameter [27:0] T_5X_AND_HALF_PERIOD = T_5X_PERIOD + HALF_PERIOD;
    parameter [27:0] T_6X_PERIOD = T_3X_PERIOD << 2;
    parameter [27:0] T_7X_PERIOD = T_2X_PERIOD + T_5X_PERIOD;
    
    
    parameter MAX_CURRENT_PERIOD =  TENTH_of_PERIOD << 1;
//    parameter MAX_CURRENT_PERIOD = ( TENTH_of_PERIOD << 3 ); //80%
//    parameter MAX_CURRENT_PERIOD = TENTH_of_PERIOD << 2; //40%
//    parameter MAX_CURRENT_PERIOD = (TENTH_of_PERIOD << 2) + (TENTH_of_PERIOD >> 1); //45%
//    parameter MAX_CURRENT_PERIOD = HALF_PERIOD;// 50%
//    parameter MAX_CURRENT_PERIOD = HALF_PERIOD + (TENTH_of_PERIOD >> 1); //55%
//      parameter MAX_CURRENT_PERIOD = MAX_CURRENT_80_PERCENT_PERIOD;
//      parameter MAX_CURRENT_PERIOD = HALF_PERIOD + TENTH_of_PERIOD + (TENTH_of_PERIOD >> 1);//65
    reg max_current_period_reg;
       
    reg [1:0] rebuiltSignal_reg;
    reg [27:0] rebuiltSignal_counter_reg;
    reg reset_counter_reg;
    wire [1:0] rising_edge_wire;
    wire [1:0] falling_edge_wire;
    
    reg [1:0] rebuild_Sense;
    
    reg [27:0] counter_currentOverlo_reg_0_0 = 0;
    reg [27:0] counter_currentOverlo_reg_0_1 = 0;
    
    reg currentOverloadOut = 0;
    wire [27:0] countedUpTo_wire;
    
        //syncing sensors /////////////
    signalSync sync_currentOver0(
        .clock(clock),
        .asynchronous_signal(currentSensA_B[0]),
        .rising_edge(rising_edge_wire[0]),
        .falling_edge(falling_edge_wire[0]) //active low, so falling edge is start of activity
    );
    
    signalSync sync_currentOver1(
        .clock(clock),
        .asynchronous_signal(currentSensA_B[1]),
        .rising_edge(rising_edge_wire[1]),
        .falling_edge(falling_edge_wire[1]) //active low, so falling edge is start of activity
    );

    always@(posedge clock) begin
        if (rising_edge_wire[0])
            rebuild_Sense[0] <= 1;
        else if (falling_edge_wire[0])
            rebuild_Sense[0] <= 0;
        else
            rebuild_Sense[0] <= rebuild_Sense[0];
            
        if (rising_edge_wire[1])
            rebuild_Sense[1] <= 1;
        else if (falling_edge_wire[0])
            rebuild_Sense[1] <= 0;
        else
            rebuild_Sense[1] <= rebuild_Sense[1];
    end
    

    always@(negedge clock) begin
        if ( (countedUpTo_wire > 25 ) && (countedUpTo_wire < PERIOD ) ) begin
            if (rebuild_Sense[0])
                counter_currentOverlo_reg_0_0 <= counter_currentOverlo_reg_0_0 + 1;
            else begin
                counter_currentOverlo_reg_0_0 <= counter_currentOverlo_reg_0_0;
            end
            
            if (rebuild_Sense[1])
                counter_currentOverlo_reg_0_1 <= counter_currentOverlo_reg_0_1 + 1;
            else begin
                counter_currentOverlo_reg_0_1 <= counter_currentOverlo_reg_0_1;
            end
        end        
        else if ( (countedUpTo_wire > PERIOD ) && (countedUpTo_wire < (T_2X_PERIOD-500) ) ) begin
           ;    //75% duty cycle
                 if (isTurning)
                    max_current_period_reg <= 28'd2000000;     //87.5% duty cycle
                else
                    max_current_period_reg <= 28'd500000;           //100% duty cycle
                 
            if ( ( counter_currentOverlo_reg_0_0 > max_current_period_reg
                   || counter_currentOverlo_reg_0_1 > max_current_period_reg ) )begin
                currentOverloadOut = 1'b1;
            end
            else
                currentOverloadOut = 1'b0;
        end
        else if (  (countedUpTo_wire > (T_2X_PERIOD-499) ) && ( countedUpTo_wire < T_2X_PERIOD ) ) begin
            counter_currentOverlo_reg_0_0 <= 0;
            counter_currentOverlo_reg_0_1 <= 0;
        end
    end  //of   always@(negedge clock) begin
    

    counter_up currentSens_counterUp(  //counter_up( clk, counterPeriod, countedUpTo )
        .clock(clock), 
        .reset(1'b0),
        .counterPeriod(T_2X_PERIOD),
        .countedUpTo(countedUpTo_wire)
    );
    
    assign currentOverload = currentOverloadOut;
endmodule