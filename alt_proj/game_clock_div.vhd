----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2025 01:14:44 PM
-- Design Name: 
-- Module Name: clock_div - Behavioral
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
use IEEE.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity game_clock_div is
  Port (clk : in std_logic;     -- 125 MHz clock 125,000,000
        div : out std_logic
        );
end game_clock_div;

architecture Behavioral of game_clock_div is
    signal count : std_logic_vector(26 downto 0) := (others => '0');
    signal div_out : std_logic;
begin

process (clk)
    begin
    if (rising_edge (clk)) then 
        if (unsigned(count) < 62_499_999) then        -- count = 62_500_000 => 2 hz clk
            count <= std_logic_vector(unsigned(count) + 1);
            div_out <= '0';
        else 
            count <= (others => '0');
            div_out <= '1';
        end if;
    end if;
    div <= div_out;
    end process;
end Behavioral;