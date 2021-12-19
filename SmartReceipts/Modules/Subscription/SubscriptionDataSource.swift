//
//  SubscriptionDataSource.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 12.12.2021.
//  Copyright © 2021 Will Baumann. All rights reserved.
//

import UIKit

class SubscriptionDataSource: NSObject, UICollectionViewDataSource {
    private var plans: [PlanModel] = []
    
    func update(with dataSet: PlanDateSet) {
        plans = dataSet.plans
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = plans[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PlanCollectionViewCell.identifier,
            for: indexPath) as? PlanCollectionViewCell else {
                return UICollectionViewCell()
            }
        
        return cell.configureCell(with: item)
    }
}

struct PlanDateSet {
    let plans: [PlanModel]
}
