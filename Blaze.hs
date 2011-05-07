module Blaze where

import CLasH.HardwareTypes hiding (readBlockRAM, writeBlockRAM)

type Word = Signed D4
type RegisterIndex = Index D4

data Instruction = 
    Nop
  | In RegisterIndex
  | Out RegisterIndex
  | Add RegisterIndex RegisterIndex RegisterIndex

data BlazeR = R {
    registers :: MemState D4 Word
  }

type BlazeS = State BlazeR

blazeInit :: BlazeR
blazeInit = R { registers = State (vcopy 0) }

blaze :: BlazeS -> (Instruction, Word) -> (BlazeS, Word)
blaze (State s) (instruction, inWord) = (State s', outWord)
  where
    -- | Returns the value of the RAM at address 'addr'
    readBlockRAM mem addr = a
      where (_, a) = blockRAM mem 0 addr addr False
    -- | Updates the value of the RAM at address 'addr' with 'data_in'
    writeBlockRAM mem data_in addr = mem'
      where (mem', _) = blockRAM mem data_in addr addr True
    regs = registers s
    (s', outWord) = case instruction of
      Nop -> (s, 0)
      In index -> (R { registers = regs' }, 0) 
        where (regs', _) = blockRAM regs inWord 0 index True
      Out index -> (s, outWord) 
        where (_, outWord) = blockRAM regs 0 index 0 False
      Add x y z -> (R { registers = regs' }, 0) 
        where
          (_, a) = blockRAM regs 0 x 0 False
          (_, b) = blockRAM regs 0 y 0 False
          (regs', _) = blockRAM regs (a + b) 0 z True

{-# ANN exec TopEntity #-}
-- exec = proc (instruction, word) -> do
exec = blaze ^^^ blazeInit

program1 :: [(Instruction, Word)]
program1 = [
    (In  0,  1)
  , (In  1,  2)
  , (Add 0 1 2, 0)
  , (Out 2, 0)
  ]

sim p = simulate (blaze ^^^ blazeInit) p

-- vim: set ts=8 sw=2 sts=2 expandtab:
