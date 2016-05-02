//
//  RxViewController.swift
//  RAC_Timer
//
//  Created by 陈圣晗 on 16/4/23.
//  Copyright © 2016年 陈圣晗. All rights reserved.
//

import RxSwift
import RxCocoa

class RxViewController: SwiftBaseViewController {
    
    private var stopTimerSignal = PublishSubject<()>()
    private var disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    // MARK: - IBAction
    
    override func startButtonPressed() {
        let limit = 9
        self.updateButtons(limit)
        
        RxTimerObservableCreator
            .createTimer(limit)
            .takeUntil(self.rx_deallocating)
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
        self.stopTimerSignal.onNext(())
    }
}
