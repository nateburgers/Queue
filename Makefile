Queue/._Queue.1                                                                                     000644  000765  000024  00000000253 12230531031 013605  0                                                                                                    ustar 00nate                            staff                           000000  000000                                                                                                                                                                             Mac OS X            	   2   y      �                                      ATTR       �   �                     �     com.apple.TextEncoding   utf-8;134217984                                                                                                                                                                                                                                                                                                                                                     Queue/Queue.1                                                                                       000644  000765  000024  00000006055 12230531031 013376  0                                                                                                    ustar 00nate                            staff                           000000  000000                                                                                                                                                                         .\"Modified from man(1) of FreeBSD, the NetBSD mdoc.template, and mdoc.samples.
.\"See Also:
.\"man mdoc.samples for a complete listing of options
.\"man mdoc for the short list of editing options
.\"/usr/share/misc/mdoc.template
.Dd 10/19/13               \" DATE 
.Dt Queue 1      \" Program name and manual section number 
.Os Darwin
.Sh NAME                 \" Section Header - required - don't modify 
.Nm Queue,
.\" The following lines are read in generating the apropos(man -k) database. Use only key
.\" words here as the database is built based on the words here and in the .ND line. 
.Nm Other_name_for_same_program(),
.Nm Yet another name for the same program.
.\" Use .Nm macro to designate other names for the documented program.
.Nd This line parsed for whatis database.
.Sh SYNOPSIS             \" Section Header - required - don't modify
.Nm
.Op Fl abcd              \" [-abcd]
.Op Fl a Ar path         \" [-a path] 
.Op Ar file              \" [file]
.Op Ar                   \" [file ...]
.Ar arg0                 \" Underlined argument - use .Ar anywhere to underline
arg2 ...                 \" Arguments
.Sh DESCRIPTION          \" Section Header - required - don't modify
Use the .Nm macro to refer to your program throughout the man page like such:
.Nm
Underlining is accomplished with the .Ar macro like this:
.Ar underlined text .
.Pp                      \" Inserts a space
A list of items with descriptions:
.Bl -tag -width -indent  \" Begins a tagged list 
.It item a               \" Each item preceded by .It macro
Description of item a
.It item b
Description of item b
.El                      \" Ends the list
.Pp
A list of flags and their descriptions:
.Bl -tag -width -indent  \" Differs from above in tag removed 
.It Fl a                 \"-a flag as a list item
Description of -a flag
.It Fl b
Description of -b flag
.El                      \" Ends the list
.Pp
.\" .Sh ENVIRONMENT      \" May not be needed
.\" .Bl -tag -width "ENV_VAR_1" -indent \" ENV_VAR_1 is width of the string ENV_VAR_1
.\" .It Ev ENV_VAR_1
.\" Description of ENV_VAR_1
.\" .It Ev ENV_VAR_2
.\" Description of ENV_VAR_2
.\" .El                      
.Sh FILES                \" File used or created by the topic of the man page
.Bl -tag -width "/Users/joeuser/Library/really_long_file_name" -compact
.It Pa /usr/share/file_name
FILE_1 description
.It Pa /Users/joeuser/Library/really_long_file_name
FILE_2 description
.El                      \" Ends the list
.\" .Sh DIAGNOSTICS       \" May not be needed
.\" .Bl -diag
.\" .It Diagnostic Tag
.\" Diagnostic informtion here.
.\" .It Diagnostic Tag
.\" Diagnostic informtion here.
.\" .El
.Sh SEE ALSO 
.\" List links in ascending order by section, alphabetically within a section.
.\" Please do not reference files that do not exist without filing a bug report
.Xr a 1 , 
.Xr b 1 ,
.Xr c 1 ,
.Xr a 2 ,
.Xr b 2 ,
.Xr a 3 ,
.Xr b 3 
.\" .Sh BUGS              \" Document known, unremedied bugs 
.\" .Sh HISTORY           \" Document history if command behaves in a unique manner                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   Queue/._Readme.md                                                                                   000644  000765  000024  00000000253 12232240645 014170  0                                                                                                    ustar 00nate                            staff                           000000  000000                                                                                                                                                                             Mac OS X            	   2   y      �                                      ATTR       �   �                     �     com.apple.TextEncoding   utf-8;134217984                                                                                                                                                                                                                                                                                                                                                     Queue/Readme.md                                                                                     000644  000765  000024  00000004476 12232240645 013766  0                                                                                                    ustar 00nate                            staff                           000000  000000                                                                                                                                                                         #High Speed Integer Queue

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
tree. To clean this out simply issue a `make clean`.                                                                                                                                                                                                  Queue/._main.c                                                                                      000644  000765  000024  00000000253 12232115312 013531  0                                                                                                    ustar 00nate                            staff                           000000  000000                                                                                                                                                                             Mac OS X            	   2   y      �                                      ATTR       �   �                     �     com.apple.TextEncoding   utf-8;134217984                                                                                                                                                                                                                                                                                                                                                     Queue/main.c                                                                                        000644  000765  000024  00000000666 12232115312 013324  0                                                                                                    ustar 00nate                            staff                           000000  000000                                                                                                                                                                         //
//  main.c
//  Queue
//
//  Created by Nathan Burgers on 10/19/13.
//  Copyright (c) 2013 Nathan Burgers. All rights reserved.
//

