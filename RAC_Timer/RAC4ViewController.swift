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

class RAC4ViewController: UIViewController {

    @IBOutlet weak var verifyCodeButton: UIButton!
    @IBOutlet weak var errorButton: UIButton!
    
    let (stopTimerSignal, stopTimerObserver) = Signal<(), NoError>.pipe()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.verifyCodeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.updateVerifyCodeButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBAction
    
    @IBAction func errorButtonPressed(sender: AnyObject) {
        self.stopTimerObserver.sendNext(())
        
        SVProgressHUD.setMinimumDismissTimeInterval(0)
        SVProgressHUD.showErrorWithStatus(">_< 出错了")
    }
    
    @IBAction func verifyCodeButtonPressed(sender: AnyObject) {
        let limit = 10
        var countDown = limit - 1
        
        self.updateVerifyCodeButton(countDown)
        self.errorButton.enabled = true
        
        timer(1, onScheduler: QueueScheduler.mainQueueScheduler)
            .map({ _ -> Int in
                countDown -= 1
                return countDown
            })
            .take(limit - 1)
            .takeUntil(self.stopTimerSignal)
            .takeUntil(self.willDeallocSignalProducer)
            .observeOn(QueueScheduler.mainQueueScheduler)
            .start { [weak self] event in
                guard let this = self else {return}
                
                switch event {
                case .Next(let countDown):
                    print("Timer: \(countDown)")
                    this.updateVerifyCodeButton(countDown)
                case .Completed:
                    print("Timer: Completed")
                    this.updateVerifyCodeButton()
                    this.errorButton.enabled = false
                default:
                    break
                }
        }
    }
    
    // MARK: - Private
    
    private func updateVerifyCodeButton(countDown: Int? = nil) {
        if let countDown = countDown {
            if countDown >= 1 {
                self.verifyCodeButton.setTitle("\(countDown)秒后重新发送", forState: UIControlState.Normal)
                self.verifyCodeButton.enabled = false
                return
            }
        }
        
        self.verifyCodeButton.setTitle("获取验证码", forState: UIControlState.Normal)
        self.verifyCodeButton.enabled = true
    }


}
