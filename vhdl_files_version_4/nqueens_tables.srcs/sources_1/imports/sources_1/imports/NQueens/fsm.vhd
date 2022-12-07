library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm is
generic(K : integer;  -- position of the block (starting from zero)
        M : integer;  -- size+1 of the board MxM
        N : integer   -- N bits required to count upto size of the board);
    );    
port(
    clk, nRst: in std_logic;   
    a_in: in std_logic_vector((N*K-1) downto 0);        -- vector a del bloque anterior
    ack_in, next_in: in std_logic;
    a_out: out std_logic_vector((N*(K+1)-1) downto 0);  -- vector a del bloque siguiente
    ack_out, next_out: out std_logic;    
    output_state: out std_logic_vector(2 downto 0)      -- salida indicando cada estado
    );                         
end entity;

architecture rtl of fsm is

type state_type is (st0_reset, st1_new_candidate, st2_validation, st3_writefifo, st4_done, st_aux1, st_aux2);
signal state, next_state : state_type;
type array_in is array (K-1 downto 0) of std_logic_vector(N-1 downto 0);
signal asin_array: array_in;
type array_out is array (K downto 0) of std_logic_vector(N-1 downto 0);
signal asout_array: array_out;

signal ctrl_state: std_logic_vector(2 downto 0);
signal output_i : std_logic_vector(2 downto 0);
signal u_i, u_o: std_logic_vector(N-1 downto 0);
signal ce, res_counter, complete_tick, valid, done: std_logic;
signal reset_control, acks_in, nexts_in, acks_out, nexts_out: std_logic;

begin
    dut: entity work.up_counter 
    generic map (M => M, N => N)
    port map (clk => clk, ce => ce, reset=>ack_in, reset2 => res_counter, complete_tick => complete_tick, count => u_o);
    ctl: entity work.ct_logic
    generic map (K => K, N => N)
    port map (clk => clk, reset => reset_control, a => a_in, u => u_i, valid => valid, done => done); 
    
    acks_in <= ack_in;
    ack_out <= acks_out;
    nexts_in <= next_in;
    next_out <= nexts_out;
    
    GENERATE_FOR_in: for i in 0 to K-1 generate
        asin_array(i) <= a_in(((i+1)*N-1) downto i*N);
    end generate; 
    
    GENERATE_FOR_out: for i in 0 to K generate
        a_out(((i+1)*N-1) downto i*N) <= asout_array(i);
    end generate; 
    
    u_i <= u_o;
    output_state <= output_i;    

    SYNC_PROC: process(clk)
    begin
      if (clk'event and clk = '1') then
         if (ack_in = '1' or nRst = '1') then
            state <= st0_reset;
         else
            state <= next_state;
         end if;      
      end if;            
    end process;
    
    OUTPUT_DECODE: process(state)
    begin
          if state = st0_reset then 
             output_i <= "000"; 
             acks_out <= '1'; 
             nexts_out <= '0'; 
             ce <= '0'; 
             reset_control <= '1'; 
             res_counter <= '1'; 
             for ii in 0 to K loop 
                 asout_array(ii) <= (others=>'0'); 
             end loop; 
          elsif state = st1_new_candidate then 
             output_i <= "001"; 
             acks_out <= '1'; 
             nexts_out <= '0'; 
             ce <= '1'; 
             reset_control <= '1'; 
             res_counter <= '0'; 
             for ii in 0 to K loop 
                 asout_array(ii) <= (others=>'0'); 
             end loop; 
          elsif state = st2_validation then 
             output_i <= "010"; 
             acks_out <= '1'; 
             nexts_out <= '0'; 
             ce <= '0'; 
             reset_control <= '0';
             res_counter <= '0'; 
             for ii in 0 to K loop 
                 asout_array(ii) <= (others=>'0'); 
             end loop; 
          elsif state = st_aux1 then 
             output_i <= "101"; 
             acks_out <= '1'; 
             nexts_out <= '0'; 
             ce <= '0'; 
             reset_control <= '1';
             res_counter <= '0'; 
             for ii in 0 to K loop 
                 asout_array(ii) <= (others=>'0'); 
             end loop; 
          elsif state = st3_writefifo then       
             output_i <= "011"; 
             acks_out <= '1'; 
             nexts_out <= '0'; 
             ce <= '0'; 
             reset_control <= '1'; 
             res_counter <= '0'; 
             for ii in 0 to K-1 loop 
                 asout_array(ii+1) <= asin_array(ii); 
             end loop; 
             asout_array(0) <= u_i; 
          elsif state = st_aux2 then       
             output_i <= "110"; 
             acks_out <= '0'; 
             nexts_out <= '0'; 
             ce <= '0'; 
             reset_control <= '1'; 
             res_counter <= '0'; 
             for ii in 0 to K-1 loop 
                 asout_array(ii+1) <= asin_array(ii); 
             end loop; 
             asout_array(0) <= u_i; 
          elsif state = st4_done then 
             output_i <= "100"; 
             acks_out <= '1'; 
             nexts_out <= '1'; 
             ce <= '0'; 
             reset_control <= '1'; 
             res_counter <= '1'; 
             for ii in 0 to K loop 
                 asout_array(ii) <= (others=>'0'); 
             end loop; 
          else 
             output_i <= "000"; 
             acks_out <= '1'; 
             nexts_out <= '0'; 
             ce <= '0'; 
             reset_control <= '1';   
             res_counter <= '1';     
             for ii in 0 to K loop
                 asout_array(ii) <= (others=>'0');
             end loop;            
          end if;       
    end process;    
    
    NEXT_STATE_DECODE: process (state, done, nexts_in, ack_in)
    begin
        
      next_state <= state;
      
      case (state) is
      
         when st0_reset =>        
            next_state <= st1_new_candidate;
            
         when st1_new_candidate =>  
            if (complete_tick = '0') then
                next_state <= st2_validation;
            else
                next_state <= st4_done;
            end if;            
            
         when st2_validation =>     
            if (done = '1') then
                next_state <= st_aux1;
            end if;
         
         when st_aux1 =>
            if (valid = '1') then
                next_state <= st3_writefifo;
            else
                next_state <= st1_new_candidate;
            end if;            
            
         when st3_writefifo =>             
            if (nexts_in = '1') then
                next_state <= st_aux2;
            end if;     
            
        when st_aux2 =>
            if (complete_tick = '0') then
                next_state <= st1_new_candidate;
            else
                next_state <= st4_done;
            end if;                           
                
         when st4_done =>    
            next_state <= st0_reset;
            
         when others =>  
            next_state <= st0_reset;
            
      end case;
    end process;    
end architecture;