//
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
