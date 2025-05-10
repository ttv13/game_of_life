----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2025 04:06:28 PM
-- Design Name: 
-- Module Name: pixel_pusher - Behavioral
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

entity vga_pixel_pusher is
  Port (signal clk : in std_logic;
        signal en : in std_logic;
        signal vs : in std_logic;
        signal vid : in std_logic;
        signal pixel : in std_logic_vector (7 downto 0);
        signal hcount : in std_logic_vector (9 downto 0);
        signal r : out std_logic_vector (3 downto 0);
        signal b : out std_logic_vector (3 downto 0);
        signal g : out std_logic_vector (3 downto 0);
        signal addr : out std_logic_vector (17 downto 0)
  );
end vga_pixel_pusher;

architecture Behavioral of vga_pixel_pusher is

signal addr_count : std_logic_vector (17 downto 0) := (others => '0');

begin

process (clk) begin 

if rising_edge (clk) then 

    if (en = '1' and vid = '1' and unsigned (hcount) < 480) then 
        
        addr_count <= std_logic_vector (unsigned (addr_count) + 1 );
        
        r <= pixel (7 downto 5) & "0";
        g <= pixel (4 downto 2) & "0";
        b <= pixel (1 downto 0) & "00";
        
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
