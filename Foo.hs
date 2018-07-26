{-# LANGUAGE BangPatterns             #-}
{-# LANGUAGE ForeignFunctionInterface #-}

module Foo where

import Foreign
import Foreign.C.Types

data IntPair = IntPair !Int !Int

fib :: Int -> Int
fib n = go n (IntPair 0 1)
  where
    go !n (IntPair !a !b)
      | n == 0    = a
      | otherwise = go (n-1) (IntPair b (a + b))
{-# INLINE fib #-}

fib_hs :: CInt -> CInt
fib_hs = fromIntegral . fib . fromIntegral

foreign export ccall fib_hs :: CInt -> CInt
