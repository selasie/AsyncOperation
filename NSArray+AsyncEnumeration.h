//
//  NSArray+AsyncEnumeration.h
//  ControlledOperation
//
//  Created by Dmitry Volkov on 8/1/14.
//  Copyright (c) 2014 Dmitry Volkov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NSArrayAsyncEnumerationBlock)(id object, NSInteger index, dispatch_block_t next, dispatch_block_t cancel);

@interface NSArray (AsyncEnumeration)

- (void) enumerateObjectsAsynchronouslyUsingBlock:(NSArrayAsyncEnumerationBlock) anEnumerationBlock;
//both anEnumerationBlock and completionBlock will be called on an arbitrary thread. It is caller's resonsibility to dispatch calls from this blocks to right queue.
//if no operationQueue is provided, private queue is used. Cancelling enumeration will not call completion block
- (void) enumerateObjectsAsynchronouslyUsingBlock:(NSArrayAsyncEnumerationBlock) anEnumerationBlock completionBlock:(void(^)()) completionBlock operationQueue:(NSOperationQueue*) operationQueue;

@end
