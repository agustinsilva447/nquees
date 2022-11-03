library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_nqueens is
generic(M : integer;  -- size of the board MxM
        N : integer;  -- N bits required to count upto size of the board;
        P : integer   -- N bits required for the counter;
    );  
port(
    clk, nRst: in std_logic; 
    done: out std_logic;
    counter: out std_logic_vector(P downto 0)
    );                         
end entity;

architecture rtl of top_nqueens is 
 
    constant K_4: integer := 4; 
    signal a_in_4: std_logic_vector((N*K_4-1) downto 0); 
    signal a_out_4: std_logic_vector((N*(K_4+1)-1) downto 0); 
    signal ack_in_4, next_in_4, ack_out_4, next_out_4: std_logic; 
    signal output_state_4: std_logic_vector(2 downto 0); 
 
    constant K_3: integer := 3; 
    signal a_in_3: std_logic_vector((N*K_3-1) downto 0); 
    signal a_out_3: std_logic_vector((N*(K_3+1)-1) downto 0); 
    signal ack_in_3, next_in_3, ack_out_3, next_out_3: std_logic; 
    signal output_state_3: std_logic_vector(2 downto 0); 
 
    constant K_2: integer := 2; 
    signal a_in_2: std_logic_vector((N*K_2-1) downto 0); 
    signal a_out_2: std_logic_vector((N*(K_2+1)-1) downto 0); 
    signal ack_in_2, next_in_2, ack_out_2, next_out_2: std_logic; 
    signal output_state_2: std_logic_vector(2 downto 0); 
 
    constant K_1: integer := 1; 
    signal a_in_1: std_logic_vector((N*K_1-1) downto 0); 
    signal a_out_1: std_logic_vector((N*(K_1+1)-1) downto 0); 
    signal ack_in_1, next_in_1, ack_out_1, next_out_1: std_logic; 
    signal output_state_1: std_logic_vector(2 downto 0); 
 
    signal counter_s: unsigned(P downto 0); 
    signal flag_s, done_s: std_logic; 
    constant impar: std_logic_vector(0 downto 0) := std_logic_vector(to_unsigned(M,1)); 
 
begin 
 
    fsm_4: entity work.fsm 
    generic map (K => 4, M => M, N =>N) 
    port map (clk=>clk, nRst=>nRst, a_in=>a_in_4, ack_in=>ack_in_4, next_in=>next_in_4, a_out=>a_out_4, ack_out=>ack_out_4, next_out=>next_out_4, output_state=>output_state_4); 
 
    fsm_3: entity work.fsm 
    generic map (K => 3, M => M, N =>N) 
    port map (clk=>clk, nRst=>nRst, a_in=>a_in_3, ack_in=>ack_in_3, next_in=>next_in_3, a_out=>a_out_3, ack_out=>ack_out_3, next_out=>next_out_3, output_state=>output_state_3); 
 
    fsm_2: entity work.fsm 
    generic map (K => 2, M => M, N =>N) 
    port map (clk=>clk, nRst=>nRst, a_in=>a_in_2, ack_in=>ack_in_2, next_in=>next_in_2, a_out=>a_out_2, ack_out=>ack_out_2, next_out=>next_out_2, output_state=>output_state_2); 
 
    fsm_1: entity work.fsm 
    generic map (K => 1, M => M, N =>N) 
    port map (clk=>clk, nRst=>nRst, a_in=>a_in_1, ack_in=>ack_in_1, next_in=>next_in_1, a_out=>a_out_1, ack_out=>ack_out_1, next_out=>next_out_1, output_state=>output_state_1); 
 
    a_in_4 <= a_out_3; 
    ack_in_4  <= ack_out_3; 
    next_in_3 <= next_out_4;    
 
    a_in_3 <= a_out_2; 
    ack_in_3  <= ack_out_2; 
    next_in_2 <= next_out_3;    
 
    a_in_2 <= a_out_1; 
    ack_in_2  <= ack_out_1; 
    next_in_1 <= next_out_2;    
 
    counter <= std_logic_vector(counter_s); 
    done <= done_s; 
 
    counter_process: process(nRst, ack_out_4) 
    begin 
        if nRst = '1' then 
            counter_s <= (others=>'0'); 
            next_in_4 <= '0'; 
        elsif (ack_out_4'event and ack_out_4 = '0') then 
            if flag_s = '1' and impar(0) = '1' then 
                counter_s <= counter_s + 1; 
            else 
                counter_s <= counter_s + 2; 
            end if; 
            next_in_4 <= '1'; 
        end if; 
    end process; 

    flag_process: process(nRst, clk)
    begin
        if nRst = '1' then
            flag_s <= '0';
        elsif (clk'event and clk = '1') then
            if a_in_1 = std_logic_vector(to_unsigned(M/2, N)) and impar(0) = '0' then
                flag_s <= '1';
            elsif a_in_1 = std_logic_vector(to_unsigned(M/2, N) + 1) and impar(0) = '1' then
                flag_s <= '1';
            else
                flag_s <= '0';
            end if;
        end if;
    end process;

    init_process: process(nRst, clk)
    begin        
        if nRst = '1' then
            done_s <= '0';
            ack_in_1 <= '1';
            a_in_1 <= (others=>'0');
        elsif (clk'event and clk = '1') then
            if flag_s = '0' then
                if ack_in_1 = '1' then 
                    a_in_1 <= std_logic_vector(unsigned(a_in_1) + 1);
                    ack_in_1 <= '0';
                elsif ack_in_1 = '0' then
                    if next_out_1 = '1' then
                        ack_in_1 <= '1';
                    end if;
                end if;
            else
                if next_out_1 = '1' then
                    done_s <= '1';
                end if;
            end if;
        end if;
    end process; 

end architecture;