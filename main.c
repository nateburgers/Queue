//
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

