module decisionMaking_v2(
    input clock,
    input [7:0] IPsensors, // [3:0] are front; [7:4] are back
    input IR_sensors, mic,
    input [3:0] previousH_Bridge_INs,
    input [5:0] previousSpeeds,
    input [3:0] previous_movDirec_isTurning_leftRight_fromHBridge,
    output [3:0] sendToH_Bridge_INs,
    output [3:0] movDirec_isTurning_leftRight,
    output [5:0] previousSpeedToH_Bridge, //just ensures the movement keeps flowing
    output [6:0] LED_debug
    );

    parameter INTERTIAL_STOP  =   4'b0000;
    parameter HARD_STOP    =      4'b1111;
    parameter REVERSE =           4'b0110;
    parameter FORWARD   =         4'b1001;
    

//    parameter COUNT_PERIOD_HALF_SEC = 28'd25000000; //divides the clock to get 2 Hz (on posedge only), 0.5 sec period

    reg [3:0] movDirec_isTurning_leftRight_reg;
        //movDirec_isTurning_leftRight[3] == 1 : moving; 0 : not moving
        //movDirec_isTurning_leftRight[2] == 1 : forward; 0 : reverse
        //movDirec_isTurning_leftRight[1] == 1 : turning; 0 : not turning
        //movDirec_isTurning_leftRight[0] == 1 : right turn; 0 : left turn

    integer i;
    parameter MOVING_FORWARD = 4'b1100;
    parameter TURNING_LEFT = 4'b1110;
    parameter TURNING_RIGHT = 4'b1111;
    parameter STOPPING  =   4'b0100; //STOPPING FORWARD
    parameter WEIRD_COMBINATIONS  =   4'b1001; //STOPPING FORWARD


    parameter MOVING_REVERSE = 4'b1000;
    parameter TURNING_LEFT_REVERSE = 4'b1011;
    parameter TURNING_RIGHT_REVERSE = 4'b1010;
    //parameter STOPPING  =   4'b0100; //STOPPING FORWARD
    //parameter WEIRD_COMBINATIONS  =   4'b1001; //STOPPING FORWARD

    reg [3:0] IPsensors_reg;
    reg [5:0] previousSpeeds_reg;
    reg [3:0] sendToH_BridgeINs_reg;
    reg [5:0] motorSpeeds_reg;
    reg [5:0] LED_debug_reg;
    reg isTurning_reg = 0;
    reg stoppedAndWaitingForDetection_reg;
    reg reverse_wire_reg;
    reg IR_sensed;
    reg turning_long_reg;
    reg stopLongTurning_reg;
    reg [31:0] previousTimeForTogglingReverse_in_reg;
    
    wire [3:0] sendToH_BridgeINs_reg_turning_wire;
    wire [3:0] sendToH_Bridge_turn_long_wire;
    wire [27:0] countedUpTO_turning_wire;
    wire stoppedAndWaitingForDetection_wire;
    wire isStoppedAndDetecting_wire;
    wire [3:0] virtual_IPsensors_wire;
    wire reverse_wire;
    wire isTurning_long_out_wire;
    wire [31:0] previousTimeForTogglingReverse_in_wire;

    //1. tests for currentSensing
    //2. tests for IR_sensors
    //3. checks whether it is going in reverse or FORWARD
    always@(posedge clock) begin
        
        IR_sensed <= 0;
        turning_long_reg <= 0;
        
        if (IR_sensors)
            IR_sensed <= 1;
        else
            IR_sensed <= 0;
            
        if (stoppedAndWaitingForDetection_wire)
            stoppedAndWaitingForDetection_reg <= 1'b1;
         else
            stoppedAndWaitingForDetection_reg <= 1'b0;

        if (~reverse_wire || reverse_wire === 1'bx || reverse_wire === 1'bz ) begin
            IPsensors_reg <= IPsensors[3:0];
            reverse_wire_reg <= 0;
        end
        else begin
            reverse_wire_reg <= 1;
            IPsensors_reg <= IPsensors[7:4];
        end

     if (isStoppedAndDetecting_wire && ~IPsensors_reg)
        IPsensors_reg = virtual_IPsensors_wire;
     else
        IPsensors_reg = IPsensors_reg;
     
     if(~isTurning_long_out_wire || isTurning_long_out_wire === 1'bx || isTurning_long_out_wire === 1'b0 )
        turning_long_reg <=1;
     else
        turning_long_reg <=0;
        
    
        if(~turning_long_reg) begin
            if (~IR_sensed) begin
                case(IPsensors_reg) //these tell the H-bridge which speed to choose
                    4'b0000 : begin
                            movDirec_isTurning_leftRight_reg <= STOPPING;
                            sendToH_BridgeINs_reg <= INTERTIAL_STOP;
                    end
                    4'b0110 : begin
                        if(reverse_wire_reg) begin
                            movDirec_isTurning_leftRight_reg <= MOVING_REVERSE; //speed
                            sendToH_BridgeINs_reg <= REVERSE; //moving without turning
                        end
                        else begin
                            movDirec_isTurning_leftRight_reg <= MOVING_FORWARD;
                            sendToH_BridgeINs_reg <= FORWARD; //moving without turning
                        end
                    end
                    //RIGHT turns
                    4'b0010 : begin
                        if(reverse_wire_reg) begin
                            movDirec_isTurning_leftRight_reg <= TURNING_RIGHT_REVERSE;
                            sendToH_BridgeINs_reg <= sendToH_BridgeINs_reg_turning_wire; //right turn
                        end
                        else begin
                            movDirec_isTurning_leftRight_reg <= TURNING_RIGHT;
                            sendToH_BridgeINs_reg <= sendToH_BridgeINs_reg_turning_wire; //right turn
                        end
                    end
                    4'b0001,
                    4'b0011,
                    4'b0111,
                    4'b0101,
                    4'b1011 : begin //long turns
                        if(reverse_wire_reg) begin
                            for(i = 0; i < 4; i = i + 1) begin
                                movDirec_isTurning_leftRight_reg <= TURNING_RIGHT_REVERSE;
                                sendToH_BridgeINs_reg <= sendToH_Bridge_turn_long_wire; //right turn
                            end
                        end
                        else begin
                            for(i = 0; i < 4; i = i + 1) begin
                                movDirec_isTurning_leftRight_reg <= TURNING_RIGHT;
                                sendToH_BridgeINs_reg <= sendToH_Bridge_turn_long_wire; //right turn
                            end
                        end
                    end
                    //LEFT turns
                    4'b0100 : begin
                        if(reverse_wire_reg) begin
                            movDirec_isTurning_leftRight_reg <= TURNING_LEFT_REVERSE;
                            sendToH_BridgeINs_reg <= sendToH_BridgeINs_reg_turning_wire; //right turn
                        end
                        else begin
                            movDirec_isTurning_leftRight_reg <= TURNING_LEFT;
                            sendToH_BridgeINs_reg <= sendToH_BridgeINs_reg_turning_wire; //right turn
                        end
                    end
                    4'b1001 : begin
                        if(reverse_wire_reg) begin
                            movDirec_isTurning_leftRight_reg <= MOVING_REVERSE;
                            sendToH_BridgeINs_reg <= REVERSE; //right turn
                        end
                        else begin
                            movDirec_isTurning_leftRight_reg <= MOVING_FORWARD;
                            sendToH_BridgeINs_reg <= FORWARD; //right turn
                        end
                    end
                    4'b1000,
                    4'b1100,
                    4'b1110,
                    4'b1101,
                    4'b1010 : begin //long turns
                        if(reverse_wire_reg) begin
                            for(i = 0; i < 4; i = i + 1) begin
                                movDirec_isTurning_leftRight_reg <= TURNING_LEFT_REVERSE;
                                sendToH_BridgeINs_reg <= sendToH_Bridge_turn_long_wire; //right turn
                            end
                        end
                        else begin
                            for(i = 0; i < 4; i = i + 1) begin
                                movDirec_isTurning_leftRight_reg <= TURNING_LEFT;
                                sendToH_BridgeINs_reg <= sendToH_Bridge_turn_long_wire; //right turn
                            end
                        end
                    end
                    //default : sendToH_BridgeINs_reg <= previousMotion
                    //================================= weird combinations
                    4'b1111  : begin
                        movDirec_isTurning_leftRight_reg <= WEIRD_COMBINATIONS;
                        sendToH_BridgeINs_reg <= previousH_Bridge_INs;
                    end
        
                    default : begin
                       movDirec_isTurning_leftRight_reg = WEIRD_COMBINATIONS;
                       sendToH_BridgeINs_reg <= previousH_Bridge_INs;
                    end
                endcase
            end //of if (~IR_sensed) begin
            else begin // end of else if (IR_sensors) - with IRsensors detecting
                sendToH_BridgeINs_reg <= sendToH_BridgeINs_reg ;
                sendToH_BridgeINs_reg <= HARD_STOP;
            end
        end
        else begin
          stopLongTurning_reg <= 0;
                  if ( ( IPsensors_reg != 4'b0100 || IPsensors_reg != 4'b0010 ) || IPsensors_reg != 4'b0110 ) begin
                      case(previous_movDirec_isTurning_leftRight_fromHBridge) //these tell the H-bridge which speed to choose
                          //RIGHT turns
                          4'b1010,
                          4'b1111 : begin //turning right
                              if(reverse_wire_reg) begin
                                  for(i = 0; i < 4; i = i + 1) begin
                                      movDirec_isTurning_leftRight_reg <= TURNING_RIGHT_REVERSE;
                                      sendToH_BridgeINs_reg <= sendToH_Bridge_turn_long_wire; //right turn
                                  end
                              end
                              else begin
                                  for(i = 0; i < 4; i = i + 1) begin
                                      movDirec_isTurning_leftRight_reg <= TURNING_RIGHT;
                                      sendToH_BridgeINs_reg <= sendToH_Bridge_turn_long_wire; //right turn
                                  end
                              end
                          end
                          //LEFT turns
                          4'b1110, //turning left
                          4'b1011 : begin //TURNING_LEFT_REVERSE
                              if(reverse_wire_reg) begin
                                  for(i = 0; i < 4; i = i + 1) begin
                                      movDirec_isTurning_leftRight_reg <= TURNING_LEFT_REVERSE;
                                      sendToH_BridgeINs_reg <= sendToH_Bridge_turn_long_wire; //right turn
                                  end
                              end
                              else begin
                                  for(i = 0; i < 4; i = i + 1) begin
                                      movDirec_isTurning_leftRight_reg <= TURNING_LEFT;
                                      sendToH_BridgeINs_reg <= sendToH_Bridge_turn_long_wire; //right turn
                                  end
                              end
                          end
                          default : begin
                             movDirec_isTurning_leftRight_reg = previous_movDirec_isTurning_leftRight_fromHBridge;
                             sendToH_BridgeINs_reg <= previousH_Bridge_INs;
                          end
                      endcase
                  end
                  else begin
                     stopLongTurning_reg <= 1;
                   //  movDirec_isTurning_leftRight_reg = previous_movDirec_isTurning_leftRight_fromHBridge;
                     //sendToH_BridgeINs_reg <= previousH_Bridge_INs;
                  end         
              end

        LED_debug_reg[4] <= stoppedAndWaitingForDetection_reg;
        LED_debug_reg[5] <=isStoppedAndDetecting_wire;
        previousSpeeds_reg <= previousSpeeds; //speeds for weird combinations in the H-bridge
        previousTimeForTogglingReverse_in_reg <= previousTimeForTogglingReverse_in_wire;
    end //end of always@
    
    turn turn_movFrwrd(
        .clock(clock),
        .isTurning_leftOrRight(movDirec_isTurning_leftRight_reg[1:0]),//left or right
        .stopLongTurning(stopLongTurning_reg),
        .sendToH_Bridge_turn(sendToH_BridgeINs_reg_turning_wire),//,
        .sendToH_Bridge_turn_long(sendToH_Bridge_turn_long_wire),
        .isTurning_long_out(isTurning_long_out_wire)
    );

    stopping(
        .clock(clock),
        .present_INs(IPsensors_reg),
        .stoppedAndWaitingForDetection(stoppedAndWaitingForDetection_wire) //boolean
    );

    freqDetect(
        .clock(clock),
        .micInput(mic),
        .stoppedAndWaitingForDetection(stoppedAndWaitingForDetection_wire),
        .IP_sensors(IPsensors_reg),
        .previousTimeForTogglingReverse_in(previousTimeForTogglingReverse_in_reg),
        .virtual_IPsensors(virtual_IPsensors_wire),
        .isStoppedAndDetecting_out(isStoppedAndDetecting_wire),
        .previousTimeForTogglingReverse_out(previousTimeForTogglingReverse_in_wire),
        .reverse(reverse_wire)
    );

    assign sendToH_Bridge_INs = sendToH_BridgeINs_reg;
    assign movDirec_isTurning_leftRight = movDirec_isTurning_leftRight_reg;
    assign previousSpeedToH_Bridge = previousSpeeds_reg;
    assign LED_debug[5:4] = LED_debug_reg[5:4];
    assign LED_debug[3:0] = virtual_IPsensors_wire;
    assign LED_debug[6] = reverse_wire;
endmodule
