//
//  BahavierReplay+Extensions.swift
//  SmartReceipts
//
//  Created by a.agataev on 09.04.2022.
//  Copyright © 2022 Will Baumann. All rights reserved.
//

import RxCocoa

extension BehaviorRelay {
    public func update(_ update: (inout Element) -> ()) {
        var value = self.value
        update(&value)
        accept(value)
    }
}
