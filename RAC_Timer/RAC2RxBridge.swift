//
//  RAC2RxBridge.swift
//  RAC_Timer
//
//  Created by 陈圣晗 on 16/5/5.
//  Copyright © 2016年 陈圣晗. All rights reserved.
//

import UIKit
import ReactiveCocoa
import RxSwift

public extension RACSignal {
    public func toObservable(function: String = #function, file: String = #file, line: Int = #line) -> Observable<AnyObject?> {
        return Observable<AnyObject?>.create { observer -> RxSwift.Disposable in
            let disposable = self.subscribeNext(
                { next in
                    observer.onNext(next)
                },
                error:
                { error in
                    observer.onError(error ?? defaultNSError())
                },
                completed:
                {
                    observer.onCompleted()
            })
            
            return AnonymousDisposable({
                disposable.dispose()
            })
        }

    }
}

public extension Observable {
    public func toRACSignal() -> RACSignal {
        return RACSignal.createSignal({ subscriber -> RACDisposable! in
            let disposable = self.subscribe { (event) in
                switch event {
                case .Next(let next):
                    subscriber.sendNext(next as? AnyObject)
                case .Error(let error):
                    subscriber.sendError(error as NSError ?? defaultNSError())
                case .Completed:
                    subscriber.sendCompleted()
                }
            }
            
            return RACDisposable(block: { 
                disposable.dispose()
            })
        })
    }
}


private func defaultNSError(message: String = "RAC2RxBridge Nil Error", function: String = #function, file: String = #file, line: Int = #line) -> NSError {
    var userInfo: [NSObject : AnyObject] = [:]
    userInfo[NSLocalizedDescriptionKey] = "\(file):\(line)::\(function) \(message)"
    
    return NSError(domain: "RAC2RxBridge", code: 0, userInfo: userInfo)
}