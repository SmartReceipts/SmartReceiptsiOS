//
//  SubscriptionViewModel.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 12.12.2021.
//  Copyright © 2021 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift

protocol SubscriptionViewModelProtocol {
    func moduleDidLoad()
    var dataSet: Observable<PlanDateSet> { get }
}

class SubscriptionViewModel {}
