//
//  RxTimerObservableCreator.swift
//  RAC_Timer
//
//  Created by 陈圣晗 on 16/4/26.
//  Copyright © 2016年 陈圣晗. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactiveCocoa

@objc class RxTimerObservableCreator: NSObject {
    
    /**
     Return Timer In RACSignal
     
     - parameter limit: timer limit
     
     - returns: RACSignal<Int>
     */
    @objc static func rac_createTimer(limit: Int = 0) -> RACSignal {
        return RACSignal.createSignal({ subscriber -> RACDisposable! in
            
            let disposable = self.createTimer(limit)
                .subscribe{ event in
                    switch event {
                    case .Next(let value):
                        subscriber.sendNext(value)
                    case .Completed:
                        subscriber.sendCompleted()
                    case .Error(let error):
                        subscriber.sendError(error as NSError?)
                    }
            }
            
            return RACDisposable(block: {
                disposable.dispose()
            })
        })
    }
    
    /**
     Return Timer In Observable
     
     - parameter limit: timer limit
     
     - returns: Observable<Int>
     */
    static func createTimer(limit: Int = 0) -> Observable<Int> {
        // immedaitely return 0
        if limit <= 0 {
            return Observable<Int>.just(0)
        }
        
        // immedaitely return current limit
        let o1 = Observable<Int>.just(limit)
        
        // invoke every time loop
        var counter = limit
        let o2 = Observable<Int>
            .interval(1, scheduler: MainScheduler.instance)
            .map { _ -> Int in
                counter -= 1
                return counter
            }
            .take(counter)
        
        // concat signal, let it fire on both start and timer count
        let o = o1
            .concat(o2)
            .doOn{ event in
                switch event {
                case .Next(_):
                    print("Timer: \(counter)")
                case .Completed:
                    print("Timer: Completed")
                case .Error(_):
                    print("Timer: Error")
                }
        }
        
        return o
    }
}