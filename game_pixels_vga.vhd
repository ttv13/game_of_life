----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2025 04:06:28 PM
-- Design Name: 
-- Module Name: game_pixels_vga - Behavioral
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
--------------------------------------------------------------------------------
-- outputs grid and colors cells based on board input 
-- board updates every vs 
-- now needs vcount to find position on screen 
-- screen resolution => 640x480
--------------------------------------------------------------------------------
entity game_pixels_vga is
  Port (clk : in std_logic;
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
end game_pixels_vga;

architecture Behavioral of game_pixels_vga is

    signal board_sig : std_logic_vector (63 downto 0) := (others => '0');

    -- o|o|o|o|o|o|o| --8 cells 
    -- |o|o|o|o|o|o|o| --8 cells 
    constant cell_size : integer := 40; -- 40x40 px
    constant border_size : integer := 1;
    constant board_length : integer := 329; -- 41 * 8 + 1 px side lengths of board 

    constant x_start : integer := (640 - board_length) / 2; -- 155
    constant y_start : integer := (480 - board_length) / 2; -- 75

    constant x_end : integer := x_start + board_length - 1; -- 483
    constant y_end : integer := y_start + board_length - 1; -- 403

    signal board_selector : std_logic := '0';

    type board_type  is array (0 to 1) of std_logic_vector (63 downto 0);
    signal board_ar : board_type := (others => (others => '0'));

begin

buffer_select : process (board_selector) begin 

    if board_selector = '1' then 

        board_ar (0) <= board;
        board_sig <= board_ar (0);
    else 
        board_ar(1) <= board;
        board_sig <= board_ar (1);
    end if;
end process buffer_select;

process (clk) 

    variable lx : integer;
    variable ly : integer;
    variable col : integer;
    variable row : integer;
    variable index : integer;
    variable cursor_location : boolean;
begin 

if rising_edge (clk) then 

    if (en = '1' and vid = '1' and unsigned (hcount) >= x_start and unsigned(vcount) >= y_start and unsigned(hcount) <= x_end and unsigned(vcount) <= y_end) then --if currently in grid area 
        
        --find local coordinates 
        lx := to_integer (unsigned (hcount)) - x_start; -- 0-328
        ly := to_integer (unsigned (vcount)) - y_start; -- 0-328

        --Check for border lines 
        if (lx mod 41 = cell_size) or (ly mod 41 = cell_size) or lx = 0 or ly = 0 then

            r <= "1111";
            g <= "1111";
            b <= "1111";

        else --cells 

            col := lx / 41;
            row  := ly / 41;
            index := row * 8;
            cursor_location := (row = cursor_row) and (col  = cursor_col);


            if pause_sw = '1' and cursor_location then 

                r <= "1111";
                g <= "0000";
                b <= "1111";
            elsif board_sig (index) = '1' then 
                r <= "1111";
                g <= "0000";
                b <= "0000";
            else 
                r <= "0000";
                g <= "0000";
                b <= "0000";
            end if;


        end if;
    else 
        r <= (others => '0');
        g <= (others => '0');
        b <= (others => '0');
    end if; 
    
    if (vs = '0') then -- update board from board controller flip board sign
        board_selector <= not (board_selector);
        
    end if;
    
end if; -- rising edge
end process;

end Behavioral;