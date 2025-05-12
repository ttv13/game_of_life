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
        signal sw : in std_logic_vector (1 downto 0);

        signal VGA_HS_O : out std_logic;
        signal VGA_VS_O : out std_logic;
        signal VGA_R : out std_logic_vector (3 downto 0);
        signal VGA_B : out std_logic_vector (3 downto 0);
        signal VGA_G : out std_logic_vector (3 downto 0);

        signal kp_rows : in std_logic_vector (1 to 4);
        signal kp_cols : inout std_logic_vector (1 to 4)
  );
end game_top;

architecture Behavioral of game_top is

component clock_div port (
        clk : in std_logic;
        div : out std_logic
);
end component;

component game_clock_div port (
        clk : in std_logic;
        div : out std_logic
);
end component;

component game_pixels_vga port (
        clk : in std_logic;
        en : in std_logic;
        vs : in std_logic;
        vid : in std_logic;
        hcount : in std_logic_vector (9 downto 0);
        vcount : in std_logic_vector(9 downto 0);

        cursor_row : in integer range 0 to 7;
        cursor_col : in integer range 0 to 7;
        pause_sw : in std_logic;

        r : out std_logic_vector (3 downto 0);
        b : out std_logic_vector (3 downto 0);
        g : out std_logic_vector (3 downto 0);
        
        board : in std_logic_vector (63 downto 0)
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

component board_controller port (
        clk : in std_logic; 
        en : in std_logic;
        rst : in std_logic;
        pause_sw : in std_logic;
        kypd_btn : in std_logic_vector(15 downto 0);
        cursor_row : out integer range 0 to 7;
        cursor_col : out integer range 0 to 7;
        board_out : out std_logic_vector(63 downto 0)
);
end component;

component pmod_keypad generic (
    clk_freq : integer := 125_000_000;
    stable_time : integer := 3
);
    port (
        clk     :  IN     STD_LOGIC;
        reset_n :  IN     STD_LOGIC;
        rows    :  IN     STD_LOGIC_VECTOR(1 TO 4);
        columns :  BUFFER STD_LOGIC_VECTOR(1 TO 4);
        keys    :  OUT    STD_LOGIC_VECTOR(0 TO 15)
);
end component;


-- clk div
signal vga_div : std_logic;
signal game_div : std_logic;

-- vga ctrl sigs 
signal vs_sig : std_logic;
signal hcount_sig : std_logic_vector (9 downto 0);
signal vcount_sig : std_logic_vector (9 downto 0);
signal vid_sig : std_logic;


--board Controller 
signal cursor_row_sig : integer range 0 to 7;
signal cursor_col_sig : integer range 0 to 7;
signal board_out_sig : std_logic_vector (63 downto 0);


--kypd 
signal keys_sig : std_logic_vector (15 downto 0);


begin

    vga_clk : clock_div port map (
        clk => clk,
        div => vga_div
    );

    game_clk : game_clock_div port map(
        clk => clk,
        div => game_div
    );

    vga : vga_ctrl port map (
        clk => clk,
        en => vga_div,
        hcount => hcount_sig,
        vcount => vcount_sig,
        vid => vid_sig,
        hs => VGA_HS_O,
        vs => vs_sig
    );

    keypad : pmod_keypad generic map (
        clk_freq => 125_000_000,
        stable_time => 3
    )
    port map (
        clk => clk,
        reset_n => not sw(0),
        rows => kp_rows,
        columns => kp_cols,
        keys => keys_sig
    );

    game_grid : board_controller port map (
        clk => clk,
        en => game_div,
        rst => sw(0),
        pause_sw => sw(1),
        kypd_btn => keys_sig,
        cursor_row => cursor_row_sig,
        cursor_col => cursor_col_sig,
        board_out => board_out_sig
    );

    pixel : game_pixels_vga port map (
        clk => clk,
        en => vga_div,
        vs => vs_sig,
        vid => vid_sig,
        hcount => hcount_sig,
        vcount => vcount_sig,
        cursor_row => cursor_row_sig,
        cursor_col => cursor_col_sig,
        pause_sw => sw(1),
        r => VGA_R,
        b => VGA_B,
        g =>  VGA_G,
        board => board_out_sig
    );

    VGA_VS_O <= vs_sig;
end Behavioral;
