library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_counts is
 port(
     nRst: in std_logic;
     c_A: in std_logic_vector(31 downto 0);
     d_A: in std_logic;
     coun_O : out std_logic_vector(31 downto 0);
     done_O : out std_logic
 );
end adder_counts;

architecture Behavioral of adder_counts is
    signal s_A: unsigned(31 downto 0);
    signal s_count: unsigned(31 downto 0); 
begin
    s_A <= unsigned(c_A);    
    s_count <= (others=>'0') when nRst = '1' else
               (s_A);
    
    coun_O <= std_logic_vector(s_count);
    done_O <= d_A;    
end Behavioral;