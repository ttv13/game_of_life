----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2025 04:06:28 PM
-- Design Name: 
-- Module Name: game_pixels_vga - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity game_pixels_vga is
  Port (signal clk : in std_logic;
        signal en : in std_logic;
        signal vs : in std_logic;
        signal vid : in std_logic;
        signal hcount : in std_logic_vector (9 downto 0);
        signal r : out std_logic_vector (4 downto 0);
        signal b : out std_logic_vector (4 downto 0);
        signal g : out std_logic_vector (5 downto 0);
  );
end game_pixels_vga;

architecture Behavioral of game_pixels_vga is

signal addr_count : std_logic_vector (18 downto 0) := (others => '0');

begin

process (clk) begin 

if rising_edge (clk) then 

    if (en = '1' and vid = '1' and unsigned (hcount) < 640) then 
        
        addr_count <= std_logic_vector (unsigned (addr_count) + 1 );
        
        r <= pixel (7 downto 5) & "00";
        g <= pixel (4 downto 2) & "000";
        b <= pixel (1 downto 0) & "000";
        
    else 
        r <= (others => '0');
        g <= (others => '0');
        b <= (others => '0');
    end if; 
    
    if (vs = '0') then 
        addr_count <= (others => '0');
    end if;
    
    
end if; -- rising edge
end process;

addr <= addr_count;
end Behavioral;