----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2019 01:44:46 AM
-- Design Name: 
-- Module Name: sender - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sender is
  Port ( rst, clk, en, btn, ready : in std_logic;
           send : out std_logic;
           char : out std_logic_vector (7 downto 0));
end sender;

architecture Behavioral of sender is

type word is array (0 to 4) of std_logic_vector(7 downto 0);
type state is (idle, busyA, busyB, busyC);
signal crnt : state := idle;
signal netid : word := (x"68", x"61", x"66", x"34", x"32");
signal i : std_logic_vector(2 downto 0) := "000";

begin
FSM: process(clk)
    begin
        if rising_edge(clk) and en = '1' then
            if rst = '1' then
                send <= '0';
                char <= x"00";
                i <= "000";
                crnt <= idle;
            end if;
            case crnt is
                when idle =>
                    if ready = '1' and btn = '1' then
                        if unsigned(i) < 5 then
                            send <= '1';
                            char <= netid(natural(to_integer(unsigned(i))));                       
                            i <= std_logic_vector(unsigned(i) + 1);
                            crnt <= busyA;
                        else
                            i <= "000";
                        end if;
                    end if;
                when busyA =>
                    crnt <= busyB;
                when busyB =>
                    send <= '0';
                    crnt <= busyC; 
                when busyC =>
                    if ready = '1' and btn = '0' then
                        crnt <= idle;
                    end if;                
            end case;
        end if;
    end process;

end Behavioral;
