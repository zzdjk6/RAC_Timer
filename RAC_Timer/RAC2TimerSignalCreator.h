//
//  RAC2TimerSignalCreator.h
//  RAC_Timer
//
//  Created by 陈圣晗 on 16/5/3.
//  Copyright © 2016年 陈圣晗. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface RAC2TimerSignalCreator : NSObject

+ (RACSignal *)createSignal:(NSInteger)limit;

@end
