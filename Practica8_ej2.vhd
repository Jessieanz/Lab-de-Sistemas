library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
  
entity Contador is
 Port ( PE,UD,CEP,CET,CP : in std_logic;
        P : in std_logic_vector(3 downto 0);
        Q : out std_logic_vector(3 downto 0);
        TC : out std_logic
      );
end Contador;
  
architecture Behavorial of Contador is
  signal count : std_logic_vector(3 downto 0):= "0001";
  signal aux : std_logic_vector(3 downto 0):= "0000";
begin
  Process(CP,PE,CEP,CET,UD,aux)
begin
  if (rising_edge(CP)) then
    if PE='0' then
    aux<=P;
    elsif PE='1' then
      if CEP='0' AND CET='0' AND UD='1') then
        aux <= std_logic_vector(unsigned(aux) + unsigned(count));
          if(aux = "1111") then
            TC <= '0';
            else TC <= '1';
          end if;
      elsif (CEP='0' AND CET='0' AND UD='0') then
        aux <= std_logic_vector(unsigned(aux) - unsigned(count));
            if(aux = "0000") then
            TC <= '0';
            else TC <= '1';
            end if;
      end if;
     end if;
    end if;
  end process;
  Q <= aux;
  end Behavorial;
        
  