#include "queue.h"
#include "queue_test.h"
#include <stdio.h>
#include <time.h>

int main(int argc, const char * argv[])
{
    time_t start,end;

    time(&start);
    run_tests();
    time(&end);
    
    double elapsed = difftime(end, start);
    printf("Elapsed Time (seconds): %.21f\n", elapsed);
}

                                                                          Queue/._queue.c                                                                                     000644  000765  000024  00000000253 12232113170 013731  0                                                                                                    ustar 00nate                            staff                           000000  000000                                                                                                                                                                             Mac OS X            	   2   y      �                                      ATTR       �   �                     �     com.apple.TextEncoding   utf-8;134217984                                                                                                                                                                                                                                                                                                                                                     Queue/queue.c                                                                                       000644  000765  000024  00000003742 12232113170 013522  0                                                                                                    ustar 00nate                            staff                           000000  000000                                                                                                                                                                         //
//  queue.c
//  Queue
//
//  Created by Nathan Burgers on 10/19/13.
//  Copyright (c) 2013 Nathan Burgers. All rights reserved.
//

// we include the standard library header
// in order to use malloc to dynamically
// create the queue on the heap.
#include <stdlib.h>
#include <string.h>
#include "queue.h"

// Queue Errors
QueueError new_queue_error()
{
    QueueError error = malloc(sizeof(int));
    *error = QueueErrorNone;
    return error;
}

inline void queue_error_clear(QueueError error)
{
    *error = QueueErrorNone;
}

void queue_error_free(QueueError error)
{
    free(error);
}

// Queue Struct
struct _Queue {
    int* data_store;
    unsigned long int top_offset;
    unsigned long int bot_offset;
    unsigned long int capacity;
    unsigned long int size;
};

// Implementations
// Constructor
Queue new_queue(unsigned long int capacity)
{
    Queue queue = malloc(sizeof(queue));
    int *data_store = malloc(sizeof(int) * capacity);
    queue->data_store = data_store;
    queue->top_offset = 0;
    queue->bot_offset = 0;
    queue->capacity = capacity;
    queue->size = 0;
    return queue;
}

// Methods
inline void queue_enqueue(Queue queue, int item, QueueError error)
{
    if (queue->size >= queue->capacity) {
        *error = QueueErrorOverflow;
        return;
    }
    
    queue->data_store[queue->top_offset] = item;
    
    queue->top_offset ++;
    queue->size ++;
    if (queue->top_offset >= queue->capacity) {
        queue->top_offset = queue->capacity - queue->top_offset;
    }
}

