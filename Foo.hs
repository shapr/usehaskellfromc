{-# LANGUAGE BangPatterns             #-}
{-# LANGUAGE ForeignFunctionInterface #-}

module Foo (fib_hs) where

import Foreign
import Foreign.C.Types

fib :: Int -> Int
fib = go
  where
    go 0 = 0
    go 1 = 1
    go n = go n + go (n-1)
{-# INLINE fib #-}

fib_hs :: CInt -> CInt
fib_hs = fromIntegral . fib . fromIntegral

foreign export ccall fib_hs :: CInt -> CInt
