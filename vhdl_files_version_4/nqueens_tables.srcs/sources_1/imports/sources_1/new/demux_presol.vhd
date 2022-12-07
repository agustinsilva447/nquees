library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity demux_presol is
 port(
     clk, nRst: in std_logic;
     r_A,r_B,r_C,r_D: in std_logic;
     data_I : in std_logic_vector(31 downto 0);
     empt_I : in std_logic;
     d_A,d_B,d_C,d_D: out std_logic_vector(31 downto 0);
     e_A,e_B,e_C,e_D: out std_logic;     
     r_fifo: out std_logic
 );
end demux_presol;

architecture Behavioral of demux_presol is
    signal S: unsigned(1 downto 0);
    signal r_s: std_logic;
begin    
    d_A <= data_I;
    d_B <= data_I;
    d_C <= data_I;
    d_D <= data_I;
    r_fifo <= r_s;
    r_s <= r_A or r_B or r_C or r_D; 
    
    with S select
        e_A <= empt_I when "00",
                  '1' when others;    
    with S select
        e_B <= empt_I when "01",
                  '1' when others;    
    with S select
        e_C <= empt_I when "10",
                  '1' when others;    
    with S select
        e_D <= empt_I when "11",
                  '1' when others;    
    
    process (clk) is
    begin
        if (clk'event and clk = '1') then     
            if nRst = '1' then 
                S <= "00";            
            elsif (r_s = '1') then
                S <= S + 1;    
            else
                S <= S;
            end if; 
        end if; 
    end process;
    
end Behavioral;