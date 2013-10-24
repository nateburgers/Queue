//
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
}