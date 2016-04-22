//
//  NSObject+RAC4.swift
//  RAC_Timer
//
//  Created by 陈圣晗 on 16/4/22.
//  Copyright © 2016年 陈圣晗. All rights reserved.
//

import UIKit
import Result
import ReactiveCocoa

extension NSObject {
    var willDeallocSignalProducer: SignalProducer<(), NoError> {
        return self.rac_willDeallocSignal()
            .toSignalProducer()
            .flatMapError { _ in .empty}
            .map {_ in ()}
    }
}
