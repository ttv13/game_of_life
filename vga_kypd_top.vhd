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

entity vga_kypd_top is
  Port (signal clk : in std_logic;
        signal kp_rows : in std_logic_vector (1 to 4);
        signal kp_cols : inout std_logic_vector (1 to 4);
        signal VGA_HS_O : out std_logic;
        signal VGA_VS_O : out std_logic;
        signal VGA_R : out std_logic_vector (3 downto 0);
        signal VGA_B : out std_logic_vector (3 downto 0);
        signal VGA_G : out std_logic_vector (3 downto 0)

  );
end vga_kypd_top;

architecture Behavioral of vga_kypd_top is

component pmod_keypad generic (
    clk_freq : integer := 50_000_000;
    stable_time : integer := 10
);
    port (
        clk     :  IN     STD_LOGIC;
        reset_n :  IN     STD_LOGIC;
        rows    :  IN     STD_LOGIC_VECTOR(1 TO 4);
        columns :  BUFFER STD_LOGIC_VECTOR(1 TO 4);
        keys    :  OUT    STD_LOGIC_VECTOR(0 TO 15)
);
end component;

component clock_div port (
        clk : in std_logic;
        div : out std_logic
);
end component;

component vga_kypd_pixel_pusher port (
        signal clk : in std_logic;
        signal en : in std_logic;
        signal vid : in std_logic;
        signal hcount : in std_logic_vector (9 downto 0);
        signal r : out std_logic_vector (3 downto 0);
        signal b : out std_logic_vector (3 downto 0);
        signal g : out std_logic_vector (3 downto 0);
        signal kypd_btn : in std_logic_vector (15 downto 0)
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

signal keys_sig : std_logic_vector (15 downto 0);
begin


clk_div : clock_div port map (
    clk => clk,
    div => en_sig
);

pixel : vga_kypd_pixel_pusher port map (
    clk => clk,
    en => en_sig,
    vid => vid_sig,
    hcount => hcount_sig,
    r => VGA_R,
    b => VGA_B,
    g => VGA_G,
    kypd_btn => keys_sig
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

    keypad : pmod_keypad generic map (
        clk_freq => 50_000_000,
        stable_time => 10
    )
    port map (
        clk => clk,
        reset_n => '1',
        rows => kp_rows,
        columns => kp_cols,
        keys => keys_sig
    );

VGA_VS_O <= vs_sig;
end Behavioral;
