`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/03/2017 03:18:47 PM
// Design Name: 
// Module Name: H_Bridge
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
//clock here is twice the clock for 

module H_Bridge_v3(
    input clock,
    input [1:0] currentSensing_in,
    input [3:0] INs_from_decisionMakin,  
    input [2:0] forwardSpeed,
    input [5:0] turningSpeeds,
                // [2:0] motorSpeed == first rover tread
               // [5:3] motorSpeed == second rover tread
    input [3:0] movDirec_isTurning_leftRight,
    input [5:0] previousSpeedFromDecisionMaking,
    output [5:0] previousSpeedToDecisionMakin,
    output enA, enB, in1, in2, in3, in4,
    output LED_currentSense_debug,
    output[3:0]  previous_movDirec_isTurning_leftRight_toDecMak
    );
    
//     parameter INTERTIAL_STOP  =   4'b0000;
//     parameter HARD_STOP    =      4'b1111;
//     parameter REVERSE =           4'b0110;
//     parameter FORWARD   =         4'b1001; 
//     parameter TURN_RIGHT   =      4'b0101;
//     parameter TURN_LEFT    =      4'b1010; 
    parameter MOVING_FORWARD = 4'b1100;
    parameter TURNING_LEFT = 4'b1110;
    parameter TURNING_RIGHT = 4'b1111;
    parameter STOPPING  =   4'B0100; //STOPPING FORWARD
    parameter WEIRD_COMBINATIONS  =   4'b1001; //STOPPING FORWARD
    
    parameter MOVING_REVERSE = 4'b1000;
    parameter TURNING_LEFT_REVERSE = 4'b1011; //reverse direction
    parameter TURNING_RIGHT_REVERSE = 4'b1010;

//    reg [3:0] movDirec_isTurning_leftRight_reg;
    reg [3:0] INs_from_decisionMakin_reg;
    reg [3:0] movDirec_isTurning_leftRight_reg;
    //movDirec_isTurning_leftRight[3] == 1 : moving; 0 : not moving
        //movDirec_isTurning_leftRight[2] == 1 : forward; 0 : reverse
        //movDirec_isTurning_leftRight[1] == 1 : turning; 0 : not turning
        //movDirec_isTurning_leftRight[0] == 1 : right turn; 0 : left turn
    
    
    reg [5:0] motorSpeeds_reg;
 //   wire [27:0] countedUpTO_turning_wire;
    reg currentSensing_reg;
    wire currentSensing_wire;
    wire customClock_wire;
  

    //updates the direction to move
    always@(posedge customClock_wire) begin //divides a already divided clock by 2 
        currentSensing_reg <= 0;
        
        if (currentSensing_wire)
            currentSensing_reg <= 1;
        else
            currentSensing_reg <= 0;
            
                  case(movDirec_isTurning_leftRight)
                    4'b1110 : begin //turning left
                        motorSpeeds_reg[2:0] = turningSpeeds[5:3];
                        motorSpeeds_reg[5:3] = turningSpeeds[2:0];
                        INs_from_decisionMakin_reg = INs_from_decisionMakin; //this actually turns on INs
                    end
                    4'b1111 : begin //turning right
                        motorSpeeds_reg[2:0] = turningSpeeds[2:0];
                        motorSpeeds_reg[5:3] = turningSpeeds[5:3];
                        INs_from_decisionMakin_reg = INs_from_decisionMakin; //this actually turns on INs
                    end
                    4'b0000,
                    4'b0001,
                    4'b0010,
                    4'b0011,
                    4'b0100, //NOT moving
                    4'b0101,
                    4'b0110,
                    4'b0111 : begin //stopping
                        motorSpeeds_reg = 6'b000000;
                        INs_from_decisionMakin_reg = 4'b0000; //this actually turns on INs
                    end
                    4'b1100,
                    4'b1101 : begin //moving forward
                        motorSpeeds_reg = {forwardSpeed,forwardSpeed};
                        INs_from_decisionMakin_reg = INs_from_decisionMakin; //this actually turns on INs
                    end
                    4'b1000 : begin //moving reverse
                        motorSpeeds_reg = {forwardSpeed,forwardSpeed};
                        INs_from_decisionMakin_reg = INs_from_decisionMakin; //this actually turns on INs
                    end//reverse
                    4'b1001 : begin //weird combinations
                        motorSpeeds_reg = previousSpeedFromDecisionMaking;
                        INs_from_decisionMakin_reg = INs_from_decisionMakin; //this actually turns on INs
                    end//reverse combinations - for now, weird
                    4'b1011 : begin //TURNING_LEFT_REVERSE
                        motorSpeeds_reg[2:0] = turningSpeeds[5:3];
                        motorSpeeds_reg[5:3] = turningSpeeds[2:0];
                        INs_from_decisionMakin_reg = INs_from_decisionMakin; //this actually turns on INs
                    end
                    
                    4'b1010 : begin //TURNING_RIGHT_REVERSE
                        motorSpeeds_reg[2:0] = turningSpeeds[2:0];
                        motorSpeeds_reg[5:3] = turningSpeeds[5:3];
                        INs_from_decisionMakin_reg = INs_from_decisionMakin; //this actually turns on INs
                    end
                    default : begin
                         INs_from_decisionMakin_reg = INs_from_decisionMakin; //this actually turns on INs
                    end
                  endcase                  
            if (currentSensing_reg) begin
                motorSpeeds_reg = 6'b000000;
                INs_from_decisionMakin_reg = 4'b0000; //this actually turns on INs
            end
            else begin
                motorSpeeds_reg = motorSpeeds_reg;
                INs_from_decisionMakin_reg = INs_from_decisionMakin; //this actually turns on INs 
            end 
    end //end of always@(posedge clock) begin
    
//    defparam pwmH_Bridge1.PERIOD = 28'd250000;
    defparam pwmH_Bridge2.PERIOD = 28'd125000;
    PWM_v3 pwmH_Bridge1(      
        .clock(clock),
        .dutyCycle(motorSpeeds_reg[2:0]), //uses switches 0 - 2
        .PWM_pulse(enA)
     );
    
//    defparam pwmH_Bridge2.PERIOD = 28'd250000;
    defparam pwmH_Bridge2.PERIOD = 28'd125000;  
     PWM_v3 pwmH_Bridge2(     //uses switches 3 - 5
        .clock(clock),
        .dutyCycle(motorSpeeds_reg[5:3]),
        .PWM_pulse(enB)
      );
      
      defparam customClock.PERIOD = 725; //80 kHz Hz update, posedge
      
      PWM_v3 customClock (
          .clock(clock),
          .dutyCycle(3'b011), //50% duty cycle
          .PWM_pulse(customClock_wire)
      );
    
    currentSensing currentSense(
        .clock(clock),
        .currentSensA_B(~currentSensing_in),
        .isTurning(movDirec_isTurning_leftRight[1]),
        .currentOverload(currentSensing_wire)
        //output sendtoH_Bridge_INs
     );

      assign {in4,in3,in2,in1} = INs_from_decisionMakin_reg;
      assign previousSpeedToDecisionMakin = motorSpeeds_reg;
      assign LED_currentSense_debug = currentSensing_reg;
endmodule