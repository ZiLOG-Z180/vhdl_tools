-- VHDL arbitrary bits unsigned full adder. Coded by Wojciech Lawren.
library ieee;
use ieee.numeric_bit.all;
-- global constants
package Constants is
  constant BITS: Positive := 8;                   -- selected bits
  constant FITS: Positive := BITS + 1;            -- extended sum bits
  subtype VEC_C is unsigned (BITS - 1 downto 0);  -- component unsigned vector
  subtype VEC_S is unsigned (BITS downto 0);      -- sum unsigned vector
end Constants;

library ieee;
use ieee.numeric_bit.all;
library work;
use work.constants.all;
-- entity adder_full_unsigned
entity adder_full_unsigned is
  port (
    a, b: in VEC_C;
    sum: out VEC_S
  );
end entity adder_full_unsigned;
-- architecture adder_full_unsigned
architecture behavior of adder_full_unsigned
is
begin
  sum <= resize (a, FITS) + b;
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
  component adder_full_unsigned is
    port (
      a, b: in VEC_C;
      sum: out VEC_S
    );
  end component;
  signal a, b: VEC_C := (others => '0');
  signal sum: VEC_S := (others => '0');
begin
  uut: adder_full_unsigned
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
        -- adder_full_unsigned arithmetic assertion
        assert (sum = (k + i)) report "incorect sum" severity error;
      end loop;
    end loop;
    report Natural'image (cn) & " loops done" severity note; -- loops counter info
    wait;
  end process tb;
end architecture behavior;

-- ghdl -a adder_full_unsigned.vhdl
-- ghdl --gen-makefile testbench > Makefile
