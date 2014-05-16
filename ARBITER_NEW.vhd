Library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-------------------------------------------------------------------------
-- Entity for ARBITER
-------------------------------------------------------------------------
entity ARBITER_NEW is 
generic
(
-------------------------------------------------------------------------
-- Generics for scalability
-------------------------------------------------------------------------
G_ADDR_WIDTH:                integer := 4;
G_DATA_WIDTH:                integer := 8;
G_REGISTERED_DATA:           integer :=0
-- G_ADDR_WIDTH = Number of bits required to address the ram
-- G_DATA_WIDTH = Number of bits in a data 
-- G_REGISTERED_DATA =1 for registered data in output 0 for nonregistered
-------------------------------------------------------------------------
);
port
(
-------------------------------------------------------------------------
-- General Inputs And Output
-------------------------------------------------------------------------
RST_N:        in  std_logic;
CLOCK:        in  std_logic; 
RST_DONE:     out std_logic;
-------------------------------------------------------------------------
-- Inputs from --------client1--------------
-------------------------------------------------------------------------
RD_EN_C1:       in  std_logic;                               --read enb--
WR_EN_C1:       in  std_logic;                               --write enb--
RDADDR_C1:      in  std_logic_vector(G_ADDR_WIDTH-1 downto 0);--read addr---
WRADDR_C1:      in  std_logic_vector(G_ADDR_WIDTH-1 downto 0);--write addr--
WRDATA_C1:      in  std_logic_vector(G_DATA_WIDTH-1 downto 0);--data in----
-------------------------------------------------------------------------
-- Inputs from --------client2--------------
-------------------------------------------------------------------------
DATAIN_C2:                   in  std_logic_vector(G_DATA_WIDTH-1 downto 0);--input data--
REQUEST_C2:                  in  std_logic;                        --request to access memory--  
RD_NOT_WRITE_C2:             in  std_logic;                        --if '0' then write or read--
ADDR_C2:                     in  std_logic_vector(G_ADDR_WIDTH-1 downto 0);--addr for rd or wr--
-------------------------------------------------------------------------
--output from --------client1--------------
-------------------------------------------------------------------------
RDDATA_C1:                   out std_logic_vector(G_DATA_WIDTH-1 downto 0);--data out--
-------------------------------------------------------------------------
--output from --------client2--------------
-------------------------------------------------------------------------
DATAOUT_C2:                  out std_logic_vector(G_DATA_WIDTH-1 downto 0);--out data--
ACK_C2:                      out std_logic;                             --acknowlwdgement-- 
-------------------------------------------------------------------------
-- Others Input And Output
-------------------------------------------------------------------------
RD_EN:                  out std_logic;
WR_EN:                  out std_logic;
WR_ADDR:                out std_logic_vector(G_ADDR_WIDTH-1  downto 0);
RD_ADDR:                out std_logic_vector(G_ADDR_WIDTH-1  downto 0);
WR_DATA:                out std_logic_vector(G_DATA_WIDTH-1  downto 0); 
RD_DATA:                in std_logic_vector(G_DATA_WIDTH-1  downto 0));
end ARBITER_NEW;
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Architecture for ARBITER
------------------------------------------------------------------------- 
architecture RTL of ARBITER_NEW is
--------------Temporary registers-------------------          
signal TEMP_RD_DATA:        std_logic_vector(G_DATA_WIDTH-1  downto 0);
signal TEMP_RD_DATA1:       std_logic_vector(G_DATA_WIDTH-1  downto 0);
signal TEMP_RD_DATA2:       std_logic_vector(G_DATA_WIDTH-1  downto 0);
signal TEMP_RD_EN:          std_logic;
signal TEMP_WR_EN:          std_logic;
signal TEMP_WR_ADDR:        std_logic_vector(G_ADDR_WIDTH-1  downto 0);
signal TEMP_RD_ADDR:        std_logic_vector(G_ADDR_WIDTH-1  downto 0);
signal TEMP_WR_DATA:        std_logic_vector(G_DATA_WIDTH-1  downto 0); 
-------------Client type and state for FSM----------- 
type client is (reset,idle,client1_read,client2_read,client1_write,client2_write);  
signal pr_client_read:      client;                                 --present client read-
signal pr_client_write:     client;                                 --present client write-   
signal nx_client_read:      client;                                 --next client read--
signal nx_client_write:     client;                                 --next client write--
-------------Acknowledgement reg for client2---------
signal TEMP_ACK:            std_logic:='0'; 
signal TEMP_ACK1:           std_logic;
signal TEMP_ACK2:           std_logic;
signal TEMP_WR:             std_logic:='0';
signal TEMP_WR1:            std_logic;
------------Generic consideration-------------------------------
signal REGISTERED_DATA:     integer range 0 to 1 :=0;
------------Reset done generation Counter & register-----------
signal RESET_DONE_REG:      std_logic;
signal COUNT:               integer range 0 to 2**G_ADDR_WIDTH-1:=0;
------------Address Clash check register-----------------------
signal ADDR_CLASHI:         std_logic:='0';
signal ADDR_CLASH:          std_logic:='0';
begin
-------------------------------------------------------------------------
--FSM for ARBITER
-------------------------------------------------------------------------             
-------------------------------------------------
-------sequential section & reset condition- ----
-------------------------------------------------
p1:process(RST_N,CLOCK)
begin
if (RST_N='0') then
pr_client_read  <= reset;
pr_client_write <= reset;
elsif (CLOCK'EVENT and CLOCK='1' ) then
pr_client_read  <= nx_client_read;
pr_client_write <= nx_client_write;
end if;
end process;
---------------------------------------------------
--------Generate for registered data-------
--------------------------------------------------- 
g1:  if (G_REGISTERED_DATA=1) generate
REGISTERED_DATA<=G_REGISTERED_DATA;
end generate g1;
---------------------------------------------------
---------combinational section & client state------
---------------------------------------------------
p2:process(pr_client_read,pr_client_write,clock)
begin
if(RST_N='1' and clock='1')then 
if(nx_client_read=reset and nx_client_write=reset)then
if(count<(2**G_ADDR_WIDTH))then
RESET_DONE_REG <= '0';
count<=count+1;
else
nx_client_read  <= idle;
nx_client_write <= idle;
RESET_DONE_REG <= '1';
count<=0;
end if;
end if;
elsif(RST_N='0') then
nx_client_read <= reset;
nx_client_write<=reset;
end if;
if(pr_client_read=idle)then                     ----when arbiter idle--
if(RD_EN_C1='0')then
if(REQUEST_C2='0')then
nx_client_read<= idle;
elsif(RD_NOT_WRITE_C2='1')then
nx_client_read<= client2_read;
elsif(RD_NOT_WRITE_C2='0')then
nx_client_write<= client2_write;
end if;
else
nx_client_read <=client1_read;
end if;
end if;
if(pr_client_write=idle)then
if( WR_EN_C1='0')then
if(REQUEST_C2='0')then
nx_client_write<= idle;
elsif(RD_NOT_WRITE_C2='0')then
nx_client_write<= client2_write;
elsif(RD_NOT_WRITE_C2='1')then
nx_client_read<= client2_read;
end if;
else
nx_client_write <=client1_write;
end if;
end if;----------------------------------------------------------
if(pr_client_read=client1_read)then                       -----when arbiter allow client 1--- 
if(RD_EN_C1='1')then
nx_client_read <=client1_read;
else
if(REQUEST_C2='0')then
nx_client_read<= idle;
elsif(RD_NOT_WRITE_C2='1')then
nx_client_read<= client2_read; 
elsif(RD_NOT_WRITE_C2='0')then
nx_client_read<= idle;  
end if;
end if;
end if;
if(pr_client_write=client1_write)then
if(WR_EN_C1='1')then
nx_client_write <=client1_write;
else
if(REQUEST_C2='0')then
nx_client_write<= idle;
elsif(RD_NOT_WRITE_C2='0')then
nx_client_write<= client2_write;
elsif(RD_NOT_WRITE_C2='1')then
nx_client_write<= idle;
end if;
end if;
end if;----------------------------------------------------------------------
if(pr_client_read=client2_read)then               ------when arbiter allow client 2-----
if(RD_EN_C1='0')then
if(REQUEST_C2='1')then
if( RD_NOT_WRITE_C2='1')then
nx_client_read<= client2_read;
else
nx_client_read<=idle;
nx_client_write<= client2_write;
end if;
else
nx_client_read<=idle;
end if;
else
nx_client_read <=client1_read;
end if;
end if;
if(pr_client_write=client2_write)then
if(WR_EN_C1='0')then
if(REQUEST_C2='1')then
if( RD_NOT_WRITE_C2='0')then
nx_client_write<= client2_write;
else
nx_client_write<=idle;
nx_client_read<= client2_read;
end if;
else
nx_client_write<=idle;
end if;
else
nx_client_write <=client1_write;
end if;
end if;
-------------------------------------------------------------------------
end process;   
-------------------------------------------------------------------------
--Assigning Temp Registers according to the client----------------
-------------------------------------------------------------------------
pram:process(CLOCK)
begin
---------------------------------------------------
----------------Read & Write operation ------------
---------------------------------------------------
if(RST_N = '0')then
TEMP_RD_DATA  <= (others =>'0');
TEMP_RD_DATA1 <= (others =>'0');           
TEMP_RD_DATA2 <= (others =>'0');
elsif(CLOCK'EVENT and CLOCK='1')then
if(nx_client_read = idle)then
TEMP_RD_EN<='0';
TEMP_RD_ADDR<=(others =>'0');
elsif (nx_client_read=client1_read)then
TEMP_RD_EN   <= RD_EN_C1;
TEMP_RD_ADDR <= RDADDR_C1;
elsif(nx_client_read=client2_read)then
if(TEMP_ACK='0')then
TEMP_RD_EN  <= '1';
TEMP_RD_ADDR<= ADDR_C2;
TEMP_ACK    <= '1';
end if;
end if;
if(nx_client_write = idle)then
TEMP_WR_EN   <= '0';
TEMP_WR_DATA <= (others =>'0');
TEMP_WR_ADDR <= (others =>'0');
elsif (nx_client_write=client1_write)then
TEMP_WR_EN   <= WR_EN_C1;
TEMP_WR_DATA <= WRDATA_C1;
TEMP_WR_ADDR <= WRADDR_C1;
elsif(nx_client_write=client2_write)then
if(TEMP_WR='0')then
TEMP_WR_EN   <= '1';
TEMP_WR_ADDR <= ADDR_C2;
TEMP_WR_DATA <= DATAIN_C2;
TEMP_WR      <= '1';
end if;
end if;
-------------------------------------------
-----If Addr Clash occurs -------  
-------------------------------------------
if (TEMP_RD_EN='1' and TEMP_WR_EN ='1') then
if(TEMP_WR_ADDR = TEMP_RD_ADDR )then
ADDR_CLASH <='1';
TEMP_RD_DATA<=TEMP_WR_DATA;
else
ADDR_CLASH <='0';
end if;
else
ADDR_CLASH <='0';
end if; 
----------------------------------------------
if(TEMP_WR1='1')then ------For ACK generation during client2_Write------
TEMP_WR<='0';
end if;
TEMP_ACK1<=TEMP_ACK; ------For ACK generation during client2_Read------ 
if(TEMP_ACK1='1')then
TEMP_ACK1<='0';
TEMP_ACK<='0';
end if;              -----------------------------------------------------
ADDR_CLASHI<=ADDR_CLASH;---One clock cycle delay in addr clash for Registered data-----
TEMP_RD_DATA1<=TEMP_RD_DATA;---One clock cycle delay in output for Registered data with addr clash -----
TEMP_RD_DATA2<=RD_DATA; ---One clock cycle delay in output for Registered data without addr clash -----
end if;                                 
end process;
-------------------------------------------------------------------------
   --------Data in out put from temp registers---------
-------------------------------------------------------------------------
RD_EN<= TEMP_RD_EN;
WR_EN<= TEMP_WR_EN;
WR_DATA<=TEMP_WR_DATA;
WR_ADDR<=TEMP_WR_ADDR;
RD_ADDR<=TEMP_RD_ADDR;                
-------------------------------------------------------------------------
TEMP_WR1<=TEMP_WR;-----For ACK generation during client2_write--------
ACK_C2<='1' when  (TEMP_ACK1='1' or TEMP_WR1='1') else '0';--output ACK generation during client2_write and read---
RST_DONE<=RESET_DONE_REG;        ----------Indication for reset compleate----
-------------------------------------------------------------------------
    -----------------Data  out for client 2 ----------------
-------------------------------------------------------------------------
DATAOUT_C2<=RD_DATA when (ADDR_CLASH='0') else
                  TEMP_RD_DATA;
-------------------------------------------------------------------------
   -----------------------Data  out for client 1------- ---------
-------------------------------------------------------------------------
RDDATA_C1<=RD_DATA when (REGISTERED_DATA =0 and ADDR_CLASH='0' ) else 
TEMP_RD_DATA when (REGISTERED_DATA =0 and ADDR_CLASH='1' ) else
TEMP_RD_DATA2 when (REGISTERED_DATA =1 and ADDR_CLASHI='0' ) else
TEMP_RD_DATA1 when (REGISTERED_DATA =1 and ADDR_CLASHI='1' );       
end RTL;



