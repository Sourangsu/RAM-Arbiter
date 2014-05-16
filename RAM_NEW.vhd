-------------------------------------------------------------------------
-- Entity for RAM
-------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity RAM is
generic
(
-------------------------------------------------------------------------
-- Generics for scalability
-------------------------------------------------------------------------
G_ADDR_WIDTH:    integer := 4;
G_DATA_WIDTH:    integer := 8
-- G_ADDR_WIDTH = Number of bits required to address the ram
-- G_DATA_WIDTH = Number of bits in a data 
-------------------------------------------------------------------------
);
port
(
-------------------------------------------------------------------------
-- RAM Inputs
-------------------------------------------------------------------------
CLOCK:      in  std_logic; 
RST_N:      in  std_logic;
RD_EN:      in  std_logic;                                --read enb--
WR_EN:      in  std_logic;                                --write enb--
RD_ADDR:    in  std_logic_vector(G_ADDR_WIDTH-1 downto 0);--read addr---
WR_ADDR:    in  std_logic_vector(G_ADDR_WIDTH-1 downto 0);--write addr--
WR_DATA:    in  std_logic_vector(G_DATA_WIDTH-1 downto 0);--data input----
RD_DATA:    out std_logic_vector(G_DATA_WIDTH-1 downto 0) --data output--
);
end RAM; 
 
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Architecture for RAM
-------------------------------------------------------------------------
architecture RTL of RAM is    
constant RAM_DEPTH:               integer := 2**G_ADDR_WIDTH;
type MEMORY_ARRAY is array(0 to RAM_DEPTH-1) of std_logic_vector(G_DATA_WIDTH-1 downto 0);--ram type--
signal MEMORY:                    MEMORY_ARRAY;
signal count:                     integer:=0;  
signal reset_done:                std_logic;
begin
memorypr:process(CLOCK) 
begin
if (RST_N='0')then
reset_done<='1';
elsif(CLOCK'EVENT and CLOCK='1')then
if(count <(2**G_ADDR_WIDTH) and reset_done='1' )then
MEMORY(conv_integer(count))<=(others =>'0');
count<=count+1;
else
count<=0;
reset_done<='0';
end if; 
if(reset_done='0')then
-------------------------------------------------------------------
-----WRITING PROCESS IN RAM
-------------------------------------------------------------------
if(WR_EN='1')then
MEMORY(conv_integer(WR_ADDR))<= WR_DATA;
end if;
-------------------------------------------------------------------
-----READING PROCESS IN RAM
-------------------------------------------------------------------
if(RD_EN='1')then
RD_DATA<=MEMORY(conv_integer(RD_ADDR));
end if;       
end if;
end if;
end process;
end RTL;
  
-------------------------------------------------------------------------   
