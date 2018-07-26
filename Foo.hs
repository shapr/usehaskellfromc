{-# LANGUAGE BangPatterns             #-}
{-# LANGUAGE ForeignFunctionInterface #-}

module Foo (fib_hs) where

import Foreign.C.Types

-- original tail call friendly version
fib :: Int -> Int
fib n = go n (0,1)
  where
    go !n (!a, !b) | n == 0    = a
                   | otherwise = go (n-1) (b, a+b)

-- overflows the stack, because it's not TCO friendly?
fib2 :: Int -> Int
fib2 = go
  where
    go 0 = 0
    go 1 = 1
    go !n = go n + go (n-1)
{-# INLINE fib #-}


-- also tail call optimization friendly
data IntPair = IntPair !Int !Int

fib3 :: Int -> Int
fib3 n = go n (IntPair 0 1)
  where
    go !n (IntPair !a !b)
      | n == 0    = a
      | otherwise = go (n-1) (IntPair b (a + b))
{-# INLINE fib3 #-}

fib_hs :: CInt -> CInt
fib_hs = fromIntegral . fib3 . fromIntegral

foreign export ccall fib_hs :: CInt -> CInt
