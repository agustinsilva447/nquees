library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity up_counter is
    generic (
        M : integer; -- size of the board MxM
        N : integer  -- N bits required to count upto M-1
    );    
    port(
            clk, ce, reset, reset2 : in std_logic;            
            complete_tick : out std_logic;
            count : out std_logic_vector(N-1 downto 0)
    );
end up_counter;

architecture arch of up_counter is
signal count_reg : unsigned(N-1 downto 0);
begin
    process(clk)
    begin        
        if (rising_edge(clk)) then    
            if (reset = '1' or reset2 = '1') then 
                count_reg <= to_unsigned(0, N);
            elsif (ce='1') then
                count_reg <= (count_reg + 1);
            else  
                count_reg <= count_reg;
            end if;        
        end if;
    end process;
    
    complete_tick <= '1' when count_reg = (M) else '0'; 
    count <= std_logic_vector(count_reg); 
    
end arch;