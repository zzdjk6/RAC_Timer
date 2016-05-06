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
        
        let s = RAC2TimerSignalCreator.createSignal(9)
        let o = s.toObservable().map { $0 as? Int ?? 0 }
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
