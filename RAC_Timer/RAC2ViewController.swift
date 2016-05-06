//
//  RAC2ViewController.swift
//  RAC_Timer
//
//  Created by 陈圣晗 on 16/4/22.
//  Copyright © 2016年 陈圣晗. All rights reserved.
//

import UIKit
import ReactiveCocoa

class RAC2ViewController: SwiftBaseViewController {
    
    let stopTimerSignal = RACSubject()
    
    // MARK: - Life Cycle
    
    // MARK: - IBAction
    
    override func startButtonPressed() {
        let limit = 9
        self.updateButtons(limit)
        
        RAC2TimerSignalCreator
            .createSignal(limit)
            .takeUntil(self.rac_willDeallocSignal())
            .takeUntil(self.stopTimerSignal)
            .subscribeOn(RACScheduler.mainThreadScheduler())
            .subscribeNext({ [weak self] next in
                guard let this = self else {return}
                this.updateButtons(next as? Int ?? 0)
                }, completed: { [weak self] in
                    guard let this = self else {return}
                    this.updateButtons()
                })
    }
    
    override func stopButtonPressed() {
        self.stopTimerSignal.sendNext(nil)
    }
    
}
