{-# LANGUAGE TypeOperators, TemplateHaskell, FlexibleContexts, TypeFamilies, 
             ScopedTypeVariables, RecordWildCards #-}
module Counter1 where

import CLasH.HardwareTypes

type CounterS = State CounterR
data CounterR = CounterR { count :: Unsigned D12 }

type CounterIn = CounterInR
data CounterInR = CounterInR { target :: Unsigned D12 }

type CounterOut = ( Bool              -- match
    , Unsigned D12
    )

counter = comp counterT counterInit

counterInit :: CounterR
counterInit = CounterR 0

counterT :: CounterS -> CounterIn -> (CounterS, CounterOut)
counterT (State (CounterR{..})) (CounterInR{..}) = (State s', outp)
  where
    outp  = (match, count')

    s' = CounterR { count = count' }
    count' = if match then 0 else count + 1

    match = count == target

counter1 :: CounterIn -> CounterS -> (CounterS, Bool, Unsigned D12)

counter1 (count) s@(State q) = (s', match, counterOut)
  where
    (s', (match, counterOut)) = counterT s (count)

{-# ANN counterTop TopEntity #-}
counterTop :: Comp CounterIn CounterOut
counterTop = comp counterT counterInit (ClockUp 1)

simulateCounter = simulateM counterTop $ do
  setInput (CounterInR 3)
  run 1
  showOutput
  run 1
  showOutput
  run 1
  showOutput
  run 1
  showOutput
  run 1
  showOutput
  run 1
  showOutput
  run 1
  showOutput

-- vim: set ts=8 sw=2 sts=2 expandtab:
