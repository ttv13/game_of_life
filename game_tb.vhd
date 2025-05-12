----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2025 06:17:39 PM
-- Design Name: 
-- Module Name: image_top_tb - tb
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity game_tb is
--  Port ( );
end game_tb;

architecture tb of game_tb is

component game_top port (
    clk : in std_logic;
    sw : in std_logic_vector (1 downto 0);
    VGA_HS_O : out std_logic;
    VGA_VS_O : out std_logic;
    VGA_R : out std_logic_vector (3 downto 0);
    VGA_B : out std_logic_vector (3 downto 0);
    VGA_G : out std_logic_vector (3 downto 0);

    kp_rows : in std_logic_vector (1 to 4);
    kp_cols : buffer std_logic_vector (1 to 4)
);
end component;

signal clk : std_logic := '0';
signal sw : std_logic_vector (1 downto 0) := (others => '0');

signal VGA_HS_O : std_logic;
signal VGA_VS_O : std_logic;
signal VGA_R : std_logic_vector (3 downto 0);
signal VGA_B : std_logic_vector (3 downto 0);
signal VGA_G : std_logic_vector (3 downto 0);
signal kp_rows : std_logic_vector (1 to 4) := (others => '1');
signal kp_cols : std_logic_vector (1 to 4) := (others => '1');
begin

dut : game_top port map (
    clk => clk,
    sw => sw,
    VGA_HS_O  => VGA_HS_O,
    VGA_VS_O  => VGA_VS_O,
    VGA_R     => VGA_R,
    VGA_B     => VGA_B,
    VGA_G     => VGA_G,
    kp_rows   => kp_rows,
    kp_cols   => kp_cols
);

clock : process begin 
wait for 4 ns;
clk <= '1';

wait for 4 ns;
clk <= '0';
end process clock; 


sim : process begin 

   
    sw (0) <=  '0';

    sw (1) <=  '0';
    wait for 4 ms;

    sw(1) <= '1'; 
    wait for 1 ms;

    kp_rows <= (1 => '1', 2 => '0', 3 => '1', 4 => '1');

    kp_cols(2) <= '0';
    wait for 200 us;
    
    kp_rows <= (others => '1');
    kp_cols <= (others => '1');
    
    sw(1) <= '0';
    wait for 10 ms;
    report "Simulation finished" severity note;
    wait;
end process sim;


end tb;