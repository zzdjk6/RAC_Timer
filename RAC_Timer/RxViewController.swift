//
//  RxViewController.swift
//  RAC_Timer
//
//  Created by 陈圣晗 on 16/4/23.
//  Copyright © 2016年 陈圣晗. All rights reserved.
//

import Result
import RxSwift
import RxCocoa
import SVProgressHUD

class RxViewController: UIViewController {
    @IBOutlet weak var verifyCodeButton: UIButton!
    @IBOutlet weak var errorButton: UIButton!
    
    private var stopTimerSignal = PublishSubject<()>()
    private var disposeBag = DisposeBag()
    
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
        self.stopTimerSignal.onNext(())
        
        SVProgressHUD.setMinimumDismissTimeInterval(0)
        SVProgressHUD.showErrorWithStatus(">_< 出错了")
    }
    
    @IBAction func verifyCodeButtonPressed(sender: AnyObject) {
        let limit = 10
        var countDown = limit - 1
        
        self.updateVerifyCodeButton(countDown)
        self.errorButton.enabled = true
        
        Observable<Int>
            .interval(1, scheduler: MainScheduler.instance)
            .map { _ -> Int in
                countDown -= 1
                return countDown
            }
            .take(limit - 1)
            .takeUntil(self.rx_deallocated)
            .takeUntil(self.stopTimerSignal)
            .subscribeOn(MainScheduler.instance)
            .subscribe { [weak self] (event) in
                switch event {
                case .Next(let countDown):
                    print("Timer: \(countDown)")
                    
                    guard let this = self else {return}
                    this.updateVerifyCodeButton(countDown)
                case .Completed:
                    print("Timer: Completed")
                    
                    guard let this = self else {return}
                    this.updateVerifyCodeButton()
                    this.errorButton.enabled = false
                default:
                    break
                }
            }
            .addDisposableTo(self.disposeBag)
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
