#include <HsFFI.h>
#include "Foo_stub.h"
#include <stdio.h>

int main(int argc, char *argv[])
{
    unsigned long i;
    hs_init(&argc, &argv); // start up the Haskell runtime
    i = fib_hs(50);
    printf("Fibonacci: %lu\n", i);

    hs_exit(); // shutdown the Haskell runtime
    return 0;
}
