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

entity vga_kypd_pixel_pusher is
  Port (signal clk : in std_logic;
        signal en : in std_logic;
        signal vid : in std_logic;
        signal kypd_btn : in std_logic_vector (15 downto 0);
        signal hcount : in std_logic_vector (9 downto 0);
        signal r : out std_logic_vector (3 downto 0);
        signal b : out std_logic_vector (3 downto 0);
        signal g : out std_logic_vector (3 downto 0)
  );
end vga_kypd_pixel_pusher;

architecture Behavioral of vga_kypd_pixel_pusher is

begin

process (clk) begin 

if rising_edge (clk) then 

    if (en = '1' and vid = '1' and unsigned (hcount) < 640) then 
        
        if kypd_btn (3) = '1' then -- red 

            r <= "1111";
            g <= "0000";
            b <= "0000";

        elsif kypd_btn (4) = '1' then -- green 
            
            r <= "0000";
            g <= "1111";
            b <= "0000";

        elsif kypd_btn (5) = '1' then -- blue 
            
            r <= "0000";
            g <= "0000";
            b <= "1111";

        elsif kypd_btn (6) = '1' then -- teal
            
            r <= "0000";
            g <= "1111";
            b <= "1111";

        elsif kypd_btn (7) = '1' then -- purple 
            
            r <= "1111";
            g <= "0000";
            b <= "1111";
            
        elsif kypd_btn (8) = '1' then -- white 
            
            r <= "1111";
            g <= "1111";
            b <= "1111";

        elsif kypd_btn (9) = '1' then -- brown
            
            r <= "1111";
            g <= "1111";
            b <= "0000";
        
        elsif kypd_btn (10) = '1' then -- orange ? 
            
            r <= "1111";
            g <= "1001";
            b <= "0000";
        end if;
    else 
        r <= (others => '0');
        g <= (others => '0');
        b <= (others => '0');
    end if; 
    
    
    
end if; -- rising edge
end process;
end Behavioral;
