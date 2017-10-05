`timescale 10ns / 1ps

module basysConnections(
    input clock,
    input [15:0] SW,
    //IP sensors
    input JC4,JC3,JC2,JC1,   //[3:0] IPsensFront_in
   input JC10,JC9,JC8,JC7, //[3:0] IPsensBack_in 
    //IR sensors
    input JB7, JB8,
    input JB1,//MIC
    //H-Bridge
    input JB3, JB4, //CURRENT SENSING
    output JA8,JA7,//ENB,ENA
    output JA4,JA3,JA2,JA1, //IN4,IN3,IN2,IN1
//    output [6:0] seg,
//    output dp,
//    output [3:0] an,

    output [7:0] LED //debug for frequency detector led[4[ detects stop
    );
    //create flag variable here
//    reg [3:0] detectSwitches;

    wire [3:0] IPsensFront_out_wire;
    wire [3:0] IPsensBack_out_wire;
    wire [3:0] sendToH_BridgeINs_wire;
    wire [5:0] motorSpeeds_wire;
    wire [5:0] previousSpeedFromDecisionMaking_wire;
    wire [5:0] previousSpeedToDecisionMakinFromH_Bridge_wire;
    wire [3:0] movDirec_isTurning_leftRight_wire;
    wire [3:0] previous_movDirec_isTurning_leftRight_toDecMak_wire;
    wire IR_sensed_wire;
    
    
    sensor_IP_v2 sensor_IP_v2(
        .clock(clock),
        .IPsensFront_in({JC1,JC2,JC3,JC4}),
        .IPsensBack_in({JC10,JC9,JC8,JC7}),
        .IPsensFront_out(IPsensFront_out_wire),
        .IPsensBack_out(IPsensBack_out_wire)
    );
    
    sensorIR sensorIR(
        .clock(clock),
        .IR_sensors({JB8,JB7}),
        .IR_sensed(IR_sensed_wire)
    );
    
    
    decisionMaking_v2 decisionMaking_v2(
        .clock(clock),
        .IPsensors({IPsensBack_out_wire,IPsensFront_out_wire}), // [3:0] are front; [7:4] are back
        .IR_sensors(IR_sensed_wire),
        .mic(JB1),
        .previousH_Bridge_INs({JA4,JA3,JA2,JA1}),
        .previousSpeeds(previousSpeedToDecisionMakinFromH_Bridge_wire),
        .previous_movDirec_isTurning_leftRight_fromHBridge(previous_movDirec_isTurning_leftRight_toDecMak_wire),
        .sendToH_Bridge_INs(sendToH_BridgeINs_wire),
        .movDirec_isTurning_leftRight(movDirec_isTurning_leftRight_wire),
        .previousSpeedToH_Bridge(previousSpeedFromDecisionMaking_wire),
        .LED_debug({LED[7],LED[5:0]})
    );
       
    H_Bridge_v3 H_Bridge_v3(
       .clock(clock),
       .currentSensing_in({JB4, JB3}),
       .INs_from_decisionMakin(sendToH_BridgeINs_wire),
       .forwardSpeed(SW[2:0]),//two motors with different PWMs
       .turningSpeeds({SW[8:6],SW[5:3]}),
       .movDirec_isTurning_leftRight(movDirec_isTurning_leftRight_wire),
       .previousSpeedFromDecisionMaking(previousSpeedFromDecisionMaking_wire),
       .previousSpeedToDecisionMakin(previousSpeedToDecisionMakinFromH_Bridge_wire),
       .enA(JA7), 
       .enB(JA8),
       .in1(JA1), 
       .in2(JA2), 
       .in3(JA3), 
       .in4(JA4),
       .LED_currentSense_debug(LED[6]),
       .previous_movDirec_isTurning_leftRight_toDecMak(previous_movDirec_isTurning_leftRight_toDecMak_wire)
     );
endmodule