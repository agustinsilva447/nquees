from math import log2

header = """library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;"""

entity = """
entity demux_presol is
    port(
        clk, nRst: in std_logic;
        {read}: in std_logic;
        data_I : in std_logic_vector(31 downto 0);
        empt_I : in std_logic;
        {data_arrays}: out std_logic_vector(31 downto 0);
        {empties}: out std_logic;
        r_fifo: out std_logic
 );
end demux_presol;"""

data_i = """
    {data_out} <= data_I;"""

architecture = """
architecture Behavioral of demux_presol is
    signal S: unsigned({Size} downto 0);
    signal r_s: std_logic;
begin

    {data_i}
    r_fifo <= r_s;
    r_s <= {reads};
"""

select= """
    with S select
        {empty} <= empt_I when "{state}",
            '1' when others;"""

mux = """
{select_i}
"""

process = """
    process (clk) is
    begin
        if rising_edge(clk) then
            if nRst = '1' then 
                S <= (others => '0');
            elsif (r_s = '1') then
                if (S = "{maximum}") then
                    S <= (others => '0');
                else
                    S <= S + 1;
                end if;
            end if;
        end if;
    end process;
    
end Behavioral;
"""

def generate_demux(n: int, filename: str ='demux_presol.vhd'):
    with open(filename, "w") as demux:
        Size= int(log2(n) + 1)
        formatter= f'0{Size}b'
        data_arrays_s = ["{}{}".format(a_,b_) for a_,b_ in zip(['data_']*n,range(n))]
        reads_s = ["{}{}".format(a_,b_) for a_,b_ in zip(['read_']*n,range(n))]
        empties_s = ["{}{}".format(a_,b_) for a_,b_ in zip(['empty_']*n,range(n))]
        demux.write(header)
        demux.write(
            entity.format(
                read= ','.join(reads_s),
                data_arrays= ','.join(data_arrays_s),
                empties= ','.join(empties_s))
            )
        demux.write(
            architecture.format(
                data_i= '\n'.join([data_i.format(data_out= signal) for signal in data_arrays_s]),
                Size= Size - 1,
                reads= ' or '.join(reads_s))
            )
        demux.write(
            mux.format(
                select_i = '\n'.join([select.format(empty= empty, state=format(i, formatter)) for i, empty in enumerate(empties_s)])
                )
            )
        demux.write(
            process.format(
                    maximum = format(n-1, formatter)
                )
            )