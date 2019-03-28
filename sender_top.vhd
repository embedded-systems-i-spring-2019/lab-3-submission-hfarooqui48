----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2019 02:06:20 AM
-- Design Name: 
-- Module Name: sender_top - Structural
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

entity sender_top is
  Port (txd, clk : in std_logic;
           btn : in std_logic_vector (1 downto 0);
           rxd, cts, rts : out std_logic);
end sender_top;

architecture Structural of sender_top is

    component uart
        Port (clk, en, send, rx, rst      : in std_logic;
              charSend                    : in std_logic_vector (7 downto 0);
              ready, tx, newChar          : out std_logic;
              charRec                     : out std_logic_vector (7 downto 0));
    end component;

    component debounce
        Port ( clk : in std_logic;
           btn : in std_logic;
           dbnc : out std_logic);
    end component;

    component clock_div
        Port (clockout : out std_logic;
              clockin : in std_logic);
    end component;

    component sender
    Port ( rst, clk, en, btn, ready : in std_logic;
           send : out std_logic;
           char : out std_logic_vector (7 downto 0));
    end component;
    
    signal dbnc0, dbnc1: std_logic;
    signal div, snd, ready, newchar : std_logic;
    signal char, charrec: std_logic_vector(7 downto 0);

begin

clk_div: clock_div
    port map(clockin=> clk,
             clockout =>div);

rstdbnc: debounce
    port map(clk => clk,
             btn => btn(0),
             dbnc => dbnc0);

btndbnc: debounce
    port map(clk => clk,
             btn => btn(1),
             dbnc => dbnc1);

snder: sender
    port map(clk => clk,
             btn => dbnc1,
             en => div,
             ready => ready,
             rst => dbnc0,
             send => snd,
             char => char);

u5: uart
    port map(clk => clk,
             en => div,
             send => snd,
             rx => txd,
             rst => dbnc0,
             charSend => char,
             ready => ready, 
             tx => rxd,
             newchar => newchar,
             charrec => charrec);

cts <= '0';
rts <= '0';
newchar <= '0';
Charrec <= (others => '0');
end Structural;
