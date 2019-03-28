------------------------------------------------------------------------------------
---- Company: 
---- Engineer: 
---- 
---- Create Date: 02/14/2019 08:29:26 PM
---- Design Name: 
---- Module Name: counter_1 - Behavioral
---- Project Name: 
---- Target Devices: 
---- Tool Versions: 
---- Description: 
---- 
---- Dependencies: 
---- 
---- Revision:
---- Revision 0.01 - File Created
---- Additional Comments:
---- 
------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_div is
    Port (clockout : out STD_LOGIC;
          clockin : in STD_LOGIC);
end clock_div;

architecture Behavioral of clock_div is

signal count : std_logic_vector(26 downto 0);

begin
process (clockin)
begin
    if rising_edge(clockin) then         
        if (unsigned(count) < 124999999/115200) then
            count <= std_logic_vector(unsigned(count) + 1);
            clockout <= '0'; 
        else
             count <= (others => '0');
             clockout<= '1';
        end if;
    end if;
end process;

end Behavioral;