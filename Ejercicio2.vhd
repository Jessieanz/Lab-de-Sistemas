library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ContadorUD is
 Port ( UD,CEP,CET,CP : in std_logic;
        Dec : in std_logic_vector(3 downto 0);
        Uni : in std_logic_vector(3 downto 0);
        Dec1 : out std_logic_vector(3 downto 0);
        Uni1 : out std_logic_vector(3 downto 0);
      );
end ContadorUD;
  
architecture Behavorial of ContadorUD is
  component Contador is
   Port ( PE,UD,CEP,CET,CP : in std_logic;
        P : in std_logic_vector(3 downto 0);
        Q : out std_logic_vector(3 downto 0);
        TC : out std_logic
      );
  end component;
  
signal TC : std_logic;
signal TC1 : std_logic;
signal PE : std_logic:='0';
signal TC2 : std_logic;
signal Uniaux : std_logic_vector(3 downto 0);
signal Decaux : std_logic_vector(3 downto 0);
signal PE1 : std_logic:='0';
signal aux1 : std_logic;
signal res : std_logic_vector(3 downto 0);
signal ant : std_logic_vector(3 downto 0);

begin
  
aux1 <= not PE:
Dec1 <= Decaux;
Uni1 <= Uniaux;

C1 : Contador
  port map (PE,UD,CEP,CET,CP,res,Uniaux,TC);
C2 : Contador
  port map (PE1,UD,CEP,CET,TC1,res,Decaux,TC2);
  
process (Uniaux,Decaux,aux1,UD)
  begin
   if(UD='1') then
     res <= "0000";
      if(Uniaux="1001") then
        PE <='0';
      elsif(Uniaux="0001") then
        ant <= "1000";
        PE <= '1';
      else
        PE <= '1';
  end if;
    if (Decaux="1001") then
      PE1 <= '0';
    else
      PE1 <= '1';
    end if;
      
  elsif (UD='0') then
    res <= "1001";
      if(Uniaux="0000") then
        PE <='0';
      elsif(Uniaux="0001") then
        ant <= "1000";
        PE <= '1';
      else
        PE <= '1';
      end if;
     if (Decaux="0000") then
      PE1 <= '0';
    else
      PE1 <= '1';
    end if;
  end if;
    
 if(aux1='0' and aux1 'event and ant = "1000") then
    TC1 <='1';
    else TC1 <='0';
 end if;
end process;
end Behavorial;
        
        
        
      
      
      
      
