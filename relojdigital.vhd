library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
-- fpga4student.com FPGA projects, VHDL projects, Verilog projects
-- VHDL project: VHDL code for digital clock
entity digital_clock is
port (
 clk: in std_logic;
 -- clock 50 MHz
 sw1: in std_logic;
 pb2: in std_logic;
 pb3: in std_logic;
 led1: out std_logic;
 segmentos : out std_logic_vector(7 downto 0);
 EN: out std_logic_vector(3 downto 0);
 cH_dec,cH_unidad,cM_dec,cM_unidad:  out std_logic_vector(3 downto 0)
 
 );
end digital_clock;
architecture Behavioral of digital_clock is

 component DISPLAY IS
     PORT (
         CLK : IN STD_LOGIC;
         D3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
         D2 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
         D1 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
         D0 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
         S8 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
         EN : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
     );
 END component;

component clk_div
port (
 clk_50: in std_logic;
 clk_1s: out std_logic
     );
end component;

-- fpga4student.com FPGA projects, VHDL projects, Verilog projects
signal clk_1s: std_logic; -- 1-s clock
signal counter_second: integer;
signal counter_hour, counter_minute: integer ;
signal csA:  std_logic_vector(5 downto 0);
signal cmA:  std_logic_vector(5 downto 0);
signal chA:  std_logic_vector(5 downto 0);
--, c2, counter_second_Aux: std_logic_vector(3 downto 0);
signal rst_n:std_logic;
-- counter using for create time
signal H_out1_bin: std_logic_vector(3 downto 0); --The most significant digit of the hour
signal H_out0_bin: std_logic_vector(3 downto 0);--The least significant digit of the hour
signal M_out1_bin: std_logic_vector(3 downto 0);--The most significant digit of the minute
signal M_out0_bin: std_logic_vector(3 downto 0);--The least significant digit of the minute
begin
-- create 1-s clock --|
create_1s_clock: clk_div port map (clk_50 => clk, clk_1s => clk_1s);
 
-- This line demonstrates how to convert positive or negative integers
csA <= std_logic_vector(to_signed(counter_second, csA'length));
cmA <= std_logic_vector(to_signed(counter_minute, cmA'length));
chA <= std_logic_vector(to_signed(counter_hour, chA'length));




-- clock operation ---|
process(clk,sw1,pb2,pb3) begin
-- fpga4student.com FPGA projects, VHDL projects, Verilog projects

 if (sw1='0') then
 if(rising_edge(clk)) then
led1<='1';
 counter_second <= counter_second + 1;
 if(csA >="111011") then -- second > 59 then minute increases
 counter_minute <= counter_minute + 1;
 counter_second <= 0;
 if(cmA >="111011") then -- minute > 59 then hour increases
 counter_minute <= 0;
 counter_hour <= counter_hour + 1;
 if(chA >= "011000") then -- hour > 24 then set hour to 0
 counter_hour <= 0;
 end if;
 end if;
 end if;
 else
 led1<='0';
 end if;
 elsif (sw1='1') then
 if(rising_edge(pb2)) then
 counter_minute <= counter_minute + 1;
 if(cmA >="111011") then -- minute > 59 then hour increases
   counter_minute <= 0;
   counter_hour <= counter_hour + 1;
  end if;
  end if;
  if(rising_edge(pb3)) then
   counter_hour <= counter_hour + 1;
   if(chA >= "011000") then -- minute > 59 then hour increases
     counter_hour <= 0;
    end if;
    end if;
end if;
end process;
----------------------|
-- Conversion time ---|
----------------------|
-- H_out1 binary value 4bits
 H_out1_bin <= x"2" when chA >="010100" else--display
 x"1" when chA >="001010" else
 x"0";

-- H_out0 binary value
 H_out0_bin <= std_logic_vector(to_unsigned((counter_hour - to_integer(unsigned(H_out1_bin))*10),4));--displau

-- M_out1 binary value
 M_out1_bin <= x"5" when cmA >="110010" else-- display
 x"4" when cmA >="101000" else
 x"3" when cmA >="011110" else
 x"2" when cmA >="010100" else
 x"1" when cmA >="001010" else
 x"0";

-- M_out0 binary value
 M_out0_bin <= std_logic_vector(to_unsigned((counter_minute - to_integer(unsigned(M_out1_bin))*10),4));-- display

cH_dec<= H_out1_bin;
cH_unidad<= H_out0_bin;
cM_dec<=M_out1_bin;
cM_unidad<=M_out0_bin;
D: display
port map(clk, H_out1_bin, H_out0_bin, M_out1_bin, M_out0_bin, segmentos, EN);

end Behavioral;

-- fpga4student.com FPGA projects, VHDL projects, Verilog projects
-- VHDL project: VHDL code for digital clock
-- Clock divider module to get 1 second clock
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
entity clk_div is
port (
   clk_50: in std_logic;
   clk_1s: out std_logic
  );
end clk_div;
architecture Behavioral of clk_div is
signal counter: std_logic_vector(27 downto 0):=(others =>'0');
begin
 process(clk_50)
 begin
  if(rising_edge(clk_50)) then
   counter <= counter + x"0000001";
   --if(counter>=x"2FAF080") then -- for running on FPGA -- comment when running simulation
   if(counter>=x"0000001") then -- for running simulation -- comment when running on FPGA
    counter <= x"0000000";
   end if;
  end if;
 end process;
 clk_1s <= '0' when counter < x"17D7840" else '1';
end Behavioral;