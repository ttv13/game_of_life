library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity GameOfLife is
    Port (
        clk     : in  STD_LOGIC;
        rst     : in  STD_LOGIC;
        enable  : in  STD_LOGIC;
        grid_out: out STD_LOGIC_VECTOR(63 downto 0)  -- 8x8 flattened grid
    );
end GameOfLife;

architecture Behavioral of GameOfLife is

    constant GRID_SIZE : integer := 8;

    -- Define the grid as rows of std_logic_vector
    type grid_array is array (0 to GRID_SIZE - 1) of std_logic_vector(GRID_SIZE - 1 downto 0);
    signal grid      : grid_array;
    signal next_grid : grid_array;

    -- Wrap function for toroidal grid
    function wrap(i : integer) return integer is
    begin
        if i < 0 then
            return GRID_SIZE - 1;
        elsif i >= GRID_SIZE then
            return 0;
        else
            return i;
        end if;
    end function;

    -- Count alive neighbors
    function count_neighbors(x, y : integer; g : grid_array) return integer is
        variable count : integer := 0;
    begin
        for dx in -1 to 1 loop
            for dy in -1 to 1 loop
                if not (dx = 0 and dy = 0) then
                    if g(wrap(x + dx))(wrap(y + dy)) = '1' then
                        count := count + 1;
                    end if;
                end if;
            end loop;
        end loop;
        return count;
    end function;

begin

    process(clk, rst)
    begin
        if rst = '1' then
            -- Clear grid
            for i in 0 to GRID_SIZE - 1 loop
                grid(i) <= (others => '0');
            end loop;

            -- Initialize a glider pattern
            grid(1)(2) <= '1';
            grid(2)(3) <= '1';
            grid(3)(1) <= '1';
            grid(3)(2) <= '1';
            grid(3)(3) <= '1';

        elsif rising_edge(clk) then
            if enable = '1' then
                -- Compute next generation
                for i in 0 to GRID_SIZE - 1 loop
                    for j in 0 to GRID_SIZE - 1 loop
                        variable neighbors : integer := count_neighbors(i, j, grid);
                        if grid(i)(j) = '1' then
                            if neighbors = 2 or neighbors = 3 then
                                next_grid(i)(j) <= '1';
                            else
                                next_grid(i)(j) <= '0';
                            end if;
                        else
                            if neighbors = 3 then
                                next_grid(i)(j) <= '1';
                            else
                                next_grid(i)(j) <= '0';
                            end if;
                        end if;
                    end loop;
                end loop;
                grid <= next_grid;
            end if;
        end if;
    end process;

    -- Flatten grid to 64-bit output
    process(grid)
    begin
        for i in 0 to GRID_SIZE - 1 loop
            for j in 0 to GRID_SIZE - 1 loop
                grid_out(i * GRID_SIZE + j) <= grid(i)(j);
            end loop;
        end loop;
    end process;

end Behavioral;
