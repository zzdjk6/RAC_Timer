//
//  RAC2ViewController.swift
//  RAC_Timer
//
//  Created by 陈圣晗 on 16/4/22.
//  Copyright © 2016年 陈圣晗. All rights reserved.
//

import UIKit
import Result
import ReactiveCocoa
import RxSwift
import RxCocoa
import SVProgressHUD

class RAC2RxViewController: SwiftBaseViewController {
    
    private var stopTimerSignal = PublishSubject<()>()
    private var disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    // MARK: - IBAction
    
    override func startButtonPressed() {
        let limit = 9
        self.updateButtons(limit)
        
        let o = Observable<Int>.create { observer -> RxSwift.Disposable in
            // using a subject to dispose RACSignal when Observable dispose
            let endSubject = RACSubject()
            let s = RAC2TimerSignalCreator.createSignal(9).takeUntil(endSubject)
            s.subscribeNext(
                { next in
                    observer.onNext(next as? Int ?? 0)
                },
                error:
                { error in
                    observer.onError(error)
                },
                completed:
                {
                    observer.onCompleted()
            })
            
            return AnonymousDisposable({
                endSubject.sendCompleted()
            })
        }
        
        o.takeUntil(self.rx_deallocating)
            .takeUntil(self.stopTimerSignal)
            .subscribeOn(MainScheduler.instance)
            .subscribe { [weak self] (event) in
                switch event {
                case .Next(let counter):
                    guard let this = self else {return}
                    this.updateButtons(counter)
                case .Completed:
                    guard let this = self else {return}
                    this.updateButtons()
                default:
                    break
                }
            }
            .addDisposableTo(self.disposeBag)
    }
    
    override func stopButtonPressed() {
        self.stopTimerSignal.onNext(());
    }
}
