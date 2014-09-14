//
//  NSArrayEnumerationOperation.h
//  ControlledOperation
//
//  Created by Dmitry Volkov on 8/1/14.
//  Copyright (c) 2014 Dmitry Volkov. All rights reserved.
//

#import <Foundation/Foundation.h>

//The state of operation is controlled by 'finished' block passed as an argument to the operation's body block. It is fully programmer's resonsibility to call it at appropriate time to signal that operation has finished. Body block might be called on arbitrary thread.
typedef void(^YAControlledAsyncOperationBodyBlock)(dispatch_block_t setFinished);

@interface YAControlledAsyncOperation : NSOperation

+ (instancetype) operationWithBodyBlock:(YAControlledAsyncOperationBodyBlock) aBlock;
- (instancetype) initWithBodyBlock:(YAControlledAsyncOperationBodyBlock) aBlock;

@end
