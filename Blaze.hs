module Blaze where

import CLasH.HardwareTypes

type Word = Signed D4
type RegisterIndex = Index D4

data Instruction = 
    Nop
  | In RegisterIndex
  | Out RegisterIndex
  | Add RegisterIndex RegisterIndex RegisterIndex
  | Sub RegisterIndex RegisterIndex RegisterIndex

data BlazeR = R {
    registers :: Vector D4 Word
  }

type BlazeS = State BlazeR

blazeInit :: BlazeR
blazeInit = R { registers = vcopy 0 }

blaze :: BlazeS -> (Instruction, Word) -> (BlazeS, Word)
blaze (State s) (instruction, inWord) = (State s', outWord)
  where
    regs = registers s
    (s', outWord) = case instruction of
      Nop -> (s, 0)
      In index -> (R { registers = regs' }, 0) 
        where regs' = vreplace regs index inWord
      Out index -> (s, outWord) 
        where outWord = regs!index
      Add x y z -> (R { registers = regs' }, 0) 
        where
          a = regs!x
          b = regs!y
          regs' = vreplace regs z (a + b)
      Sub x y z -> (R { registers = regs' }, 0) 
        where
          a = regs!x
          b = regs!y
          regs' = vreplace regs z (a - b)

{-# ANN blazeTop TopEntity #-}
blazeTop = blaze ^^^ blazeInit

{-# ANN program1 TestInput #-}
program1 :: [(Instruction, Word)]
program1 = [
    (In  0,  1)
  , (In  1,  2)
  , (Add 0 1 2, 0)
  , (Out 2, 0)
  ]

sim p = simulate blazeTop p

-- vim: set ts=8 sw=2 sts=2 expandtab:
