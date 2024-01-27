//
//  TripCSVGenerator.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

fileprivate let TABLE_SPACING = "\n \n"

class TripCSVGenerator: ReportCSVGenerator {
    override func generateTo(path: String) -> Bool {
        do { try generateContent().write(to: path.asFileURL) }
        catch {
            Logger.error("CSV write error: \(error.localizedDescription)")
           return false
        }
        return true
    }
    
    @objc private func generateContent() -> Data {
        let content = NSMutableString()
        
        appendReceiptsTable(content)
        content.append(TABLE_SPACING)
        
        appendDistancesTable(content)
        
        if WBPreferences.includeCategoricalSummation() && PurchaseService.hasValidAllSubscription {
            appendCategoricalSummationTable(content)
        }
        
        if WBPreferences.separatePaymantsByCategory() && PurchaseService.hasValidAllSubscription {
            appendSeparatedByCategoryTable(content)
        }
        
        return (content as String).byteOrderMarked
    }
    
    private func appendReceiptsTable(_ content: NSMutableString) {
        let receiptTable = ReportCSVTable(content: content, columns: receiptColumns())!
        receiptTable.includeHeaders = true
        
        var recs = receipts()
        if WBPreferences.printDailyDistanceValues() {
            let dReceipts = DistancesToReceiptsConverter.convertDistances(distances()) as! [WBReceipt]
            recs.append(contentsOf: dReceipts)
            recs.sort(by: { $1.date.compare($0.date) == .orderedAscending })
        }
        receiptTable.append(withRows: recs)
    }
    
    private func appendCategoricalSummationTable(_ content: NSMutableString) {
        content.append(TABLE_SPACING)
        let receiptTable = ReportCSVTable(content: content, columns: categoryColumns())!
        receiptTable.includeHeaders = true
        let receipts = receiptsByCategories().flatMap { $0.receipts }
        receiptTable.append(withRows: receipts)
    }
    
    private func appendSeparatedByCategoryTable(_ content: NSMutableString) {
        let categoryReceipts = receiptsByCategories()
        for (category, receipts) in categoryReceipts {
            let receiptTable = ReportCSVTable(content: content, columns: receiptColumns())!
            receiptTable.includeHeaders = true
            content.append(TABLE_SPACING)
            content.append(category.name + "\n")
            receiptTable.append(withRows: receipts)
        }
    }
    
    private func appendDistancesTable(_ content: NSMutableString) {
        if !WBPreferences.printDistanceTable() { return }
        let dists = distances()
        if dists.isEmpty { return }
        let receiptTable = ReportCSVTable(content: content, columns: distanceColumns())!
        receiptTable.includeHeaders = true
        receiptTable.append(withRows: dists)
    }
}