inline int queue_dequeue(Queue queue, QueueError error)
{
    if (queue->size < 1) {
        *error = QueueErrorUnderflow;
        return -1;
    }
    
    int result = queue->data_store[queue->bot_offset];
    
    queue->bot_offset ++;
    queue->size --;
    if (queue->bot_offset >= queue->capacity) {
        queue->bot_offset = queue->capacity - queue->bot_offset;
    }
    
    return result;
}

inline void queue_free(Queue queue)
{
    free(queue->data_store);
    free(queue);
}                              Queue/._queue.h                                                                                     000644  000765  000024  00000000253 12232240321 013735  0                                                                                                    ustar 00nate                            staff                           000000  000000                                                                                                                                                                             Mac OS X            	   2   y      �                                      ATTR       �   �                     �     com.apple.TextEncoding   utf-8;134217984                                                                                                                                                                                                                                                                                                                                                     Queue/queue.h                                                                                       000644  000765  000024  00000001304 12232240321 013516  0                                                                                                    ustar 00nate                            staff                           000000  000000                                                                                                                                                                         //
//  queue.h
//  Queue
//
//  Created by Nathan Burgers on 10/19/13.
//  Copyright (c) 2013 Nathan Burgers. All rights reserved.
//

#ifndef Queue_queue_h
#define Queue_queue_h

// Queue Errors
typedef enum _QueueError {
    QueueErrorNone = 0,
    QueueErrorOverflow,
    QueueErrorUnderflow,
} *QueueError;
QueueError new_queue_error();
void queue_error_clear(QueueError error);
void queue_error_free(QueueError error);

// queue structure
typedef struct _Queue *Queue;
// constructor
Queue new_queue(unsigned long int capacity);
// methods
int queue_dequeue(Queue queue, QueueError error);
void queue_enqueue(Queue queue, int item, QueueError error);
// destructor
void queue_free(Queue queue);

#endif
                                                                                                                                                                                                                                                                                                                            Queue/._queue_test.c                                                                                000644  000765  000024  00000000253 12232235742 015002  0                                                                                                    ustar 00nate                            staff                           000000  000000                                                                                                                                                                             Mac OS X            	   2   y      �                                      ATTR       �   �                     �     com.apple.TextEncoding   utf-8;134217984                                                                                                                                                                                                                                                                                                                                                     Queue/queue_test.c                                                                                  000644  000765  000024  00000007461 12232235742 014575  0                                                                                                    ustar 00nate                            staff                           000000  000000                                                                                                                                                                         //
//  queue_test.c
//  Queue
//
//  Created by Nathan Burgers on 10/22/13.
//  Copyright (c) 2013 Nathan Burgers. All rights reserved.
//

#include "queue.h"
#include "queue_test.h"
#include <time.h>
#include <stdio.h>

#define ASSERT(X) ((X) ? printf("%s succeeded in %s\n\n\n", #X, __func__) : printf("%s failed in %s\n", #X, __func__))

typedef enum {
    Enqueue,
    Dequeue,
} QueueOp;

typedef struct {
    QueueOp op;
    unsigned int count;
} QueueOpt;

typedef enum {
    True = 1,
    False = 0,
} Bool;

typedef void (*test)();

void test_queue(Queue q, QueueError error, QueueOpt *opts, unsigned int count, Bool log)
{
    for (int i=0; i<count; i++) {
        QueueOpt opt = opts[i];
        for (int j=0; j<opt.count; j++) {
            switch (opt.op) {
                case Enqueue:
                    queue_enqueue(q, j*10+10, error);
                    if (log) {
                        printf("EnQueueing %i    ", j*10+10);
                        if (*error) {
                            printf("Error Number: %i", *error);
                        }
                    }
                    break;
                case Dequeue:
                    if (log) {
                        printf("DeQueueing %i    ", queue_dequeue(q, error));
                        if (*error) {
                            printf("Error Number: %i", *error);
                        }
                    } else {
                        queue_dequeue(q, error);
                    }
                    break;
            }
            if(log) printf("\n");
        }
        if(log) printf("\n");
    }
}

