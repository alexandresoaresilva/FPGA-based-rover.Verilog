# FPGA-based-rover.Verilog
Semi-autonomous rover Verilog project for the Project Lab I class, writtten during the 2017 summer 
at the Electrical and Computer Engineering Department, Texas Tech University. 

Programmed on the Xilinx Vivado environment for the Xilinx Basys3 FPGA.
TOP module: basysConnections.v
OBS: some higher-module simulation files might not as expected. 
With the exception of the current sensing module - which hasn't been tested enough - all modules work as expected.

Demo
https://www.youtube.com/watch?v=KuQh1xNAlpg
warning: this video was recorded before the final code for turns was finished. Thus, the rover gets stuck from time to time. This is due to the wrong turn logic; the turn logic was corrected later by enforcing that, if one of the side IP sensors (say the left-hand side) saw the conductive tape, it'd keep turning until the IP sensor on the opposite side detected the tape. This in effect made the rover to run smoothly and to always complete the turns. Unfortunately, there's no video recording of the last iteration of the Verilog code running on the FPGA.
