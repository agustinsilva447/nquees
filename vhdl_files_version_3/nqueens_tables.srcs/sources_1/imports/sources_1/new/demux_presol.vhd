library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity demux_presol is
 port(
     clk, nRst: in std_logic;
     r_A: in std_logic;
     data_I : in std_logic_vector(31 downto 0);
     empt_I : in std_logic;
     d_A: out std_logic_vector(31 downto 0);
     e_A: out std_logic;     
     r_fifo: out std_logic
 );
end demux_presol;

architecture Behavioral of demux_presol is
    signal S: unsigned(0 downto 0);
    signal r_s: std_logic;
begin    
    d_A <= data_I;
    r_fifo <= r_s;
    r_s <= r_A; 
    
    with S select
        e_A <= empt_I when "0",
                  '1' when others;     
    
    process (clk) is
    begin
        if (clk'event and clk = '1') then     
            if nRst = '1' then 
                S <= "0";            
            else
                S <= S;
            end if; 
        end if; 
    end process;
    
end Behavioral;