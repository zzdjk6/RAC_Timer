//
//  NSTimerViewController.swift
//  RAC_Timer
//
//  Created by 陈圣晗 on 16/5/6.
//  Copyright © 2016年 陈圣晗. All rights reserved.
//

import UIKit

class NSTimerViewController: SwiftBaseViewController {
    
    private var timer: NSTimer = NSTimer()
    private var counter: Int = 0
    
    // MARK: - Life Cycle
    
    override func viewWillDisappear(animated: Bool) {
        self.timer.invalidate()
    }
    
    // MARK: - IBAction
    
    override func startButtonPressed() {
        self.counter = self.timerLimit
        self.updateButtons(self.counter)
        
        self.timer.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(timerStep), userInfo: nil, repeats: true)
        print("Timer: \(self.counter)")
    }
    
    override func stopButtonPressed() {
        self.timer.invalidate()
        print("Timer Completed")
        self.updateButtons()
    }
    
    func timerStep() {
        self.counter -= 1
        if self.counter == 0 {
            self.timer.invalidate()
            print("Timer Completed")
        }
        
        print("Timer: \(self.counter)")
        self.updateButtons(self.counter)
    }
}
