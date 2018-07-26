# usehaskellfromc
write Haskell code, call it from C code
Goal:
- [X] show how to link to C program
- [ ] compile C program with gcc instead of Haskell compiler
- [ ] show how to produce Python wheel package that includes Haskell shared object
- [ ] show how to wrap Haskell shared object via cgo

This is Linux only!


I couldn't find a project that demonstrated how to use cabal to wrap
Haskell code into as shared object I could link into a C program, so I
created this.

# compile
After running `cabal new-build`, three files required for the next step are produced in the `dist-newstyle` subdirectory.

- test.o
- Foo_stub.h
- libFoo.so.0.0.1

This repo uses GHC to compile the C source to a .o file, but the next version will show you how to use gcc alone.

# link
Once you've copied `test.o`, `Foo_stub.h`, and `libFoo.so.0.0.1` files into some handy directory, you will need to tell gcc to link to the `libHSrts-ghc$VERSION` shared object, and `libFoo.so.0.0.1`

For me, that's `libHSrts-ghc8.4.1.so` so the command below includes `-lHSrts-ghc8.4.1`.

There's one complication, gcc looks for `libFoo.so` not `libFoo.so.0.0.1` so I created a symlink via `ln -s libFoo.so.0.0.1 libFoo.so`

The command below then uses `-L` to tell gcc to look for required shared objects in both `/opt/ghc/lib/ghc-8.4.1/rts` and the current directory.

`gcc -o test test.o -L. -L /opt/ghc/lib/ghc-8.4.1/rts -lHSrts-ghc8.4.1 -lffi -lFoo  -Wl,-rpath,'$ORIGIN'`


# run
You should now have a `test` binary, but it probably won't immediately run.

If you run the `ldd` command on your binary, you will see that when the binary starts, it will search for several shared objects, including `libFoo.so.0` and `libHSrts-ghc8.4.1.so`. In a default system, `ldd test` will show those two .so files as not found.

You will also notice that the dynamic loader wants to see a file called `libFoo.so.0`, I created another symbolic link in the same directory: `ln -s libFoo.so.0.0.1 libFoo.so.0`

You can temporarily add new search locations by modifying the `LD_LIBRARY_PATH` environment variable like so:

`LD_LIBRARY_PATH=.:/opt/ghc/lib/ghc-8.4.1/rts ./test`

And it works!


# citations
I put together this demo from these links:

- https://qnikst.github.io/posts/2018-05-02-cabal-foreign-library.html
- https://www.vex.net/~trebla/haskell/so.xhtml#cabal
- https://cabal.readthedocs.io/en/latest/developing-packages.html#foreign-libraries
- https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/ffi-chap.html
