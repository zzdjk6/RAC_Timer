//
//  RAC2TimerSignalCreator.m
//  RAC_Timer
//
//  Created by 陈圣晗 on 16/5/3.
//  Copyright © 2016年 陈圣晗. All rights reserved.
//

#import "RAC2TimerSignalCreator.h"

@import ReactiveCocoa;

@implementation RAC2TimerSignalCreator

+ (RACSignal *)createSignal:(NSInteger)limit
{
    RACSignal *sig;
    
    // immedaitely return 0
    if (limit <= 0) {
        sig = [RACSignal return:@0];
        return sig;
    }
    
    // immedaitely return current limit
    RACSignal *s1 = [RACSignal return:@(limit)];
    
    // invoke every time loop
    NSInteger __block counter = limit;
    RACSignal *s2 = [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]]
                      map:^id(id value) {
                          counter -= 1;
                          return @(counter);
                      }]
                     take: limit];
    
    // concat signal, let it fire on both start and timer count
    sig = [[[s1 concat:s2]
            doNext:^(id x) {
                NSLog(@"Timer: %@", @(counter));
            }]
           doCompleted:^{
               NSLog(@"Timer Completed");
           }];
    return sig;
}

@end

