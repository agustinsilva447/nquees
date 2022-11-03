library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity top_nqueens_tb is
end entity;

architecture sim of top_nqueens_tb is        
    constant F: integer := 16 ;  -- depth of the fifo
    constant M: integer := 13 ;  -- size of the board MxM
    constant N: integer := 5 ; -- N-1 bits required to count upto size of the board;
    constant P: integer := 32 ; -- N bits required for the counter;
    signal counter: std_logic_vector(P-1 downto 0);
    signal done: std_logic;   
    signal p_nRst, clk: std_logic;     
    
begin
    top: entity work.top_nqueens
    generic map (F => F, M => M, N => N, P => P)
    port map (clk=>clk, p_nRst=>p_nRst, done=>done, counter=>counter);
            
    clock_process: process
    begin
         clk <= '0';
         wait for 5 ns;
         clk <= '1';
         wait for 5 ns;
    end process;
    
    counter_process: process is
    begin
        p_nRst <= '1';
        wait for 5 ns;
        p_nRst <= '0';  
        wait;
    end process;
end architecture;