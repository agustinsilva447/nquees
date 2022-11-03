library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ct_logic is
    generic (
        K : integer; -- position of the block (starting from zero) 
        N : integer  -- N+1 bits required to count upto size of the board
    );    
    port(
        clk, reset : in std_logic;
        a: in std_logic_vector(0 to (K*N-1));
        u: in std_logic_vector(N-1 downto 0);
        valid: out std_logic ;
        done : out std_logic 
    );
end entity;

architecture arch of ct_logic is

type array_a is array (0 to K-1) of std_logic_vector(0 to N-1);
signal arr_a : array_a;

signal valid_aux: std_logic;
signal done_aux: std_logic;
signal a_j : unsigned(N-1 downto 0);
signal u_k : unsigned(N-1 downto 0);
signal count : unsigned(N-1 downto 0);
signal j: integer range 0 to 2**N-1;

begin
    u_k <= unsigned(u);
    valid <= valid_aux;
    done <= done_aux;    
    
    g_GENERATE_FOR: for ii in 0 to K-1 generate
    h_GENERATE_FOR: for jj in 0 to N-1 generate
      arr_a(ii)(jj) <=  a(ii*N+jj);        
    end generate h_GENERATE_FOR;
    end generate g_GENERATE_FOR;
    a_j <= unsigned(arr_a(j)) when j<K else
           unsigned(arr_a(0));    
    
    process(clk)
    begin  
        if (rising_edge(clk)) then      
            if (reset = '1') then
                done_aux <= '0';
                valid_aux <= '0';  
                j <= 0;
                count <= (others => '0');
            else
                if ((j<K) and (done_aux = '0')) then
                    if ((u_k /= a_j) and (abs(signed(u_k) - signed(a_j)) /= (K - j))) then
                        count <= count + 1;                                        
                    else
                        done_aux <= '1';
                        valid_aux <= '0';
                    end if;  
                    j <= j + 1;    
                elsif (j=K) then     
                    done_aux <= '1';
                    if (count = K) then
                        valid_aux <= '1';    
                    end if; 
                end if; 
            end if;    
        end if;
    end process;   
end arch;