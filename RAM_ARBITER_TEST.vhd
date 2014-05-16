LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY RAM_ARBITER_TEST IS
END RAM_ARBITER_TEST;
ARCHITECTURE behavior OF RAM_ARBITER_TEST IS 
COMPONENT RAM_ARBITER_NEW
PORT(
RST_N : IN  std_logic;
CLOCK : IN  std_logic;
RST_DONE : OUT  std_logic;
RD_EN_C1 : IN  std_logic;
WR_EN_C1 : IN  std_logic;
RDADDR_C1 : IN  std_logic_vector(3 downto 0);
WRADDR_C1 : IN  std_logic_vector(3 downto 0);
WRDATA_C1 : IN  std_logic_vector(7 downto 0);
DATAIN_C2 : IN  std_logic_vector(7 downto 0);
REQUEST_C2 : IN  std_logic;
RD_NOT_WRITE_C2 : IN  std_logic;
ADDR_C2 : IN  std_logic_vector(3 downto 0);
RDDATA_C1 : OUT  std_logic_vector(7 downto 0);
DATAOUT_C2 : OUT  std_logic_vector(7 downto 0);
ACK_C2 : OUT  std_logic
);
END COMPONENT;
--Inputs
signal RST_N : std_logic := '0';
signal CLOCK : std_logic := '0';
signal RD_EN_C1 : std_logic := '0';
signal WR_EN_C1 : std_logic := '0';
signal RDADDR_C1 : std_logic_vector(3 downto 0) := (others => '0');
signal WRADDR_C1 : std_logic_vector(3 downto 0) := (others => '0');
signal WRDATA_C1 : std_logic_vector(7 downto 0) := (others => '0');
signal DATAIN_C2 : std_logic_vector(7 downto 0) := (others => '0');
signal REQUEST_C2 : std_logic := '0';
signal RD_NOT_WRITE_C2 : std_logic := '0';
signal ADDR_C2 : std_logic_vector(3 downto 0) := (others => '0');
--Outputs
signal RST_DONE : std_logic;
signal RDDATA_C1 : std_logic_vector(7 downto 0);
signal DATAOUT_C2 : std_logic_vector(7 downto 0);
signal ACK_C2 : std_logic;
-- Clock period definitions
constant CLOCK_period : time := 50 ns;
BEGIN
-- Instantiate the Unit Under Test (UUT)
uut: RAM_ARBITER_NEW PORT MAP (
RST_N => RST_N,
CLOCK => CLOCK,
RST_DONE => RST_DONE,
RD_EN_C1 => RD_EN_C1,
WR_EN_C1 => WR_EN_C1,
RDADDR_C1 => RDADDR_C1,
WRADDR_C1 => WRADDR_C1,
WRDATA_C1 => WRDATA_C1,
DATAIN_C2 => DATAIN_C2,
REQUEST_C2 => REQUEST_C2,
RD_NOT_WRITE_C2 => RD_NOT_WRITE_C2,
ADDR_C2 => ADDR_C2,
RDDATA_C1 => RDDATA_C1,
DATAOUT_C2 => DATAOUT_C2,
ACK_C2 => ACK_C2
);
-- Clock process definitions
CLOCK_process :process
begin
CLOCK <= '0';
wait for CLOCK_period/2;
CLOCK <= '1';
wait for CLOCK_period/2;
end process;
-- Stimulus process
stim_proc: process
begin		
-- hold reset state for 100 ns.
wait for 100 ns;
----------------------------------------------------------------------------------------
----	Test Case-1:  Only Client1 wants to write
----------------------------------------------------------------------------------------	
RST_N<='1';
wait for 500 ns;		
WR_EN_C1<= '1'; 
WRADDR_C1 <="1010";
WRDATA_C1 <="10100011";	
----------------------------------------------------------------------------------------	
----------------------------------------------------------------------------------------
----	Test Case-2:  Only Client1 wants to read
----------------------------------------------------------------------------------------
RST_N<='1';
wait for 500 ns;		
WR_EN_C1<= '1'; 
WRADDR_C1 <="1010";
WRDATA_C1 <="10100011";	
wait for 1700 ns;	
WR_EN_C1<= '0'; 
RD_EN_C1<= '1'; 
RDADDR_C1 <="1010";
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----	Test Case-3:  Only Client2 wants to write
----------------------------------------------------------------------------------------
RST_N<='1';
WR_EN_C1<= '0';
REQUEST_C2<= '1';
RD_NOT_WRITE_C2<= '0';
ADDR_C2 <="1110";
DATAIN_C2 <="11100011";
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----	Test Case-4:  Only Client2 wants to read
----------------------------------------------------------------------------------------
RST_N<='1';
WR_EN_C1<= '0';
REQUEST_C2<= '1';
RD_NOT_WRITE_C2<= '0';
ADDR_C2 <="1110";
DATAIN_C2 <="11100011";
wait for 1700 ns;
WR_EN_C1<= '0';
RD_NOT_WRITE_C2<= '1';
ADDR_C2 <="1110";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-5:  Client1 wants to read and write in different RAM location at same time
------------------------------------------------------------------------------------------------------------------
RST_N<='1';
wait for 500 ns;		
WR_EN_C1<= '1'; 
WRADDR_C1 <="1010";
WRDATA_C1 <="10100011";	
wait for 1700 ns;	
RD_EN_C1<= '1'; 
RDADDR_C1 <="1010";
WRADDR_C1 <="1110";
WRDATA_C1 <="10111011";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-6:  Client1 wants to read and write in different RAM location at different time
------------------------------------------------------------------------------------------------------------------
RST_N<='1';
wait for 500 ns;		
WR_EN_C1<= '1'; 
WRADDR_C1 <="1010";
WRDATA_C1 <="10100011";	
wait for 1700 ns;	
RD_EN_C1<= '1'; 
RDADDR_C1 <="1010";
wait for 500 ns;
WRADDR_C1 <="1110";
WRDATA_C1 <="10111011";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-7:  Client1 wants to read and write in same RAM location at same time
------------------------------------------------------------------------------------------------------------------
RST_N<='1';
wait for 500 ns;		
WR_EN_C1<= '1'; 
WRADDR_C1 <="1010";
WRDATA_C1 <="10100011";	
wait for 1700 ns;	
RD_EN_C1<= '1'; 
RDADDR_C1 <="1010";
WRADDR_C1 <="1010";
WRDATA_C1 <="10111011";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-8:  Client1 wants to read and write in same RAM location at different time
------------------------------------------------------------------------------------------------------------------
RST_N<='1';
wait for 500 ns;		
WR_EN_C1<= '1'; 
WRADDR_C1 <="1010";
WRDATA_C1 <="10100011";	
wait for 1700 ns;	
RD_EN_C1<= '1'; 
RDADDR_C1 <="1010";
wait for 500 ns;
WRADDR_C1 <="1010";
WRDATA_C1 <="10111011";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----	Test Case-9:  Client2 wants to read and write in different RAM location at same time.
------------------------------------------------------------------------------------------------------------------
RST_N<='1';
WR_EN_C1<= '0';
RD_EN_C1<= '0';
REQUEST_C2<= '1';
RD_NOT_WRITE_C2<= '0';
ADDR_C2 <="1010";
DATAIN_C2 <="11100011";
wait for 1700 ns;
RD_NOT_WRITE_C2<= '0';
ADDR_C2 <="1001";
DATAIN_C2 <="00100011";
RD_NOT_WRITE_C2<= '1';
ADDR_C2 <="1010";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----	Test Case-10:  Client2 wants to read and write in different RAM location at different time.
------------------------------------------------------------------------------------------------------------------
RST_N<='1';
WR_EN_C1<= '0';
RD_EN_C1<= '0';
REQUEST_C2<= '1';
RD_NOT_WRITE_C2<= '0';
ADDR_C2 <="1010";
DATAIN_C2 <="11100011";
wait for 1700 ns;
RD_NOT_WRITE_C2<= '0';
ADDR_C2 <="1001";
DATAIN_C2 <="00100011";
wait for 500 ns;
RD_NOT_WRITE_C2<= '1';
ADDR_C2 <="1010";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----	Test Case-11:  Client2 wants to read and write in same RAM location at same time.
------------------------------------------------------------------------------------------------------------------
RST_N<='1';
WR_EN_C1<= '0';
RD_EN_C1<= '0';
REQUEST_C2<= '1';
RD_NOT_WRITE_C2<= '0';
ADDR_C2 <="1010";
DATAIN_C2 <="11100011";
wait for 1700 ns;
RD_NOT_WRITE_C2<= '1';
ADDR_C2 <="1010";
RD_NOT_WRITE_C2<= '0';
ADDR_C2 <="1010";
DATAIN_C2 <="00100011";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----	Test Case-12:  Client2 wants to read and write in same RAM location at different time.
------------------------------------------------------------------------------------------------------------------
RST_N<='1';
WR_EN_C1<= '0';
RD_EN_C1<= '0';
REQUEST_C2<= '1';
RD_NOT_WRITE_C2<= '0';
ADDR_C2 <="1010";
DATAIN_C2 <="11100011";
wait for 1700 ns;
RD_NOT_WRITE_C2<= '1';
ADDR_C2 <="1010";
wait for 500 ns;
RD_NOT_WRITE_C2<= '0';
ADDR_C2 <="1010";
DATAIN_C2 <="00100011";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-13:  Client1 wants to write and client2 wants to read in different RAM location at same time
------------------------------------------------------------------------------------------------------------------
RST_N<='1';
WR_EN_C1<= '0';
REQUEST_C2<= '1';
RD_NOT_WRITE_C2<= '0';
ADDR_C2 <="1110";
DATAIN_C2 <="11100011";
wait for 1700 ns;
WR_EN_C1<= '1';
RD_EN_C1<= '0';
WRADDR_C1 <="1001";
WRDATA_C1 <="10111011";
REQUEST_C2<= '1';
RD_NOT_WRITE_C2<= '1';
ADDR_C2 <="1110";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-14:  Client1 wants to write and client2 wants to read in different RAM location at different time
------------------------------------------------------------------------------------------------------------------
RST_N<='1';
WR_EN_C1<= '0';
REQUEST_C2<= '1';
RD_NOT_WRITE_C2<= '0';
ADDR_C2 <="1110";
DATAIN_C2 <="11100011";
wait for 1700 ns;
WR_EN_C1<= '1';
RD_EN_C1<= '0';
WRADDR_C1 <="1001";
WRDATA_C1 <="10111011";
wait for 500 ns;
REQUEST_C2<= '1';
RD_NOT_WRITE_C2<= '1';
ADDR_C2 <="1110";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-15:  Client1 wants to write and client2 wants to read in same RAM location at same time
------------------------------------------------------------------------------------------------------------------
RST_N<='1';
WR_EN_C1<= '0';
REQUEST_C2<= '1';
RD_NOT_WRITE_C2<= '0';
ADDR_C2 <="1110";
DATAIN_C2 <="11100011";
wait for 1700 ns;
WR_EN_C1<= '1';
RD_EN_C1<= '0';
WRADDR_C1 <="1110";
WRDATA_C1 <="10111011";
REQUEST_C2<= '1';
RD_NOT_WRITE_C2<= '1';
ADDR_C2 <="1110";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-16:  Client1 wants to write and client2 wants to read in same RAM location at different time
------------------------------------------------------------------------------------------------------------------
RST_N<='1';
WR_EN_C1<= '0';
REQUEST_C2<= '1';
RD_NOT_WRITE_C2<= '0';
ADDR_C2 <="1110";
DATAIN_C2 <="11100011";
wait for 1700 ns;
WR_EN_C1<= '1';
RD_EN_C1<= '0';
WRADDR_C1 <="1110";
WRDATA_C1 <="10111011";
wait for 500 ns;
REQUEST_C2<= '1';
RD_NOT_WRITE_C2<= '1';
ADDR_C2 <="1110";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-17:  Client1 wants to read and Client2 wants to write in same RAM location at same time
------------------------------------------------------------------------------------------------------------------
RST_N <='1';
WR_EN_C1<= '1';
RD_EN_C1<= '0';
WRADDR_C1<="1010";
WRDATA_C1<="10101111";
wait for 1700 ns;
RD_EN_C1<='1';
WR_EN_C1<='0';
RDADDR_C1<="1010";
REQUEST_C2<='1';
RD_NOT_WRITE_C2<= '0';
ADDR_C2<="1010";
DATAIN_C2<="10111011";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-18:  Client1 wants to read and Client2 wants to write in same RAM location at different time
------------------------------------------------------------------------------------------------------------------
RST_N <='1';
WR_EN_C1<= '1';
RD_EN_C1<= '0';
WRADDR_C1<="1010";
WRDATA_C1<="10101111";
wait for 1700 ns;
RD_EN_C1<='1';
WR_EN_C1<='0';
RDADDR_C1<="1010";
wait for 500 ns;
REQUEST_C2<='1';
RD_NOT_WRITE_C2<= '0';
ADDR_C2<="1010";
DATAIN_C2<="10111011";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-19:  Client1 wants to read and Client2 wants to write in different RAM location at same time
------------------------------------------------------------------------------------------------------------------
RST_N <='1';
WR_EN_C1<= '1';
RD_EN_C1<= '0';
WRADDR_C1<="1000";
WRDATA_C1<="10101111";
wait for 1700 ns;
RD_EN_C1<='1';
WR_EN_C1<='0';
RDADDR_C1<="1000";
REQUEST_C2<='1';
RD_NOT_WRITE_C2<= '0';
ADDR_C2<="1010";
DATAIN_C2<="10100011";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-20:  Client1 wants to read and Client2 wants to write in different RAM location at differnet time
------------------------------------------------------------------------------------------------------------------
RST_N <='1';
WR_EN_C1<= '1';
RD_EN_C1<= '0';
WRADDR_C1<="1000";
WRDATA_C1<="10101111";
wait for 1700 ns;
RD_EN_C1<='1';
WR_EN_C1<='0';
RDADDR_C1<="1000";
wait for 500 ns;
REQUEST_C2<='1';
RD_NOT_WRITE_C2<= '0';
ADDR_C2<="1010";
DATAIN_C2<="10100011";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-21:  Client1 wants to read and Client2 wants to read in same RAM location at different time.
------------------------------------------------------------------------------------------------------------------
RST_N <='1';
WR_EN_C1<= '1';
RD_EN_C1<= '0';
WRADDR_C1<="1010";
WRDATA_C1<="10101111";
wait for 1700 ns;
RD_EN_C1<='1';
WR_EN_C1<='0';
RDADDR_C1<="1010";
wait for 300 ns;
REQUEST_C2<='1';
RD_NOT_WRITE_C2<='1';
ADDR_C2<="1010";
wait for 200 ns;
RD_EN_C1<='0';
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-22:  Client1 wants to read and Client2 wants to read in same RAM location at same time.
------------------------------------------------------------------------------------------------------------------
RST_N <='1';
WR_EN_C1<= '1';
RD_EN_C1<= '0';
WRADDR_C1<="1010";
WRDATA_C1<="10101111";
wait for 1700 ns;
RD_EN_C1<='1';
WR_EN_C1<='0';
RDADDR_C1<="1010";
REQUEST_C2<='1';
RD_NOT_WRITE_C2<='1';
ADDR_C2<="1010";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-23:  Client1 wants to read and Client2 wants to read in different RAM location at different time.
------------------------------------------------------------------------------------------------------------------
RST_N <='1';
WR_EN_C1<= '1';
RD_EN_C1<= '0';
WRADDR_C1<="1001";
WRDATA_C1<="10101111";
wait for 1700 ns;
RD_EN_C1<='1';
WR_EN_C1<='0';
RDADDR_C1<="1001";
wait for 300 ns;
REQUEST_C2<='1';
RD_NOT_WRITE_C2<='1';
ADDR_C2<="1010";
wait for 200 ns;
RD_EN_C1<='0';
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-24:  Client1 wants to read and Client2 wants to read in different RAM location at same time.
------------------------------------------------------------------------------------------------------------------
RST_N <='1';
WR_EN_C1<= '1';
RD_EN_C1<= '0';
WRADDR_C1<="1001";
WRDATA_C1<="10101111";
wait for 1700 ns;
RD_EN_C1<='1';
WR_EN_C1<='0';
RDADDR_C1<="1001";
REQUEST_C2<='1';
RD_NOT_WRITE_C2<='1';
ADDR_C2<="1010";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-25:  Client1 wants to read and write in the same RAM location and Client2 also wants to read in the 
--                 RAM location where Client1 has written at different time.
------------------------------------------------------------------------------------------------------------------
RST_N <='1';
WR_EN_C1<= '1';
RD_EN_C1<= '0';
WRADDR_C1<="1001";
WRDATA_C1<="10101111";
wait for 1700 ns;
RD_EN_C1<='1';
RDADDR_C1<="1001";
WRADDR_C1<="1001";
WRDATA_C1<="10100011";
wait for 300 ns;
REQUEST_C2<='1';
RD_NOT_WRITE_C2<='1';
ADDR_C2<="1001";
wait for 200 ns;
RD_EN_C1<='0';
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-26:  Client1 wants to read and write in the same RAM location and Client2 also wants to read in the 
--                 RAM location where Client1 has written at same time.
------------------------------------------------------------------------------------------------------------------
RST_N <='1';
WR_EN_C1<= '1';
RD_EN_C1<= '0';
WRADDR_C1<="1001";
WRDATA_C1<="10101111";
wait for 1700 ns;
RD_EN_C1<='1';
RDADDR_C1<="1001";
WRADDR_C1<="1001";
WRDATA_C1<="10100011";
REQUEST_C2<='1';
RD_NOT_WRITE_C2<='1';
ADDR_C2<="1001";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-27:  Client1 wants to read and write in the same RAM location and Client2 also wants to write in the 
--                 RAM location where Client1 has written at different time.
------------------------------------------------------------------------------------------------------------------
RST_N <='1';
WR_EN_C1<= '1';
RD_EN_C1<= '0';
WRADDR_C1<="1001";
WRDATA_C1<="10101111";
wait for 1700 ns;
RD_EN_C1<='1';
RDADDR_C1<="1001";
WRADDR_C1<="1001";
WRDATA_C1<="10100011";
wait for 300 ns;
REQUEST_C2<='1';
RD_NOT_WRITE_C2<='0';
ADDR_C2 <="1001";
DATAIN_C2 <="11100011";
wait for 200 ns;
WR_EN_C1<='0';
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-28:  Client1 wants to read and write in the same RAM location and Client2 also wants to write in the 
--                 RAM location where Client1 has written at same time.
------------------------------------------------------------------------------------------------------------------
RST_N <='1';
WR_EN_C1<= '1';
RD_EN_C1<= '0';
WRADDR_C1<="1001";
WRDATA_C1<="10101111";
wait for 1700 ns;
RD_EN_C1<='1';
RDADDR_C1<="1001";
WRADDR_C1<="1001";
WRDATA_C1<="10100011";
REQUEST_C2<='1';
RD_NOT_WRITE_C2<='0';
ADDR_C2 <="1001";
DATAIN_C2 <="11100011";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-29:  Client2 wants to read and write in the same RAM location and Client1 also wants to write in the 
--                 RAM location where Client2 has written at different time.
------------------------------------------------------------------------------------------------------------------
RST_N <='1';
WR_EN_C1<= '0';
RD_EN_C1<= '0';
REQUEST_C2<='1';
RD_NOT_WRITE_C2<='0';
ADDR_C2 <="1001";
DATAIN_C2 <="11100011";
wait for 1700 ns;
RD_NOT_WRITE_C2<='1';
ADDR_C2 <="1001";
wait for 300 ns;
WRADDR_C1<="1001";
WRDATA_C1<="10101111";
wait for 200 ns;
WR_EN_C1<= '1';
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-30:  Client2 wants to read and write in the same RAM location and Client1 also wants to write in the 
--                 RAM location where Client2 has written at same time.
------------------------------------------------------------------------------------------------------------------
RST_N <='1';
WR_EN_C1<= '0';
RD_EN_C1<= '0';
REQUEST_C2<='1';
RD_NOT_WRITE_C2<='0';
ADDR_C2 <="1001";
DATAIN_C2 <="11100011";
wait for 1700 ns;
WR_EN_C1<= '1';
RD_NOT_WRITE_C2<='1';
ADDR_C2 <="1001";
WRADDR_C1<="1001";
WRDATA_C1<="10101111";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-31:  Client2 wants to read and write in the same RAM location and Client1 also wants to read in the 
--                 RAM location where Client2 has written at same time.
------------------------------------------------------------------------------------------------------------------
RST_N <='1';
WR_EN_C1<= '0';
RD_EN_C1<= '0';
REQUEST_C2<='1';
RD_NOT_WRITE_C2<='0';
ADDR_C2 <="1001";
DATAIN_C2 <="11100011";
wait for 1700 ns;
RD_EN_C1<= '1';
RD_NOT_WRITE_C2<='1';
ADDR_C2 <="1001";
RDADDR_C1 <="1001";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-32:  Client2 wants to read and write in the same RAM location and Client1 also wants to read in the 
--                 RAM location where Client2 has written at different time.
------------------------------------------------------------------------------------------------------------------
RST_N <='1';
WR_EN_C1<= '0';
RD_EN_C1<= '0';
REQUEST_C2<='1';
RD_NOT_WRITE_C2<='0';
ADDR_C2 <="1001";
DATAIN_C2 <="11100011";
wait for 1700 ns;
RD_NOT_WRITE_C2<='1';
ADDR_C2 <="1001";
wait for 300 ns;
RD_EN_C1<= '1';
RDADDR_C1 <="1001";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-33:  If any client resets (RST_N=0) the system at any time. 
------------------------------------------------------------------------------------------------------------------
RST_N<='1';
WR_EN_C1<= '1';
RD_EN_C1<= '0';
WRADDR_C1<="1010";
WRDATA_C1<="10101111";
wait for 1700 ns;
RST_N<='0';
RD_EN_C1<= '1';
WR_EN_C1<='0';
RDADDR_C1<="1010";                        
REQUEST_C2<='1';
RD_NOT_WRITE_C2<='0';
ADDR_C2<="0110";
DATAIN_C2<="10111011";
wait for 500 ns;
RST_N<='1';
RDADDR_C1<="1010";
wait for 300 ns;
RDADDR_C1<="0110";
----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
----Test Case-34:  If any client gives the inputs until RST_DONE is high. 
------------------------------------------------------------------------------------------------------------------
RST_N<='1';
wait for 200 ns;		
WR_EN_C1<= '1';
RD_EN_C1<= '0';
WRADDR_C1<="1010";
WRDATA_C1<="10101111";
RST_N<='0';
wait for 1700 ns;
RD_EN_C1<= '1';
WR_EN_C1<='0';
RDADDR_C1<="1010";			
REQUEST_C2<='1';
RD_NOT_WRITE_C2<='0';
ADDR_C2<="0110";
DATAIN_C2<="10111011";
wait for 800 ns;
RST_N<='1';
RDADDR_C1<="1010";
----------------------------------------------------------------------------------------
wait;
end process;
END;
