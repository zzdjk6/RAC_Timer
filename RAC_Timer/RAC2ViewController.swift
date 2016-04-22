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
import SVProgressHUD

class RAC2ViewController: UIViewController {

    @IBOutlet weak var verifyCodeButton: UIButton!
    @IBOutlet weak var errorButton: UIButton!
    
    let stopTimerSignal = RACSubject()
    
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
        self.stopTimerSignal.sendNext(nil)
        
        SVProgressHUD.setMinimumDismissTimeInterval(0)
        SVProgressHUD.showErrorWithStatus(">_< 出错了")
    }
    
    @IBAction func verifyCodeButtonPressed(sender: AnyObject) {
        let limit = 10
        var countDown = limit - 1
        
        self.updateVerifyCodeButton(countDown)
        self.errorButton.enabled = true
        
        RACSignal
            .interval(1, onScheduler: RACScheduler.mainThreadScheduler())
            .map({ obj -> AnyObject! in
                countDown -= 1
                return countDown
            })
            .take(UInt(limit - 1))
            .takeUntil(self.rac_willDeallocSignal())
            .takeUntil(self.stopTimerSignal)
            .subscribeOn(RACScheduler.mainThreadScheduler())
            .subscribeNext({ [weak self] obj in
                print("Timer: \(countDown)")
                
                guard let this = self else {return}
                this.updateVerifyCodeButton(countDown)
                }, completed: { [weak self] in
                    print("Timer: Completed")
                    
                    guard let this = self else {return}
                    this.updateVerifyCodeButton()
                    this.errorButton.enabled = false
                })
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
