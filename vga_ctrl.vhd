----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2025 03:29:35 PM
-- Design Name: 
-- Module Name: vga_ctrl - Behavioral
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

entity vga_ctrl is
  Port (signal clk : in std_logic;
        signal en : in std_logic;
        signal hcount : out std_logic_vector (9 downto 0);
        signal vcount : out std_logic_vector (9 downto 0);
        signal vid : out std_logic := '1';
        signal hs : out std_logic := '1';
        signal vs : out std_logic := '1'
  
  );
end vga_ctrl;

architecture Behavioral of vga_ctrl is

signal hcount_sig : std_logic_vector (9 downto 0) := (others => '0');
signal vcount_sig : std_logic_vector (9 downto 0) := (others => '0');

begin

counter : process (clk) begin

if (rising_edge (clk)) then 

    if (en = '1') then 
    
        if ( unsigned(hcount_sig) < 799)  then
            hcount_sig <= std_logic_vector (unsigned (hcount_sig) + 1);  
        else 
            hcount_sig <= (others => '0');
            if( unsigned (vcount_sig ) < 524) then 
                vcount_sig <= std_logic_vector (unsigned (vcount_sig) + 1);
            else
                vcount_sig <= (others => '0');
            end if;--vcount
            
        end if; --hcount
        
    end if; -- en

end if; -- rising edge
end process counter;

video : process (vcount_sig, hcount_sig) begin 
    
    if ( (unsigned (hcount_sig ) <= 639) and (unsigned (vcount_sig) <= 479)) then
        
        vid <= '1';
    else 
        vid <= '0';
    end if;
    
    if (unsigned (hcount_sig ) >= 656 and unsigned (hcount_sig) <= 751) then
        
        hs <= '0';
    else
        hs <= '1';
    end if;
    
    if (unsigned (vcount_sig) >= 490 and unsigned (vcount_sig ) <= 491) then
        
        vs <= '0';
    else
        vs <= '1';
    end if;
    
end process video;

hcount <= hcount_sig;
vcount <= vcount_sig;
end Behavioral;
