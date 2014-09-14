//
//  NSArrayEnumerationOperation.m
//  ControlledOperation
//
//  Created by Dmitry Volkov on 8/1/14.
//  Copyright (c) 2014 Dmitry Volkov. All rights reserved.
//

#import "YAControlledAsyncOperation.h"

#define SEL_to_nsstring(aSelName) NSStringFromSelector(@selector(aSelName))

@interface YAControlledAsyncOperation ()

@property (nonatomic, copy) YAControlledAsyncOperationBodyBlock bodyBlock;
@property (nonatomic, assign, getter = isExecuting) BOOL executing;
@property (nonatomic, assign, getter = isFinished)  BOOL finished;
@property (nonatomic, assign, getter = isCancelled) BOOL cancelled;

@end

@implementation YAControlledAsyncOperation

+ (instancetype) operationWithBodyBlock:(YAControlledAsyncOperationBodyBlock) aBlock
{
    return [[self alloc] initWithBodyBlock:aBlock];
}

- (void) setExecuting:(BOOL) isExecuting
{
    [self willChangeValueForKey:SEL_to_nsstring(isExecuting)];
    
    _executing = isExecuting;
    
    [self didChangeValueForKey:SEL_to_nsstring(isExecuting)];
}

- (void) setFinished:(BOOL) isFinished
{
    [self willChangeValueForKey:SEL_to_nsstring(isFinished)];
    
    _finished = isFinished;
    
    [self didChangeValueForKey:SEL_to_nsstring(isFinished)];
}

- (void) setCancelled:(BOOL) isCancelled
{
    [self willChangeValueForKey:SEL_to_nsstring(isCancelled)];
    
    _cancelled = isCancelled;
    
    [self didChangeValueForKey:SEL_to_nsstring(isCancelled)];
}

- (instancetype) initWithBodyBlock:(YAControlledAsyncOperationBodyBlock) aBlock
{
    self = [super init];
    
    if (self)
    {
        self.bodyBlock = aBlock;
    }
    
    return self;
}

- (void) start
{
    if (self.bodyBlock)
    {
        dispatch_block_t finishBlock = ^
        {
            self.executing = NO;
            self.finished  = YES;
        };
        
        self.executing = YES;
        
        self.bodyBlock(finishBlock);
    }
}

@end

#undef SEL_to_nsstring//(aSelName)
