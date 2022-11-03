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
    signal wen4, ren4, aful4, aemp4: std_logic; 
    signal din4, dou4: std_logic_vector((N*K_4-1) downto 0); 
 
    constant K_3: integer := 3; 
    signal a_in_3: std_logic_vector((N*K_3-1) downto 0); 
    signal a_out_3: std_logic_vector((N*(K_3+1)-1) downto 0); 
    signal ack_in_3, next_in_3, ack_out_3, next_out_3: std_logic; 
    signal output_state_3: std_logic_vector(2 downto 0); 
    signal wen3, ren3, aful3, aemp3: std_logic; 
    signal din3, dou3: std_logic_vector((N*K_3-1) downto 0); 
 
    constant K_2: integer := 2; 
    signal a_in_2: std_logic_vector((N*K_2-1) downto 0); 
    signal a_out_2: std_logic_vector((N*(K_2+1)-1) downto 0); 
    signal ack_in_2, next_in_2, ack_out_2, next_out_2: std_logic; 
    signal output_state_2: std_logic_vector(2 downto 0); 
    signal wen2, ren2, aful2, aemp2: std_logic; 
    signal din2, dou2: std_logic_vector((N*K_2-1) downto 0); 
 
    constant K_1: integer := 1; 
    signal a_in_1: std_logic_vector((N*K_1-1) downto 0); 
    signal a_out_1: std_logic_vector((N*(K_1+1)-1) downto 0); 
    signal ack_in_1, next_in_1, ack_out_1, next_out_1: std_logic; 
    signal output_state_1: std_logic_vector(2 downto 0); 
    signal wen1, ren1, aful1, aemp1: std_logic; 
    signal din1, dou1: std_logic_vector((N*K_1-1) downto 0); 
 
    signal last_candi: unsigned(N-1 downto 0);
    signal last_digit: unsigned(N-1 downto 0);
    signal counter_s: unsigned(P downto 0); 
    signal done_s: std_logic;     
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

    fifo_4: entity work.fifo
    generic map(DWIDTH => N*K_4, DEPTH => 8, AFULLOFFSET => 1, AEMPTYOFFSET => 1, ASYNC => False)
    port map(wclk_i=>clk, rclk_i=>clk, wrst_i=>nRst, rrst_i=>nRst, data_i => din4, wen_i => wen4, ren_i => ren4, data_o => dou4, afull_o => aful4, empty_o => aemp4);
    
    fifo_3: entity work.fifo
    generic map(DWIDTH => N*K_3, DEPTH => 8, AFULLOFFSET => 1, AEMPTYOFFSET => 1, ASYNC => False)
    port map(wclk_i=>clk, rclk_i=>clk, wrst_i=>nRst, rrst_i=>nRst, data_i => din3, wen_i => wen3, ren_i => ren3, data_o => dou3, afull_o => aful3, empty_o => aemp3);
    
    fifo_2: entity work.fifo
    generic map(DWIDTH => N*K_2, DEPTH => 8, AFULLOFFSET => 1, AEMPTYOFFSET => 1, ASYNC => False)
    port map(wclk_i=>clk, rclk_i=>clk, wrst_i=>nRst, rrst_i=>nRst, data_i => din2, wen_i => wen2, ren_i => ren2, data_o => dou2, afull_o => aful2, empty_o => aemp2);
    
    fifo_1: entity work.fifo
    generic map(DWIDTH => N*K_1, DEPTH => 8, AFULLOFFSET => 1, AEMPTYOFFSET => 1, ASYNC => False)
    port map(wclk_i=>clk, rclk_i=>clk, wrst_i=>nRst, rrst_i=>nRst, data_i => din1, wen_i => wen1, ren_i => ren1, data_o => dou1, afull_o => aful1, empty_o => aemp1);

    ack_in_4 <= aemp4;
    a_in_4 <= dou4;
    ren4 <= next_out_4;
    wen4 <= not ack_out_3;
    din4 <= a_out_3;
    next_in_3 <= not aful4;

    ack_in_3 <= aemp3;
    a_in_3 <= dou3;
    ren3 <= next_out_3; 
    wen3 <= not ack_out_2;
    din3 <= a_out_2;
    next_in_2 <= not aful3;

    ack_in_2 <= aemp2;
    a_in_2 <= dou2;
    ren2 <= next_out_2;
    wen2 <= not ack_out_1;
    din2 <= a_out_1;
    next_in_1 <= not aful2;

    ack_in_1 <= aemp1;
    a_in_1 <= dou1;
    ren1 <= next_out_1;
    
    counter <= std_logic_vector(counter_s); 
    done <= done_s;     
    last_digit <= unsigned(a_in_4((N*M-1 - N) downto (N*(M-1) - N)));
    last_candi <= (to_unsigned(M/2, N) + 1)  when impar(0) = '1' else
                  (to_unsigned(M/2, N))      when impar(0) = '0';
 
    counter_process: process(nRst, ack_out_4) 
    begin 
        if nRst = '1' then 
            counter_s <= (others=>'0'); 
            next_in_4 <= '0'; 
        else
            next_in_4 <= '1';
            if (ack_out_4'event and ack_out_4 = '0') then 
                if (last_digit = (to_unsigned(M/2, N) + 1) and impar(0) = '1') then
                    counter_s <= counter_s + 1; 
                else
                    counter_s <= counter_s + 2;
                end if;
            end if;
        end if; 
    end process; 
    
    init_process: process(nRst, clk)
    begin        
        if nRst = '1' then
            done_s <= '0';
            wen1 <= '0';
            din1 <= (others=>'0');
        elsif (clk'event and clk = '1') then
            if (aful1 = '0' and unsigned(din1) < last_candi) then
                din1 <= std_logic_vector(unsigned(din1) + 1);
                wen1 <= '1';
            else
                wen1 <= '0';
            end if;    
        end if;
    end process; 

end architecture;
