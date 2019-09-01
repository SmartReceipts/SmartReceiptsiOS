//
//  AccountDataSource.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 08/08/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit

class AccountDataSource: NSObject, UITableViewDataSource {
    private var sections: [AccountSection] = []
    
    func update(dataSet: AccountDataSet) {
        self.sections = dataSet.sections
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        switch item {
        case .user(let user):
            let cell = tableView.dequeueCell(cell: UserCell.self)
            return cell.configureCell(user: user)

        case .ocrScans(let count):
            let cell = tableView.dequeueCell(cell: OCRCell.self)
            return cell.configureCell(count: count)
            
        case .organization(let organization):
            let cell = tableView.dequeueCell(cell: OrganizationCell.self)
            return cell.configureCell(organization: organization, role: .admin)
            
        case .subscription(let subscription):
            let cell = tableView.dequeueCell(cell: SubscriptionCell.self)
            return cell.configureCell(subscription: subscription)
        }
    }
}


struct AccountDataSet {
    let user: User
    let organiztions: [OrganizationModel]
    let subscriptions: [SubscriptionModel]
    
    var sections: [AccountSection] {
        var result: [AccountSection] = []
        
        result.append(.init(items: [.user(user)]))
        result.append(.init(items: [.ocrScans(user.recognitionsAvailable)]))
        result.append(.init(title: LocalizedString("organization_label"), items: organiztions.map { .organization($0) } ))
        result.append(.init(title: LocalizedString("subscriptions_label"), items: subscriptions.map { .subscription($0) } ))
        
        return result.filter { !$0.items.isEmpty }
    }
}

struct AccountSection {
    let title: String?
    let items: [AccountItem]
    
    init(title: String? = nil, items: [AccountItem]) {
        self.title = title
        self.items = items
    }
}

enum AccountItem {
    case user(User)
    case ocrScans(Int)
    case organization(OrganizationModel)
    case subscription(SubscriptionModel)
}

