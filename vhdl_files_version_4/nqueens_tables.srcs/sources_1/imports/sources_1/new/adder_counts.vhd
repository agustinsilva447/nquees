library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_counts is
 port(
     nRst: in std_logic;
     c_A,c_B,c_C,c_D: in std_logic_vector(63 downto 0);
     d_A,d_B,d_C,d_D: in std_logic;
     coun_O : out std_logic_vector(63 downto 0);
     done_O : out std_logic
 );
end adder_counts;

architecture Behavioral of adder_counts is
    signal s_A, s_B, s_C, s_D: unsigned(63 downto 0);
    signal s_count: unsigned(63 downto 0); 
begin
    s_A <= unsigned(c_A);
    s_B <= unsigned(c_B);
    s_C <= unsigned(c_C);
    s_D <= unsigned(c_D);    
    s_count <= (s_A +  s_B +  s_C +  s_D);    
    coun_O <= std_logic_vector(s_count);
    done_O <= d_A and d_B and d_C and d_D;    
end Behavioral;