{-# LANGUAGE BangPatterns             #-}
{-# LANGUAGE ForeignFunctionInterface #-}
module Foo where

import Foreign
import Foreign.C.Types

fib n = go n (0,1)
  where
    go !n (!a, !b) | n == 0    = a
                   | otherwise = go (n-1) (b, a+b)

fib_hs :: CInt -> CInt
fib_hs = fromIntegral . fib . fromIntegral
foreign export ccall fib_hs :: CInt -> CInt
