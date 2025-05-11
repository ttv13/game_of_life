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

entity hdmi_tb is
--  Port ( );
end hdmi_tb;

architecture tb of hdmi_tb is

signal clk : std_logic := '0';
signal hdmi_tx_clk_n : std_logic;
signal hdmi_tx_clk_p : std_logic;
signal hdmi_tx_n : std_logic_vector (2 downto 0);
signal hdmi_tx_p : std_logic_vector (2 downto 0);

signal hdmi_tx_hpd : std_logic;
signal hdmi_tx_sda : std_logic;
signal hdmi_tx_scl : std_logic;

component hdmi_top port (
    clk : in std_logic;
    hdmi_tx_clk_n : out std_logic;
    hdmi_tx_clk_p : out std_logic;
    hdmi_tx_n : out std_logic_vector(2 downto 0);
    hdmi_tx_p : out std_logic_vector(2 downto 0);

    hdmi_tx_hpd : out std_logic;
    hdmi_tx_scl : out std_logic;
    hdmi_tx_sda : out std_logic
);
end component;

begin

dut : hdmi_top port map (
    clk => clk,
    hdmi_tx_clk_n => hdmi_tx_clk_n,
    hdmi_tx_clk_p => hdmi_tx_clk_p,
    hdmi_tx_n => hdmi_tx_n,
    hdmi_tx_p => hdmi_tx_p,
    hdmi_tx_hpd => hdmi_tx_hpd,
    hdmi_tx_sda => hdmi_tx_sda,
    hdmi_tx_scl => hdmi_tx_scl
);

clock : process begin 
wait for 4 ns;
clk <= '1';

wait for 4 ns;
clk <= '0';
end process clock; 

end tb;