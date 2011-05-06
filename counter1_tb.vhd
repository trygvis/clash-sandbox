use work.all;
use work.types.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity counter1_tb is
end counter1_tb;
 
architecture default of counter1_tb is
  signal input : work.types.unsigned_12 := to_unsigned(0, 12);
  signal out_a : boolean;
  signal out_b : unsigned_12;
  signal output : work.types.Z2TZLz2cUZRbooleanunsigned_12;
  signal clock : std_logic := '0';
  signal reset : std_logic := '0';

  component counterTopComponent_0 port (
    param2046910516 : in unsigned_12;
    res2046910521 : out Z2TZLz2cUZRbooleanunsigned_12;
    clock1 : in std_logic;
    resetn : in std_logic);
  end component;
begin
  counter : counterTopComponent_0 port map (
    param2046910516 => input,
    res2046910521 => output,
    clock1 => clock,
    resetn => reset
  );

  out_a <= output.AA;
  out_b <= output.AB;

  process
  begin
    clock <= '0';
    wait for 5 ns;
    clock <= '1';
    wait for 5 ns;
  end process;

  process
    --constant x : unsigned integer := 0;
  begin
    wait for 15 ns;
    input <= to_unsigned(0, 12);
    reset <= '1';

    wait for 20 ns;
    input <= to_unsigned(5, 12);

    wait for 100 ns;
    wait;
  end process;
end;

-- vim: set ts=8 sw=2 sts=2 expandtab:
