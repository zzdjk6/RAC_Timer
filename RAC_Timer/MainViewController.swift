//
//  MainViewController.swift
//  RAC_Timer
//
//  Created by 陈圣晗 on 16/4/26.
//  Copyright © 2016年 陈圣晗. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBAction func usingRxButtonPressed(sender: AnyObject? = nil) {
        let vc = RxViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func usingRAC4ButtonPressed(sender: AnyObject? = nil) {
        let vc = RAC4ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func usingRAC2RXButtonPressed(sender: AnyObject? = nil) {
        let vc = RAC2RxViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
