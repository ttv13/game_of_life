library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- ===========================================================================
--  Top‑level wrapper for “Conway’s Game of Life” on the Digilent Zybo Z‑7010
--  -------------------------------------------------------------------------
--  * sys_clk  : 125 MHz oscillator on the Zybo (Bank 35, pin Y9) – or any
--               clock routed to the PL.
--  * sw_rst   : Slide‑switch SW0 – active‑high master reset for the design.
--  * sw_pause : Slide‑switch SW1 – high = pause / draw‑mode, low = run.
--  * VGA_*    : 4‑bit R‑G‑B, HSYNC, VSYNC driven straight to the VGA port.
--  * Keypad   : 4×4 PMOD membrane keypad on JA/ JB (rows are inputs,
--               columns are tri‑stated outputs driven low one at a time).
--
--  This file instantiates **all** lower‑level blocks you supplied:
--
--    clock_div         – produces a 25 MHz ‘enable’ pulse (div)
--    vga_ctrl          – generates hcount / vcount / HSYNC / VSYNC / VID
--    board_controller  – Conway rule‑step + draw‑mode
--    pmod_keypad       – scans the keypad and debounces 16 buttons
--    game_pixels_vga   – turns board + cursor into RGB pixels
--
--  Timing scheme
--  -------------
--  sys_clk 125 MHz ─► vga_ctrl      (clk)
--                    vga_ctrl.en   <= div25_en   (25 MHz pulse)
--                    board_ctrl.en <= vs         (update once per frame)
--                    game_pix.en   <= '1'        (active whenever VID='1')
-- ===========================================================================

entity top_game_of_life is
    Port (
        ----------------------------------------------------------------------
        -- Clocks / switches
        ----------------------------------------------------------------------
        sys_clk   : in  std_logic;                        -- 125 MHz
        sw_rst    : in  std_logic;                        -- SW0  : reset   (active‑high)
        sw_pause  : in  std_logic;                        -- SW1  : pause   (active‑high)

        ----------------------------------------------------------------------
        -- VGA output (GPIO Bank 13 on Zybo) – constrain in XDC as needed
        ----------------------------------------------------------------------
        vga_r     : out std_logic_vector(3 downto 0);
        vga_g     : out std_logic_vector(3 downto 0);
        vga_b     : out std_logic_vector(3 downto 0);
        vga_hs    : out std_logic;
        vga_vs    : out std_logic;

        ----------------------------------------------------------------------
        -- 4×4 membrane keypad on PMOD (rows = inputs, columns = tri‑state)
        ----------------------------------------------------------------------
        kp_rows   : in  std_logic_vector(1 to 4);
        kp_cols   : inout std_logic_vector(1 to 4)
    );
end top_game_of_life;

architecture rtl of top_game_of_life is

    --------------------------------------------------------------------------
    -- Internal signals
    --------------------------------------------------------------------------
    signal div25_en    : std_logic;                          -- 25 MHz enable
    signal hcount      : std_logic_vector(9 downto 0);
    signal vcount      : std_logic_vector(9 downto 0);
    signal vid_act     : std_logic;
    signal vs_sync     : std_logic;

    signal cursor_row  : integer range 0 to 7;
    signal cursor_col  : integer range 0 to 7;
    signal life_board  : std_logic_vector(63 downto 0);

    signal kp_keys     : std_logic_vector(0 to 15);

begin

    --------------------------------------------------------------------------
    -- 25 MHz enable generator (1‑pulse‑in‑5 of sys_clk)
    --------------------------------------------------------------------------
    clk_div_i : entity work.clock_div
        port map (
            clk => sys_clk,
            div => div25_en
        );

    --------------------------------------------------------------------------
    -- VGA timing generator – 640×480 @ 60 Hz (25 MHz pixel rate)
    --------------------------------------------------------------------------
    vga_ctrl_i : entity work.vga_ctrl
        port map (
            clk    => sys_clk,          -- 125 MHz master clock
            en     => div25_en,         -- 25 MHz enable pulse
            hcount => hcount,
            vcount => vcount,
            vid    => vid_act,
            hs     => vga_hs,
            vs     => vs_sync
        );

    --------------------------------------------------------------------------
    -- 4×4 membrane keypad scanner / debouncer
    --------------------------------------------------------------------------
    keypad_i : entity work.pmod_keypad
        generic map (
            clk_freq    => 125_000_000, -- Zybo clock
            stable_time => 10           -- 10 ms debounce
        )
        port map (
            clk     => sys_clk,
            reset_n => not sw_rst,      -- active‑low in keypad IP
            rows    => kp_rows,
            columns => kp_cols,
            keys    => kp_keys
        );

    --------------------------------------------------------------------------
    -- Conway’s Game‑of‑Life controller (rule‑step + draw cursor)
    --------------------------------------------------------------------------
    board_ctrl_i : entity work.board_controller
        port map (
            clk         => sys_clk,
            en          => vs_sync,     -- one update per video frame
            rst         => sw_rst,
            pause_sw    => sw_pause,
            kypd_btn    => kp_keys(15 downto 0),
            cursor_row  => cursor_row,
            cursor_col  => cursor_col,
            board_out   => life_board
        );

    --------------------------------------------------------------------------
    -- Pixel generator – map 8×8 board to 640×480 RGB
    --------------------------------------------------------------------------
    game_pix_i : entity work.game_pixels_vga
        port map (
            clk        => sys_clk,
            en         => '1',          -- always draw while VID = '1'
            vs         => vs_sync,
            vid        => vid_act,
            hcount     => hcount,
            vcount     => vcount,
            cursor_row => cursor_row,
            cursor_col => cursor_col,
            pause_sw   => sw_pause,
            r          => vga_r,
            g          => vga_g,
            b          => vga_b,
            board      => life_board
        );

    --------------------------------------------------------------------------
    -- Drive the VSYNC output (direct from timing block)
    --------------------------------------------------------------------------
    vga_vs <= vs_sync;

end rtl;
