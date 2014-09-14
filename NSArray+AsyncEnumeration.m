//
//  NSArray+AsyncEnumeration.m
//  ControlledOperation
//
//  Created by Dmitry Volkov on 8/1/14.
//  Copyright (c) 2014 Dmitry Volkov. All rights reserved.
//

#import "NSArray+AsyncEnumeration.h"

#import "YAControlledAsyncOperation.h"

@implementation NSArray (AsyncEnumeration)

- (void) enumerateObjectsAsynchronouslyUsingBlock:(NSArrayAsyncEnumerationBlock) anEnumerationBlock
{
    [self enumerateObjectsAsynchronouslyUsingBlock:anEnumerationBlock completionBlock:nil operationQueue:nil];
}

- (void) enumerateObjectsAsynchronouslyUsingBlock:(NSArrayAsyncEnumerationBlock) anEnumerationBlock completionBlock:(void(^)()) completionBlock operationQueue:(NSOperationQueue *)operationQueue
{
    
    if(self.count==0)
    {
        if(completionBlock)
        {
            completionBlock();
        }
        return;
    }
    
    
    NSOperationQueue* enumerationQueue =  operationQueue ? operationQueue : [NSOperationQueue new];
    
    [enumerationQueue setSuspended:YES];
    
    __block YAControlledAsyncOperation* operation = nil;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         YAControlledAsyncOperation* op = [YAControlledAsyncOperation operationWithBodyBlock:^(dispatch_block_t setFinished)
                                            {
                                                dispatch_block_t nextBlock = ^
                                                {
                                                    setFinished();
                                                };
                                                
                                                dispatch_block_t cancelBlock = ^
                                                {
                                                    [enumerationQueue cancelAllOperations];
                                                };
                                                
                                                if(anEnumerationBlock)
                                                {
                                                    anEnumerationBlock(obj, idx, nextBlock, cancelBlock);
                                                }
                                            }];
         
         if (operation)
         {
             [op addDependency:operation];
         }
         
         [enumerationQueue addOperation:op];
         
         operation = op;
         
         if(idx==self.count - 1 && completionBlock!=nil)
         {
             
             NSBlockOperation* completionOp = [NSBlockOperation blockOperationWithBlock:^{
                 
                 completionBlock();
                 
             }];
             [completionOp addDependency:operation];
             [enumerationQueue addOperation:completionOp];
         }
             
         
     }];
    
    [enumerationQueue setSuspended:NO];
}

@end
