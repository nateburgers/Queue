#High Speed Integer Queue

##Dependencies
* GNU Make
* Any recent version of GCC

##Design Decisions
Despite being a functional programmer (I <3 _ML_), the challenge statement of maximizing
runtime lead to the decision to use _C_ to implement the Queue. The Queue is designed to be
as simple as possible, for clarity and to reduce instruction overhead.

The decision to use a flat integer memory buffer instead of a linked list is three fold.
*   Both structures offer O(1) enqueue and dequeue, but a raw
    buffer is simpler and requires less pointer indirection to access the data.
*   A linked list structure requires an extra 32 or 64 bit pointer to
    locate the subsequent elements in the queue, which for an integer queue would effectively
    _Double_ the memory usage of the structure.
*   Raw speed: you simply cannot get better cache coherence than by using a
    rectangular array of raw memory.

##Performance
Enqueue and Dequeue accomplishes O(1) performance with a raw buffer by incrementing the
`top element` and `bottom element` for both enqueue and dequeue, respectively. When either
pointer reaches the end of the memory buffer, they rotate around to the front of the buffer
again. A separate `size` variable keeps track of how many elements are in the buffer
to prevent overflow or underflow; in essence, to prevent the `top element` and
`bottom element` pointers from stepping on each other's toes.

##Error Handling
A separate `QueueError` reference (initialized to `QueueErrorNone`) is passed to each operation.
Overflow and Underflow errors set the QueueError to their respective values and refuse to update
the Queue, leaving it in the state it was in before the operation was attempted.
In the case of a Dequeue with an Underflow, the integer -1 is returned.

##Running the test suite
to compile the sources and run the test suite just issue `make run` from the source
directory. `GCC` is required to compile the queue sources.
*NOTE*: The test suite requires 2GB of memory for the stress test. Please
ensure your machine has at least 3GB of available memory or this test will
cause your machine to start swapping, ruining the performance test and possibly
your hard drive.

##Cleaning the source tree
This is a simple project and object files + binaries are spit right into the source
tree. To clean this out simply issue a `make clean`.