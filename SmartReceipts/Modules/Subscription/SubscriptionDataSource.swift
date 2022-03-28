//
//  SubscriptionDataSource.swift
//  SmartReceipts
//
//  Created by Азамат Агатаев on 12.12.2021.
//  Copyright © 2021 Will Baumann. All rights reserved.
//

import UIKit
import Differentiator
import RxDataSources

final class SubscriptionDataSource: RxCollectionViewSectionedReloadDataSource<PlanSectionItem> {
    init() {
        super.init(
            configureCell: { ds, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PlanCollectionViewCell.identifier,
                    for: indexPath) as? PlanCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(with: item)
                return cell
            }
        )
    }
}


struct PlanSectionItem {
    var items: [Item]
}

extension PlanSectionItem: SectionModelType {
    typealias Item = PlanModel
    
    init(original: PlanSectionItem, items: [Item]) {
        self = original
        self.items = items
    }
}
