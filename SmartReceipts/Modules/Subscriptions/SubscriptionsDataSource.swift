//
//  SubscriptionDataSource.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 12.12.2021.
//  Copyright © 2021 Will Baumann. All rights reserved.
//

import UIKit

class SubscriptionsDataSource: NSObject, UICollectionViewDataSource {
    private var sections: [SubscriptionSection] = []
    
    func update(dataSet: SubscriptionDateSet) {
        sections = dataSet.sections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubscriptionCollectionViewCell.identifier, for: indexPath) as? SubscriptionCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(with: item)
        
        return cell
    }
}

struct SubscriptionDateSet {
    let subscriptions: [Subscription]
    
    var sections: [SubscriptionSection] {
        didSet {
            sections.append(.init(items: subscriptions))
        }
    }
}

struct SubscriptionSection {
    let items: [Subscription]
}
