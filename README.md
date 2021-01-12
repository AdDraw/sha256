# sha256
Project done for Warsaw University of Technology's RIM course.

Written in VHDL

Contains:
- Design Entities
  - uart module for loading messages and writing out the calculated hash
    - 9600 BaudRate
    - HalfDuplex
    - 1 stop bit
    - no parity bit
    - no flow control
  - RAM to store the soon to be hashed msg
    - msg lenght is limited to 64 chunks  
  - PLL block 
    - inclk  : 10MHz 
    - outclk : 50MHz (required frequency for the UART)
  - sha256 algorithm module
    - works on 512b chunks and reads the corresponding 32b msg words from the RAM
- TestBenches
  - that tests uart functionality
  - for the sha256 algorithm module to test chunk_n>=1 messages  
  - system tb that tests the integration of the componenets
  
```
Originally the project was meant to land on the MAX10 FPGA MAXimator Board from KAMAMI but it does not fit.
Thus the project was regenerated and moved to a Xilinx Artix-7 100T Arty7 digilent board.
```
