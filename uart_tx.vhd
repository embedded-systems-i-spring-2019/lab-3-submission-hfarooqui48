----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2019 01:16:57 AM
-- Design Name: 
-- Module Name: uart_tx - Behavioral
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
  

entity uart_tx is
  Port (clk, en, send, rst : in std_logic;
           char : in std_logic_vector (7 downto 0);
           ready : out std_logic;
           tx : out std_logic );
end uart_tx;

architecture Behavioral of uart_tx is

type state is (idle, start, data);
signal crnt : state := idle;
signal hf :std_logic_vector(7 downto 0) := X"00";

begin
FSM:process(clk)
variable counter : natural := 0;

begin
    if rising_edge(clk) then
        if rst = '1' then
            hf <= X"00";
            crnt <= idle;
        end if;
        if en = '1' then
            case crnt is
                when idle => 
                    ready <= '1';
                    tx <= '1';
                    if send = '1' then
                        crnt <= start;
                    end if;
                when start => 
                    ready <='0';
                    tx <= '0';
                    hf <= char;
                    counter := 0;
                    crnt <= data;
                when data =>
                    if counter < 8 then
                        tx <= hf(counter);
                        counter := counter +1;
                    else
                        tx <= '1';
                        crnt <= idle;
                    end if;
            end case;
        end if;
    end if;
end process;

end Behavioral;
