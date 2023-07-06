header = """library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;"""

entity = """
entity adder_counts is
 port(
     clk_i: in std_logic;
     nRst: in std_logic;
     {counters}: in std_logic_vector(63 downto 0);
     {dones}: in std_logic;
     coun_O : out std_logic_vector(63 downto 0);
     done_O : out std_logic
 );
end adder_counts;"""

architecture = """
architecture Behavioral of adder_counts is
    signal {signals}: unsigned(63 downto 0);
    signal s_count: unsigned(63 downto 0);
    signal s_done: std_logic;
begin
"""

assignments = """
    {signal} <= unsigned({count});"""

outputs = """
    coun_O <= std_logic_vector(s_count);
    done_O <= s_done;
"""

process= """
    process (clk_i)
    begin
        if rising_edge(clk_i)  then
            if nRst = '1' then
                s_done <= '0';
                s_count <= (others => '0');
            else
                s_count <= ({added_counts});
                s_done <= {all_dones};
            end if;
        end if;
    end process;
end Behavioral;
"""

def generate_adder(n: int, filename: str ='adder_counts.vhd'):
    with open(filename, "w") as adder:
        counters = ["{}{}".format(a_,b_) for a_,b_ in zip(['count_']*n,range(n))]
        counters_s = ["{}{}".format(a_,b_) for a_,b_ in zip(['cs_']*n,range(n))]
        dones = ["{}{}".format(a_,b_) for a_,b_ in zip(['done_']*n,range(n))]
        adder.write(header)
        adder.write(
            entity.format(
                counters= ','.join(counters),
                dones= ','.join(dones)
            )
        )
        adder.write(
            architecture.format(
                signals= ','.join(counters_s)
            )
        )
        for signal, count in zip(counters_s, counters):
            adder.write(
                assignments.format(
                    signal = signal,
                    count = count
                )
            )
        adder.write(outputs)
        adder.write(process.format(
            added_counts = " + ".join(counters_s),
            all_dones = " and ".join(dones)
            )
        )