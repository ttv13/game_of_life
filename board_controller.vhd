----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2025 04:06:28 PM
-- Design Name: 
-- Module Name: board_controller - Behavioral
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
-- controls 2d array representing the play board (8x8) (wraps)
-- when play en then should play the game of life 
-- when paused needs to handle btns for draw function
-- 
-- Outputs flatten board 8x8 = 64 
--------------------------------------------------------------------------------
entity board_controller is
  Port (clk : in std_logic; 
        en : in std_logic; -- tie it to vs in vga so board gets updated and sent to vga once frame is ready 
        rst : in std_logic;
        pause_sw : in std_logic;
        kypd_btn : in std_logic_vector(15 downto 0);
        cursor_row : out integer range 0 to 7;
        cursor_col : out integer range 0 to 7;
        board_out : out std_logic_vector(63 downto 0)
);
end board_controller;

architecture Behavioral of board_controller is

    constant width : integer := 7; -- for 8x8 grid 
    type board_type is array (0 to width) of std_logic_vector (width downto 0);

    signal board : board_type := (others => (others => '0'));
    signal next_board : board_type := (others => (others => '0'));

    signal vs_sig , vs_en : std_logic;

    signal  draw_row, draw_col : integer range 0 to width := 0;
    
--------------------------------------------------------------------------------
-- Wraping Function for indexes beyond width
--------------------------------------------------------------------------------

function wrap (i : integer) return integer is 
    
begin 
    if (i < 0) then -- wraps either to right or bottom
        return width;

    elsif (i > width) then  -- wraps to left or top 
        return 0;

    else 
        return i;       -- no wrapping needed
    end if;
end function;

--------------------------------------------------------------------------------
-- Neighbor function for next generation calculation
-- Must check 8 cells around board [i][j] for alive neighbors 
--------------------------------------------------------------------------------
function count_neighbor (i, j :  integer; game_board : board_type) return integer is 

    variable count : integer; 
    
    variable north : integer;
    variable south : integer;

    variable west : integer;
    variable east : integer;

    variable north_west : integer;
    variable north_east : integer;

    variable south_west : integer;
    variable south_east : integer;

begin 

    north := to_integer(Unsigned(game_board( wrap(i-1) )( j )));
    south := to_integer(Unsigned(game_board( wrap(i+1) )( j )));
    west := to_integer(Unsigned(game_board( i )( wrap(j-1) )));
    east := to_integer(Unsigned(game_board( i )( wrap(j+1) )));

    north_west := to_integer(Unsigned(game_board( wrap(i-1) )( wrap(j-1) )));
    north_east := to_integer(Unsigned(game_board( wrap(i-1) )( wrap(j+1) )));

    south_west := to_integer(Unsigned(game_board( wrap(i+1) )( wrap(j-1) )));
    south_east := to_integer(Unsigned(game_board( wrap(i+1) )( wrap(j+1) )));

    count :=  north + north_east + north_west + south + south_east + south_west + west + east;

    return count;
end function;

signal first_start : integer := 0;
begin

    cursor_row <= draw_row;
    cursor_col <= draw_col;

board_gen : process (clk) 

    variable neighbor : integer;
begin 

if rising_edge (clk) then 

    if first_start = 0 then 
        board_out <= (others => '0');
        first_start <= first_start + 1;
    end if;

    vs_sig <= en;
    vs_en <= vs_sig and (not en); --Falling edge for vs (1 and not 0)

    if rst = '1' then   
        board <= (others => (others => '0'));
        next_board <= (others => (others => '0'));
    
    elsif (vs_en = '1' and pause_sw = '0') then -- Play computation 
 
        for i in 0 to width loop --steps through 8x8 board
            for j in 0 to width loop

                neighbor := count_neighbor (i, j, board);

                if (board (i)(j) = '1') then 
                    
                    if ((neighbor = 2) or (neighbor = 3)) then 
                        next_board (i)(j) <= '1';

                    else
                        next_board (i)(j) <= '0';
                    end if;
                else
                    if (neighbor = 3) then 
                        next_board (i)(j) <= '1';
                    
                    else
                        next_board (i)(j) <= '0';
                    end if;

                end if; --computing cells 
            end loop; --col 
        end loop; -- row
        
        board <= next_board;    -- update board to next board 

    elsif  (vs_en = '1' and pause_sw = '1') then -- Draw function

        -- moving cursor 
        if kypd_btn (1) = '1' then --2 up 

            draw_row <= wrap (draw_row - 1);

        elsif kypd_btn (4) = '1' then -- 5 down 
            draw_row <= wrap (draw_row + 1);
        end if;

        if kypd_btn (3) = '1' then --4 left

            draw_col <= wrap (draw_col - 1);

        elsif kypd_btn (5) = '1' then -- 6 right 
            draw_col <= wrap (draw_col + 1);
        end if;

        if kypd_btn (0) = '1' then -- 1 toggle 

            board (draw_row) (draw_col) <= not board (draw_row) (draw_col);
        end if;

        next_board <= board;
    end if; -- reset

end if; -- rising edge
end process board_gen;

-- Flatten board to output as logic vector  63 downto 0
board_flat : process (board) begin 
for i in 0 to width loop
    for j in 0 to width loop 

        board_out (i*width + j) <= board (i)(j);
    end loop;
end loop;


end process board_flat;
end Behavioral;