library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_display is
    Port (
        clk40    : in  STD_LOGIC; -- 40 MHz VGA clock
        grid     : in  STD_LOGIC_VECTOR(63 downto 0); -- 8x8 grid
        hsync    : out STD_LOGIC;
        vsync    : out STD_LOGIC;
        red      : out STD_LOGIC_VECTOR(3 downto 0);
        green    : out STD_LOGIC_VECTOR(3 downto 0);
        blue     : out STD_LOGIC_VECTOR(3 downto 0)
    );
end vga_display;

architecture Behavioral of vga_display is

    component vga_sync
        Port (
            clk      : in  STD_LOGIC;
            hsync    : out STD_LOGIC;
            vsync    : out STD_LOGIC;
            visible  : out STD_LOGIC;
            hcount   : out INTEGER range 0 to 1055;
            vcount   : out INTEGER range 0 to 627
        );
    end component;

    signal hcount, vcount : integer := 0;
    signal visible        : std_logic;

    constant CELL_SIZE : integer := 40; -- 40x40 pixels per cell
    signal cell_x, cell_y : integer range 0 to 7;

    signal pixel_index : integer range 0 to 63;

begin

    u_sync : vga_sync
        port map (
            clk     => clk40,
            hsync   => hsync,
            vsync   => vsync,
            visible => visible,
            hcount  => hcount,
            vcount  => vcount
        );

    process(clk40)
    begin
        if rising_edge(clk40) then
            if visible = '1' then
                cell_x <= hcount / CELL_SIZE;
                cell_y <= vcount / CELL_SIZE;
                pixel_index <= cell_y * 8 + cell_x;

                if grid(pixel_index) = '1' then
                    red   <= "1111";
                    green <= "1111";
                    blue  <= "1111";
                else
                    red   <= "0000";
                    green <= "0000";
                    blue  <= "0000";
                end if;
            else
                red   <= (others => '0');
                green <= (others => '0');
                blue  <= (others => '0');
            end if;
        end if;
    end process;

end Behavioral;
