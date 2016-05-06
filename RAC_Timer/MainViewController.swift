//
//  MainViewController.swift
//  RAC_Timer
//
//  Created by 陈圣晗 on 16/4/26.
//  Copyright © 2016年 陈圣晗. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    @IBAction func usingRxButtonPressed(sender: AnyObject? = nil) {
        let vc = RxViewController()
        vc.title = (sender as? UIButton)?.titleLabel?.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func usingRAC4ButtonPressed(sender: AnyObject? = nil) {
        let vc = RAC4ViewController()
        vc.title = (sender as? UIButton)?.titleLabel?.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func usingRAC2RXButtonPressed(sender: AnyObject? = nil) {
        let vc = RAC2RxViewController()
        vc.title = (sender as? UIButton)?.titleLabel?.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func usingRAC2ButtonPressed(sender: AnyObject? = nil) {
        let vc = RAC2ViewController()
        vc.title = (sender as? UIButton)?.titleLabel?.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func usingRxToRAC2ButtonPressed(sender: AnyObject? = nil) {
        let vc = RxToRAC2ViewController()
        vc.title = (sender as? UIButton)?.titleLabel?.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func usingNSTimerButtonPressed(sender: AnyObject? = nil) {
        let vc = NSTimerViewController()
        vc.title = (sender as? UIButton)?.titleLabel?.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
