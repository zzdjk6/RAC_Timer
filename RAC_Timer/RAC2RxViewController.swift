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

class RAC2RxViewController: UIViewController {

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
        let countDown = 9
        Observable<Int>.create { observer -> RxSwift.Disposable in
            self.timerSignal(countDown).subscribeNext(
                { (next: AnyObject!) in
                    observer.onNext(next as? Int ?? 0)
                }, error: { (error: NSError!) in
                    observer.onError(error)
                }, completed: {
                    observer.onCompleted()
            })
            
            return NopDisposable.instance
            }
            .takeUntil(self.stopTimerSignal)
            .subscribeOn(MainScheduler.instance)
            .subscribe { (event) in
                switch event {
                case .Next(let counter):
                    print("Timer: \(counter)")
                    
                    self.errorButton.enabled = true
                    self.updateVerifyCodeButton(counter)
                case .Completed:
                    print("Timer: Completed")
                    
                    self.updateVerifyCodeButton()
                    self.errorButton.enabled = false
                case .Error(_):
                    break
                }
            }
            .addDisposableTo(self.disposeBag)
    }
    
    // MARK: - Private
    
    private func timerSignal(countDown: Int) -> RACSignal {
        if countDown <= 0 {
            return RACSignal.createSignal { subscriber -> RACDisposable! in
                subscriber.sendNext(0)
                subscriber.sendCompleted()
                return nil
            }
        }
        
        let sig1 = RACSignal.createSignal { subscriber -> RACDisposable! in
            subscriber.sendNext(countDown)
            subscriber.sendCompleted()
            return nil
        }
        
        var counter = countDown - 1
        let sig2 = RACSignal
            .interval(1, onScheduler: RACScheduler.mainThreadScheduler())
            .map({ obj -> AnyObject! in
                return counter
            })
            .take(UInt(countDown))
            .takeUntil(self.rac_willDeallocSignal())
            .doNext { _ in
                counter -= 1
        }
        
        return sig1.concat(sig2)
    }
    
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
