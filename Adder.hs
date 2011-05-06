module Adder where

import CLasH.HardwareTypes

halfAdder a b = (sum, carry)
  where
    sum = hwxor a b
    carry = hwand a b

adder a b cIn = (sumOut, cOut)
  where
    (z, c1) = halfAdder a b
    (sumOut, c2) = halfAdder z cIn
    cOut = hwxor c1 c2

-- vim: set ts=8 sw=2 sts=2 expandtab:
