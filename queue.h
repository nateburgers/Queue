//
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
