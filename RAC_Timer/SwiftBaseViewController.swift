//
//  SwiftBaseViewController.swift
//  RAC_Timer
//
//  Created by 陈圣晗 on 16/4/26.
//  Copyright © 2016年 陈圣晗. All rights reserved.
//

import UIKit
import Cartography

class SwiftBaseViewController: UIViewController {
    
    let timerLimit = 9
    
    let startButtonDefaultTitle = "Start"
    let stopButtonDefaultTtile = "Stop"
    
    var startButton: UIButton = UIButton()
    var stopButon: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
        self.updateButtons()
    }
    
    deinit {
        print("\(self.dynamicType.self): deinit")
    }
    
    func startButtonPressed() {
        print("BaseViewController::startButtonPressed")
    }
    
    func stopButtonPressed() {
        print("BaseViewController::stopButtonPressed")
    }
    
    func startButtonInTimerTitle(counter: Int) -> String{
        return "Count Down: \(counter)"
    }
    
    func updateButtons(counter: Int = 0) {
        self.updateStartButton(counter)
        self.updateStopButton()
    }
    
    private func updateStartButton(counter: Int = 0) {
        // in counter
        if counter >= 1 {
            self.startButton.setTitle(self.startButtonInTimerTitle(counter), forState: UIControlState.Normal)
            self.startButton.enabled = false
            return
        }
        
        // default
        self.startButton.setTitle(self.startButtonDefaultTitle, forState: .Normal)
        self.startButton.enabled = true
    }
    
    private func updateStopButton() {
        self.stopButon.setTitle(self.stopButtonDefaultTtile, forState: UIControlState.Normal)
        self.stopButon.enabled = !self.startButton.enabled
    }
    
    private func initUI() {
        self.view.backgroundColor = UIColor.blackColor()
        
        self.startButton.setTitle("Start", forState: .Normal)
        self.startButton.addTarget(self, action: #selector(self.startButtonPressed), forControlEvents: .TouchUpInside)
        
        self.stopButon.setTitle("Stop", forState: .Normal)
        self.stopButon.addTarget(self, action: #selector(self.stopButtonPressed), forControlEvents: .TouchUpInside)
        
        for button in [self.startButton, self.stopButon] {
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            button.setTitleColor(UIColor.grayColor(), forState: .Disabled)
            button.sizeToFit()
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            self.view.addSubview(button)
        }
        
        self.stopButon.enabled = false
        
        constrain(self.startButton, self.view) { view, superView in
            view.center == superView.center
        }
        
        constrain(self.stopButon, self.startButton) { view1, view2 in
            view1.centerX == view2.centerX
            view1.top == view2.bottom + 10
        }
    }
}
