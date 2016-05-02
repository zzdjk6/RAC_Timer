//
//  RAC4ViewController.swift
//  RAC_Timer
//
//  Created by 陈圣晗 on 16/4/22.
//  Copyright © 2016年 陈圣晗. All rights reserved.
//

import UIKit
import Result
import ReactiveCocoa
import SVProgressHUD

class RAC4ViewController: SwiftBaseViewController {
    
    let (stopTimerSignal, stopTimerObserver) = Signal<(), NoError>.pipe()
    
    // MARK: - Life Cycle
    
    // MARK: - IBAction
    
    override func startButtonPressed() {
        let limit = 9
        self.updateButtons(limit)
        
        RAC4TimerSignalCreator
            .createTimer(limit)
            .takeUntil(self.willDeallocSignalProducer)
            .takeUntil(self.stopTimerSignal)
            .observeOn(QueueScheduler.mainQueueScheduler)
            .start { [weak self] (event: Event<Int, NoError>) in
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
    }
    
    override func stopButtonPressed() {
        self.stopTimerObserver.sendNext(())
    }
}
