//
//  RAC4TimerSignalCreator.swift
//  RAC_Timer
//
//  Created by 陈圣晗 on 16/5/3.
//  Copyright © 2016年 陈圣晗. All rights reserved.
//

import UIKit
import Result
import ReactiveCocoa

class RAC4TimerSignalCreator: NSObject {
    
    static func createTimer(limit: Int = 0) -> SignalProducer<Int, NoError> {
        // immedaitely return 0
        if limit <= 0 {
            return SignalProducer<Int, NoError>.init(value: 0)
        }
        
        // immedaitely return current limit
        let s1 = SignalProducer<Int, NoError>.init(value: limit)
        
        // invoke every time loop
        var counter = limit
        let s2 = timer(1, onScheduler: QueueScheduler.mainQueueScheduler)
            .map { _ -> Int in
                counter -= 1
                return counter
            }
            .take(counter)
        
        // concat signal, let it fire on both start and timer count
        let s = s1
            .concat(s2)
            .on(event: { event in
                switch event {
                case .Next(_):
                    print("Timer: \(counter)")
                case .Completed:
                    print("Timer: Completed")
                default: break
                }
            })
        
        return s
    }
}
