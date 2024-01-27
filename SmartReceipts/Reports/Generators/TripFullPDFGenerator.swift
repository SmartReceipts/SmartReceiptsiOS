//
//  TripFullPDFGenerator.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

class TripFullPDFGenerator: TripImagesPDFGenerator {
    override func generateTo(path: String) -> Bool {
        // render tables in landscape orientation if needed
        pdfRender.portraitPreferred = !WBPreferences.printReceiptTableLandscape()
        
        if !pdfRender.setOutput(path: path) { return false }
        appendSummaryAndTables()

        // always render fullPageElements and images in protrait orientation
        pdfRender.portraitPreferred = true
        pdfRender.startNextPage()
        appendImages()
        return pdfRender.renderPages()
    }
    
    private func appendSummaryAndTables() {
        let receiptTotal = PricesCollection()
        let reimbursableTotal = PricesCollection()
        let noTaxesTotal = PricesCollection()
        let taxesTotal = PricesCollection()
        let distanceTotal = PricesCollection()
        let grandTotal = PricesCollection()
        let reportOnlyReimbursable = WBPreferences.onlyIncludeReimbursableReceiptsInReports()
    
        var hasNonReimbursable = false
        
        let recs = receipts()
        
        for receipt in recs {
            if reportOnlyReimbursable && !receipt.isReimbursable {
                continue
            }
            let price = receipt.targetPrice()
            let tax = receipt.targetTax()
            
            receiptTotal.addPrice(price)
            taxesTotal.addPrice(tax)
            noTaxesTotal.addPrice(price)
            grandTotal.addPrice(receipt.exchangedPrice())
            
            if WBPreferences.enteredPricePreTax() {
                grandTotal.addPrice(receipt.exchangedTax())
                receiptTotal.addPrice(tax)
            } else {
                noTaxesTotal.subtractPrice(tax)
            }
            
            if receipt.isReimbursable {
                reimbursableTotal.addPrice(price)
                if WBPreferences.enteredPricePreTax() {
                    reimbursableTotal.addPrice(tax)
                }
            } else {
                hasNonReimbursable = true
            }
        }
        
        let dists = distances()
        
        for distance in dists {
            grandTotal.addPrice(distance.totalRate())
            reimbursableTotal.addPrice(distance.totalRate())
            distanceTotal.addPrice(distance.totalRate())
        }
        
        pdfRender.setTripName(trip: trip.name)
        
        let startDate = dateFormatter.formattedDate(trip.startDate, in: trip.startTimeZone)!
        let endDate = dateFormatter.formattedDate(trip.endDate, in: trip.endTimeZone)!
        pdfRender.appendHeader(row: String(format: WBPreferences.localized(key: "report_header_duration"), startDate, endDate))
        
        if let costCenter = trip.costCenter, WBPreferences.trackCostCenter() && !costCenter.isEmpty {
            pdfRender.appendHeader(row: String(format: WBPreferences.localized(key: "report_header_cost_center"), costCenter))
        }
        
        if let comment = trip.comment, !trip.comment.isEmpty {
            pdfRender.appendHeader(row: String(format: WBPreferences.localized(key: "report_header_comment"), trip.comment))
        }
        
        // Short Code for Get: currencyFormattedPrice()
        func fp(_ p: PricesCollection) -> String { return p.currencyFormattedPrice() }
        
        
        // Print the various tax totals if the IncludeTaxField is true and we have taxes
        if WBPreferences.includeTaxField() && taxesTotal.hasValue() {
            pdfRender.appendHeader(row: String(format: WBPreferences.localized(key: "report_header_receipts_total_no_tax"), fp(noTaxesTotal)))
            pdfRender.appendHeader(row: String(format: WBPreferences.localized(key: "report_header_receipts_total_tax"), fp(taxesTotal)))
            pdfRender.appendHeader(row: String(format: WBPreferences.localized(key: "report_header_receipts_total_with_tax"), fp(receiptTotal)))
        } else if dists.count > 0 {
            // Prints the receipts total if we have distances AND (the IncludeTaxField setting is false OR the value of taxes is 0)
            // We use this to distinguish receipts vs distances when we do NOT have the tax breakdown
            pdfRender.appendHeader(row: String(format: WBPreferences.localized(key: "report_header_receipts_total"), fp(receiptTotal)))
        }
        
        // Print out the distances (if any)
        if dists.count > 0 {
            pdfRender.appendHeader(row: String(format: WBPreferences.localized(key: "report_header_distance_total"), fp(distanceTotal)))
        }
        
        // Print the grand total
        pdfRender.appendHeader(row: String(format: WBPreferences.localized(key: "report_header_grand_total"), fp(grandTotal)), style: .defaultBold)
        
        // Print the grand total (reimbursable)
        if !reportOnlyReimbursable && hasNonReimbursable {
            let row = String(format: WBPreferences.localized(key: "report_header_receipts_total_reimbursable"), fp(reimbursableTotal))
            pdfRender.appendHeader(row: row, style: .defaultBold)
        }
        
        pdfRender.closeHeader()
        
        
        //MARK: Render Tables
        
        if !WBPreferences.omitDefaultPdfTable() || !PurchaseService.hasValidAllSubscription  {
            appendReportsTable()
        }

        if WBPreferences.printDistanceTable() && !dists.isEmpty {
            appendDistancesTable()
        }

        if WBPreferences.includeCategoricalSummation() && PurchaseService.hasValidAllSubscription {
            appendCategoricalSummationTable()
        }
        
        if WBPreferences.separatePaymantsByCategory() && PurchaseService.hasValidAllSubscription {
            appendSeparatedByCategoryTable()
        }
        
    }
    
    private func appendSeparatedByCategoryTable() {
        for (category, receipts) in receiptsByCategories() {
            let receiptsTable = ReportPDFTable(title: category.name, pdfRender: pdfRender, columns: receiptColumns())!
            receiptsTable.includeHeaders = true
            receiptsTable.includeFooters = true
            receiptsTable.append(withRows: receipts)
        }
    }
    
    private func appendReportsTable() {
        var rows = receipts()
        let receiptsTable = ReportPDFTable(pdfRender: pdfRender, columns: receiptColumns())!
        receiptsTable.includeHeaders = true
        receiptsTable.includeFooters = true
        if WBPreferences.printDailyDistanceValues() {
            let dReceipts = DistancesToReceiptsConverter.convertDistances(distances()) as! [WBReceipt]
            rows.append(contentsOf: dReceipts)
            rows.sort(by: { $1.date.compare($0.date) == .orderedAscending })
        }
        receiptsTable.append(withRows: rows)
    }
    
    private func appendDistancesTable() {
        let distancesTable = ReportPDFTable(pdfRender: pdfRender, columns: distanceColumns())!
        distancesTable.includeHeaders = true
        distancesTable.includeFooters = true
        distancesTable.append(withRows: distances())
    }
    
    private func appendCategoricalSummationTable() {
        let receipts = receiptsByCategories().flatMap { $0.receipts }
        
        let isDefaultCurrencies = receipts
            .filter { $0.currency != trip.defaultCurrency }
            .isEmpty
        
        var columns = categoryColumns()
        if isDefaultCurrencies { columns.removeLast() }
        
        let categoricalTable = ReportPDFTable(pdfRender: pdfRender, columns: columns)!
        categoricalTable.includeHeaders = true
        categoricalTable.includeFooters = false
        categoricalTable.append(withRows: receiptsByCategories())
    }
    
}

