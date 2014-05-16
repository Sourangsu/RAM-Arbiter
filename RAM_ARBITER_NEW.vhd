library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-------------------------------------------------------------------------
-- Entity for ARBITER
-------------------------------------------------------------------------
entity RAM_ARBITER_NEW is
generic
(
-------------------------------------------------------------------------
-- Generics for scalability
-------------------------------------------------------------------------
G_ADDR_WIDTH:        integer := 4;
G_DATA_WIDTH:        integer := 8;
G_REGISTERED_DATA:   integer :=0
-- G_ADDR_WIDTH = Number of bits required to address the ram
-- G_DATA_WIDTH = Number of bits in a data
-- G_REGISTERED_DATA =1 for registered data in output 0 for nonregistered 
-------------------------------------------------------------------------
);
port
(
-------------------------------------------------------------------------
-- General Inputs & output
-------------------------------------------------------------------------
RST_N:       in std_logic;
CLOCK:       in std_logic; 
RST_DONE:    out std_logic;
-------------------------------------------------------------------------
-- Inputs from --------client1--------------
-------------------------------------------------------------------------
RD_EN_C1:      in  std_logic;                               --read enb--
WR_EN_C1:      in  std_logic;                               --write enb--
RDADDR_C1:     in  std_logic_vector(G_ADDR_WIDTH-1 downto 0);--read addr---
WRADDR_C1:     in  std_logic_vector(G_ADDR_WIDTH-1 downto 0);--write addr--
WRDATA_C1:     in  std_logic_vector(G_DATA_WIDTH-1 downto 0);--data in----
-------------------------------------------------------------------------
-- Inputs from --------client2--------------
-------------------------------------------------------------------------
DATAIN_C2:                   in  std_logic_vector(G_DATA_WIDTH-1 downto 0);--input data--
REQUEST_C2:                  in  std_logic;                        --request to access memory--  
RD_NOT_WRITE_C2:             in  std_logic;                        --if '0' then write or read--
ADDR_C2:                     in  std_logic_vector(G_ADDR_WIDTH-1 downto 0);--addr for rd or wr--
-------------------------------------------------------------------------
-- Output from --------client1--------------
-------------------------------------------------------------------------
RDDATA_C1:                   out std_logic_vector(G_DATA_WIDTH-1 downto 0);--data out--
-------------------------------------------------------------------------
-- Output from --------client2--------------
-------------------------------------------------------------------------
DATAOUT_C2:                  out std_logic_vector(G_DATA_WIDTH-1 downto 0);--out data--
ACK_C2:                      out std_logic);                              --acknowlwdgement-- 
end RAM_ARBITER_NEW;
-------------------------------------------------------------------------
Architecture RTL of RAM_ARBITER_NEW is
signal WR_DATA: std_logic_vector(G_DATA_WIDTH-1  downto 0);-- temp WR data --
signal RD_DATA1: std_logic_vector(G_DATA_WIDTH-1  downto 0);-- temp RD data --                                                       
signal WR_ADDR:std_logic_vector(G_ADDR_WIDTH-1 downto 0); ---temp write address----
signal RD_ADDR:std_logic_vector(G_ADDR_WIDTH-1 downto 0); ---temp read address-----
signal RD_EN:std_logic;
signal WR_EN:std_logic;
component RAM is
generic
(
-------------------------------------------------------------------------
-- Generics for scalability
-------------------------------------------------------------------------
G_ADDR_WIDTH:                integer;
G_DATA_WIDTH:                integer 
-- G_ADDR_WIDTH = Number of bits required to address the ram
-- G_DATA_WIDTH = Number of bits in a data 
-------------------------------------------------------------------------
);
port
(
-------------------------------------------------------------------------
-- RAM Inputs
-------------------------------------------------------------------------
CLOCK:        in  std_logic; 
RST_N:        in  std_logic;
RD_EN:        in  std_logic;                                --read enb--
WR_EN:        in  std_logic;                                --write enb--
RD_ADDR:      in  std_logic_vector(G_ADDR_WIDTH-1 downto 0);--read addr---
WR_ADDR:      in  std_logic_vector(G_ADDR_WIDTH-1 downto 0);--write addr--
WR_DATA:      in  std_logic_vector(G_DATA_WIDTH-1 downto 0);--data input----
RD_DATA:      out std_logic_vector(G_DATA_WIDTH-1 downto 0) --data output--
);
end component;
COMPONENT ARBITER_NEW is
generic
(
-------------------------------------------------------------------------
-- Generics for scalability
-------------------------------------------------------------------------
G_ADDR_WIDTH:           integer;
G_DATA_WIDTH:           integer;
G_REGISTERED_DATA:      integer 
-- G_ADDR_WIDTH = Number of bits required to address the ram
-- G_DATA_WIDTH = Number of bits in a data 
-- G_REGISTERED_DATA =1 for registered data in output 0 for nonregistered
-------------------------------------------------------------------------
);
port
(
-------------------------------------------------------------------------
-- General Inputs & output
-------------------------------------------------------------------------
RST_N:             in std_logic;
CLOCK:             in std_logic; 
RST_DONE:          out std_logic;
-------------------------------------------------------------------------
-- Inputs from --------client1--------------
-------------------------------------------------------------------------
RD_EN_C1:         in  std_logic;                               --read enb--
WR_EN_C1:         in  std_logic;                               --write enb--
RDADDR_C1:        in  std_logic_vector(G_ADDR_WIDTH-1 downto 0);--read addr---
WRADDR_C1:        in  std_logic_vector(G_ADDR_WIDTH-1 downto 0);--write addr--
WRDATA_C1:        in  std_logic_vector(G_DATA_WIDTH-1 downto 0);--data in----
-------------------------------------------------------------------------
-- Inputs from --------client2--------------
-------------------------------------------------------------------------
DATAIN_C2:         in  std_logic_vector(G_DATA_WIDTH-1 downto 0);--input data--
REQUEST_C2:        in  std_logic;                        --request to access memory--  
RD_NOT_WRITE_C2:   in  std_logic;                        --if '0' then write or read--
ADDR_C2:           in  std_logic_vector(G_ADDR_WIDTH-1 downto 0);--addr for rd or wr--
-------------------------------------------------------------------------
-- Output from --------client1--------------
-------------------------------------------------------------------------
RDDATA_C1:         out std_logic_vector(G_DATA_WIDTH-1 downto 0);--data out--
-------------------------------------------------------------------------
-- Output from --------client2--------------
-------------------------------------------------------------------------
DATAOUT_C2:       out std_logic_vector(G_DATA_WIDTH-1 downto 0);--out data--
ACK_C2:           out std_logic;                             --acknowlwdgement-- 
RD_EN:            out std_logic;
WR_EN:            out std_logic;
WR_ADDR:          out std_logic_vector(G_ADDR_WIDTH-1  downto 0);
RD_ADDR:          out std_logic_vector(G_ADDR_WIDTH-1  downto 0);
WR_DATA:          out std_logic_vector(G_DATA_WIDTH-1  downto 0); 
RD_DATA:          in std_logic_vector(G_DATA_WIDTH-1  downto 0));
end COMPONENT;
begin
RAMCLIENT:RAM
GENERIC MAP(G_ADDR_WIDTH,G_DATA_WIDTH)
PORT MAP(CLOCK =>  CLOCK,
RST_N =>  RST_N,                      
RD_EN =>  RD_EN,                       
WR_EN =>  WR_EN,                      
RD_ADDR=> RD_ADDR,                    
WR_ADDR=> WR_ADDR,                    
WR_DATA=> WR_DATA,                    
RD_DATA=> RD_DATA1); 
ARBITERCLIENT:ARBITER_NEW
GENERIC MAP(G_ADDR_WIDTH,G_DATA_WIDTH,G_REGISTERED_DATA)
PORT MAP(RST_N          =>  RST_N,
CLOCK          =>  CLOCK,
RST_DONE       =>  RST_DONE,
RD_EN_C1       =>  RD_EN_C1,
WR_EN_C1       =>  WR_EN_C1,
RDADDR_C1      =>  RDADDR_C1,
WRADDR_C1      =>  WRADDR_C1,
WRDATA_C1      =>  WRDATA_C1,
REQUEST_C2     =>  REQUEST_C2,
RD_NOT_WRITE_C2=>  RD_NOT_WRITE_C2,
ADDR_C2        =>  ADDR_C2,
DATAIN_C2      =>  DATAIN_C2,
RD_EN          =>  RD_EN,
WR_EN          =>  WR_EN,
RD_ADDR        =>  RD_ADDR, 
WR_ADDR        =>  WR_ADDR,
WR_DATA        =>  WR_DATA,
RD_DATA        =>  RD_DATA1,
DATAOUT_C2     =>  DATAOUT_C2,
ACK_C2         =>  ACK_C2,
RDDATA_C1      =>  RDDATA_C1);
end RTL;                       
                                    
                      

 
