----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2025 04:18:23 PM
-- Design Name: 
-- Module Name: image_top - Behavioral
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

entity image_top is
  Port (signal clk : in std_logic;

        signal VGA_HS_O : out std_logic;
        signal VGA_VS_O : out std_logic;
        signal VGA_R : out std_logic_vector (3 downto 0);
        signal VGA_B : out std_logic_vector (3 downto 0);
        signal VGA_G : out std_logic_vector (3 downto 0)

  );
end image_top;

architecture Behavioral of image_top is

component picture port (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
end component;

component clock_div port (
        clk : in std_logic;
        div : out std_logic
);
end component;

component vga_pixel_pusher port (
        signal clk : in std_logic;
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

signal addr_sig : std_logic_vector (17 downto 0);
signal douta_sig : std_logic_vector (7 downto 0);
signal en_sig : std_logic;
signal vs_sig : std_logic;

signal vid_sig : std_logic;
signal hcount_sig : std_logic_vector (9 downto 0);
begin

pic : picture port map (
    clka => clk,
    addra => addr_sig,
    douta => douta_sig 
);

clk_div : clock_div port map (
    clk => clk,
    div => en_sig
);

pixel : vga_pixel_pusher port map (
    clk => clk,
    en => en_sig,
    vs => vs_sig,
    vid => vid_sig,
    pixel => douta_sig,
    hcount => hcount_sig,
    r => VGA_R,
    b => VGA_B,
    g => VGA_G,
    addr => addr_sig
);

vga : vga_ctrl port map (
    clk => clk,
    en => en_sig,
    hcount => hcount_sig,
    vcount => open ,
    vid => vid_sig,
    hs => VGA_HS_O,
    vs => vs_sig
);

VGA_VS_O <= vs_sig;
end Behavioral;