// tests
void test_overflow()
{
    Queue q = new_queue(20);
    QueueError e = new_queue_error();
    QueueOpt opts[] = {
        { Enqueue, 21 },
    };
    test_queue(q, e, opts, 1, True);
    ASSERT(*e == QueueErrorOverflow);
    queue_free(q);
    queue_error_free(e);
}

void test_enqueue()
{
    Queue q = new_queue(10);
    QueueError e = new_queue_error();
    QueueOpt opts[] = {
        { Enqueue, 10 },
    };
    test_queue(q, e, opts, 1, True);
    ASSERT(*e == QueueErrorNone);
    queue_free(q);
    queue_error_free(e);
}

void test_dequeue()
{
    Queue q = new_queue(20);
    QueueError e = new_queue_error();
    QueueOpt opts[] = {
        { Enqueue, 10 },
        { Dequeue, 10 },
    };
    test_queue(q, e, opts, 2, True);
    ASSERT(*e == QueueErrorNone);
    queue_free(q);
    queue_error_free(e);
}

void test_underflow()
{
    Queue q = new_queue(20);
    QueueError e = new_queue_error();
    QueueOpt opts[] = {
        { Enqueue, 20 },
        { Dequeue, 21 },
    };
    test_queue(q, e, opts, 2, True);
    ASSERT(*e == QueueErrorUnderflow);
    queue_free(q);
    queue_error_free(e);
}

void test_rotation()
{
    Queue q = new_queue(20);
    QueueError e = new_queue_error();
    QueueOpt opts[] = {
        { Enqueue, 20 },
        { Dequeue, 15 },
        { Enqueue, 10 },
        { Dequeue, 15 }, // size = 0
    };
    test_queue(q, e, opts, 4, True);
    ASSERT(*e == QueueErrorNone);
    queue_free(q);
    queue_error_free(e);
}

void test_stress()
{
    time_t start, end;
    unsigned int queue_size = 2*0x0FFFFFFF;
    
    Queue q = new_queue(queue_size);
    QueueError e = new_queue_error();
    QueueOpt opts[] = {
        { Enqueue, queue_size },
        { Dequeue, queue_size },
    };
    
    time(&start);
    test_queue(q, e, opts, 2, False);
    time(&end);

    double time_diff = difftime(end, start);
    printf("500 Million int queue+dequeue stress test completed in %.21f seconds\n\n\n", time_diff);
    
    queue_free(q);
    queue_error_free(e);
}

// end tests

size_t test_count = 6;
test tests[] = {
    test_overflow,
    test_enqueue,
    test_dequeue,
    test_underflow,
    test_rotation,
    test_stress,
};

void run_tests() {
    for (size_t i=0; i<test_count; i++) {
        tests[i]();
    }
}
                                                                                                                                                                                                               Queue/._queue_test.h                                                                                000644  000765  000024  00000000253 12231613476 015012  0                                                                                                    ustar 00nate                            staff                           000000  000000                                                                                                                                                                             Mac OS X            	   2   y      �                                      ATTR       �   �                     �     com.apple.TextEncoding   utf-8;134217984                                                                                                                                                                                                                                                                                                                                                     Queue/queue_test.h                                                                                  000644  000765  000024  00000000335 12231613476 014576  0                                                                                                    ustar 00nate                            staff                           000000  000000                                                                                                                                                                         //
//  queue_test.h
//  Queue
//
//  Created by Nathan Burgers on 10/22/13.
//  Copyright (c) 2013 Nathan Burgers. All rights reserved.
//

#ifndef Queue_queue_test_h
#define Queue_queue_test_h

void run_tests();

#endif
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   