----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2025 02:18:39 PM
-- Design Name: 
-- Module Name: debounce - Behavioral
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

entity lab_debounce is
  Port (clk : in std_logic;
        btn : in std_logic;
        dbnc : out std_logic
  );
end lab_debounce;

architecture Behavioral of lab_debounce is

    signal shift_reg : std_logic_vector(1 downto 0) := (others => '0');
    signal count : std_logic_vector(21 downto 0) := (others => '0'); --for 20 ms sample
    
begin

process (clk)
    begin 
        if (rising_edge(clk)) then
            
            shift_reg(1) <= shift_reg(0);
            shift_reg(0) <= btn;
            if (shift_reg(1) = '1') then
                count <= std_logic_vector(unsigned(count) + 1);
                
                if (unsigned(count) = 2499999) then
                    dbnc <= '1';
                end if;
                
            else 
                count <= (others => '0');
                dbnc <= '0';
            end if;
            
        end if;
    end process;
end Behavioral;