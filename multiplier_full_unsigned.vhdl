-- VHDL arbitrary bits unsigned full multiplier. Coded by Wojciech Lawren.
library ieee;
use ieee.numeric_bit.all;
-- global constants
package Constants is
  constant BITS: Positive := 8;                       -- selected bits
  subtype VEC_F is unsigned (BITS - 1 downto 0);      -- factor unsigned vector
  subtype VEC_P is unsigned (2 * BITS - 1 downto 0);  -- product unsigned vector
end Constants;

library ieee;
use ieee.numeric_bit.all;
library work;
use work.constants.all;
-- entity multiplier_full_unsigned
entity multiplier_full_unsigned is
  port (
    a, b: in VEC_F;
    sum: out VEC_P
  );
end entity multiplier_full_unsigned;
-- architecture multiplier_full_unsigned
architecture behavior of multiplier_full_unsigned
is
begin
  sum <= a * b;
end architecture behavior;

library ieee;
use ieee.numeric_bit.all;
library work;
use work.constants.all;
-- entity testbench
entity testbench is
  generic (
    T: Time := 10 ns -- time for addition
  );
  constant P: Positive := 2**BITS - 1; -- loops range
end entity testbench;
-- architecture testbench
architecture behavior of testbench
is
  component multiplier_full_unsigned is
    port (
      a, b: in VEC_F;
      sum: out VEC_P
    );
  end component;
  signal a, b: VEC_F := (others => '0');
  signal sum, c: VEC_P := (others => '0');
begin
  uut: multiplier_full_unsigned
    port map (a => a, b => b, sum => sum);
  tb: process
    variable cn: Natural := 0; -- loops counter
  begin
    for k in 0 to P loop
      a <= to_unsigned (k, BITS);
      for i in 0 to P loop
        b <= to_unsigned (i, BITS);
        cn := cn + 1;
        wait for T;
        -- multiplier_full_unsigned arithmetic assertion
        assert (sum = (k * i)) report "incorect product" severity error;
      end loop;
    end loop;
    report Natural'image (cn) & " loops done" severity note; -- loops counter info
    wait;
  end process tb;
end architecture behavior;

-- ghdl -a multiplier_full_unsigned.vhdl
-- ghdl --gen-makefile testbench > Makefile
