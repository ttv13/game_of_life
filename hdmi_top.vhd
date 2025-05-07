----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2025 04:18:23 PM
-- Design Name: 
-- Module Name: hdmi_top - Behavioral
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

entity hdmi_top is
  Port (signal clk : in std_logic;
        signal hdmi_tx_clk_n : out std_logic;
        signal hdmi_tx_clk_p : out std_logic;
        signal hdmi_tx_n : out std_logic_vector(2 downto 0);
        signal hdmi_tx_p : out std_logic_vector(2 downto 0);

        signal hdmi_tx_hpd : out std_logic;
        signal hdmi_tx_scl : out std_logic;
        signal hdmi_tx_sda : out std_logic

  );
end hdmi_top;

architecture Behavioral of hdmi_top is

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

component pixel_pusher port (
        signal clk : in std_logic;
        signal en : in std_logic;
        signal vs : in std_logic;
        signal vid : in std_logic;
        signal pixel : in std_logic_vector (7 downto 0);
        signal hcount : in std_logic_vector (9 downto 0);
        signal r : out std_logic_vector (7 downto 0);
        signal b : out std_logic_vector (7 downto 0);
        signal g : out std_logic_vector (7 downto 0);
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

component rgb2dvi_0 port (
        TMDS_Clk_p : OUT STD_LOGIC;
        TMDS_Clk_n : OUT STD_LOGIC;
        TMDS_Data_p : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        TMDS_Data_n : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        aRst : IN STD_LOGIC;
        vid_pData : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
        vid_pVDE : IN STD_LOGIC;
        vid_pHSync : IN STD_LOGIC;
        vid_pVSync : IN STD_LOGIC;
        PixelClk : IN STD_LOGIC;
        SerialClk : IN STD_LOGIC
);
end component;

signal addr_sig : std_logic_vector (17 downto 0);
signal douta_sig : std_logic_vector (7 downto 0);
signal en_sig : std_logic;
signal vs_sig : std_logic;

signal vid_sig : std_logic;
signal hcount_sig : std_logic_vector (9 downto 0);

signal hs_sig : std_logic;

signal vga_r_sig : std_logic_vector (7 downto 0);
signal vga_g_sig : std_logic_vector (7 downto 0);
signal vga_b_sig : std_logic_vector (7 downto 0);

signal arst_sig : std_logic := '0';
begin
    hdmi_tx_hpd <= 1;
pic : picture port map (
    clka => clk,
    addra => addr_sig,
    douta => douta_sig 
);

clk_div : clock_div port map (
    clk => clk,
    div => en_sig
);

pixel : pixel_pusher port map (
    clk => clk,
    en => en_sig,
    vs => vs_sig,
    vid => vid_sig,
    pixel => douta_sig,
    hcount => hcount_sig,
    r => vga_r_sig,
    b => vga_b_sig,
    g => vga_g_sig,
    addr => addr_sig
);

vga : vga_ctrl port map (
    clk => clk,
    en => en_sig,
    hcount => hcount_sig,
    vcount => open ,
    vid => vid_sig,
    hs => hs_sig,
    vs => vs_sig
);

hdmi : rgb2dvi_0 port map (
    TMDS_Clk_p => hdmi_tx_clk_p,
    TMDS_Clk_n => hdmi_tx_clk_n,
    TMDS_Data_p => hdmi_tx_p,
    TMDS_Data_n => hdmi_tx_n,
    aRst => arst_sig,
    vid_pData => vga_r_sig & vga_g_sig & vga_b_sig,
    vid_pVDE => vid_sig,
    vid_pHSync => hs_sig,
    vid_pVSync => vs_sig,
    PixelClk => en_sig,
    SerialClk => clk
);
end Behavioral;
