----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2025 04:18:23 PM
-- Design Name: 
-- Module Name: game_top - Behavioral
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

entity game_top is
  Port (signal clk : in std_logic;
        signal vga_hs : out std_logic;
        signal vga_vs : out std_logic;
        signal vga_r : out std_logic_vector (3 downto 0);
        signal vga_b : out std_logic_vector (3 downto 0);
        signal vga_g : out std_logic_vector (3 downto 0)
  );
end game_top;

architecture Behavioral of game_top is



component clock_div port (
        clk : in std_logic;
        div : out std_logic
);
end component;

component pixel_pusher port (

);
end component;

component vga_ctrl port (
        signal clk : in std_logic;
        signal en : in std_logic;
        signal hcount : out std_logic_vector (9 downto 0);
        signal vcount : out std_logic_vector (9 downto 0);
        signal vid : out std_logic;
        signal hs : out std_logic;
        signal vs : out std_logic
);
end component;


signal en_sig : std_logic;
signal vs_sig : std_logic;

signal vid_sig : std_logic;
signal hcount_sig : std_logic_vector (9 downto 0);


begin

clk_div : clock_div port map (
    clk => clk,
    div => en_sig
);

pixel : pixel_pusher port map (

);

vga : vga_ctrl port map (
    clk => clk,
    en => en_sig,
    hcount => hcount_sig,
    vcount =>  ,
    vid => vid_sig,
    hs => vga_hs,
    vs => vs_sig
);

vga_vs <= vs_sig;
end Behavioral;
