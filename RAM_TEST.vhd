LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
ENTITY ram_test IS
END ram_test;
ARCHITECTURE behavior OF ram_test IS 
-- Component Declaration for the Unit Under Test (UUT)
COMPONENT RAM_NEW
PORT(
CLOCK : IN  std_logic;
RST_N : IN  std_logic;
RD_EN : IN  std_logic;
WR_EN : IN  std_logic;
RD_ADDR : IN  std_logic_vector(3 downto 0);
WR_ADDR : IN  std_logic_vector(3 downto 0);
WR_DATA : IN  std_logic_vector(7 downto 0);
RD_DATA : OUT  std_logic_vector(7 downto 0)
);
END COMPONENT;
--Inputs
signal CLOCK : std_logic := '0';
signal RST_N : std_logic := '0';
signal RD_EN : std_logic := '0';
signal WR_EN : std_logic := '0';
signal RD_ADDR : std_logic_vector(3 downto 0) := (others => '0');
signal WR_ADDR : std_logic_vector(3 downto 0) := (others => '0');
signal WR_DATA : std_logic_vector(7 downto 0) := (others => '0');
--Outputs
signal RD_DATA : std_logic_vector(7 downto 0);
BEGIN
-- Instantiate the Unit Under Test (UUT)
uut: RAM PORT MAP (
CLOCK => CLOCK,
RST_N => RST_N,
RD_EN => RD_EN,
WR_EN => WR_EN,
RD_ADDR => RD_ADDR,
WR_ADDR => WR_ADDR,
WR_DATA => WR_DATA,
RD_DATA => RD_DATA
);
CLOCK_process :process
begin
CLOCK <= '0';
wait for 50 ns;
CLOCK <= '1';
wait for 50 ns;
end process;
-- Stimulus process
stim_proc: process
begin		
-- hold reset state for 100ms.
wait for 100 ns;	
RST_N<='1';
wait for 100 ns;	
-------------------------------------------------------------------------------------------------------------------	
-- Test Case 1: RAM Write Operation 
-------------------------------------------------------------------------------------------------------------------
WR_EN<='1';
RD_EN<='0';
WR_ADDR<="1101";
WR_DATA<="11100111";
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
--Test Case 2: RAM Read Operation 
wr_en<='0';
rd_en<='1';
RD_ADDR<= "1101";	
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-- Test Case 3: RAM Read & Write Operation 
-------------------------------------------------------------------------------------------------------------------
WR_EN<='1';
RD_EN<='1';
RD_ADDR<= "1101";
WR_ADDR<="1011";
WR_DATA<="10111001";
wait for 1700 ns;
RD_ADDR<= "1011";
WR_ADDR <="1000";
WR_DATA <="10011111";
-------------------------------------------------------------------------------------------------------------------
wait;
end process;
END;
