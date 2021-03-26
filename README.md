# UART-SPI-BRIDGE-VHDL

- COMMAND BYTE
  SEND 8 BIT DATA  "MAALLLL":
   
   where M is Mode              : 0 for Write Mode, 1 for Read Mode
   
         AA  is Address         : 00 -> Slave 0, 01 -> Slave 1, 10 -> Slave 2, 11 -> Slave 3
         
         LLLL is Length of Data : 01000 for 8 bit and 10000 for 16 bit transfer
         

- DATA BYTE
  
  Write Mode :
    
    if 8 bit send the data byte  (CLKS_PER_BIT*12) time after command byte is sent
    
    if 16 bit send the data byte  (CLKS_PER_BIT*12) time after command byte is sent and next byte (CLKS_PER_BIT*12) time after 1st byte
 
 Read Mode   :
    
    if 8 bit  wait after   sending command byte
    
    if 16 bit send command byte again after recieving 1st byte from SPI to get 2nd byte
    
    
Eg:
  
  to write 8 bit data to slave 0
    
    command byte will be :- 00001000
    
    and then the data byte
    
 
  to write 16 bit data to slave 1
    
    command byte will be :- 00110000
    
    and then the data bytes 
    
 
  to read 8 bit data to slave 2
    
    command byte will be :- 11001000
    
    and then the data byte   
    
 
 
  to read 16 bit data to slave 3
    
    command byte will be :- 11110000
    
    and then the data byte
    
    
   
