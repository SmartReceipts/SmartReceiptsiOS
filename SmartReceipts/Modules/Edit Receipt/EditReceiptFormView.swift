//
//  EditReceiptFormView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Eureka
import RxSwift
import RxCocoa

class EditReceiptFormView: FormViewController, QuickAlertPresenter {
    
    private let CURRENCY_ROW_TAG = "CurrencyRow"
    private let NAME_ROW_TAG = "NameRow"
    private let EXCHANGE_RATE_TAG = "ExchangeRateRow"
    private let BASE_CURRENCY_PRICE_TAG = "BaseCurrencyPriceRow"
    private let COMMENT_ROW_TAG = "CommentRow"
    private let PAYMENT_METHODS_ROW_TAG = "PaymentMethodsRow"
    private let CATEGORIES_ROW_TAG = "CategoriesRow"
    private let PRICE_ROW_TAG = "PriceRow"
    private let TAX_ROW_TAG = "TaxRow"
    private let TAX_PICKER_ROW_TAG = "TaxPickerRow"
    
    let receiptSubject = PublishSubject<WBReceipt>()
    let errorSubject = PublishSubject<String>()
    weak var settingsTap: PublishSubject<Void>?
    weak var manageCategoriesTap: Observable<Void>?
    weak var managePaymentMethodsTap: Observable<Void>?
    var needFirstResponder = true
    
    private var isNewReceipt = false
    private var hasScan = false
    private var receipt: WBReceipt!
    private var trip: WBTrip!
    private var taxCalculator: TaxCalculator?
    private var exchangeRateCalculator: ExchangeRateCalculator!
    private let bag = DisposeBag()
    private var canShowTaxPicker = false
    private var ignoreChanges = false
    
    init(trip: WBTrip, receipt: WBReceipt?) {
        if #available(iOS 13.0, *) { super.init(style: .insetGrouped) }
        else { super.init(style: .grouped) }
        
        self.trip = trip
        isNewReceipt = receipt == nil
        if isNewReceipt {
            self.receipt = WBReceipt()
            self.receipt.setPrice(.zero, currency: trip.defaultCurrency.code)
            self.receipt.date = WBPreferences.defaultToFirstReportDate() ? trip.startDate : Date()
            self.receipt.category =  Database.sharedInstance().category(byName: proposedCategory())
            self.receipt.exchangeRate = .zero
            self.receipt.isReimbursable = WBPreferences.expensableDefault()
            self.receipt.isFullPage = WBPreferences.assumeFullPage()
            self.receipt.timeZone = .current
            self.exchangeRateCalculator = ExchangeRateCalculator()
            
            if let pm = Database.sharedInstance().allPaymentMethods().last {
                self.receipt.paymentMethod = pm
            }
        } else {
            self.receipt = receipt!.copy() as? WBReceipt
            
            let price = receipt?.price().amount.doubleValue ?? 0
            let exchangeRate = receipt?.exchangeRate?.doubleValue ?? 0
            self.exchangeRateCalculator = ExchangeRateCalculator(price: price, exchangeRate: exchangeRate)
        }
        
        // Check conditions for automatic tax calculator
        if WBPreferences.includeTaxField() && WBPreferences.defaultTaxPercentage() != 0 && isNewReceipt {
            taxCalculator = TaxCalculator(preTax: WBPreferences.enteredPricePreTax())
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let exchangeRow = form.rowBy(tag: EXCHANGE_RATE_TAG) as? ExchangeRateRow {
            exchangeRow.responseSubject.onNext(ExchangeResponse(value: nil, error: nil))
            exchangeRow.cell.update()
        }
        
        if let paymentMethodsRow = form.rowBy(tag: PAYMENT_METHODS_ROW_TAG) as? InlinePickerButtonRow {
            paymentMethodsRow.options = Database.sharedInstance().allPaymentMethodsAsStrings()
        }
        
        if let categoriesRow = form.rowBy(tag: CATEGORIES_ROW_TAG) as? InlinePickerButtonRow {
            categoriesRow.options = allCategories()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        form
        +++ Section()
        <<< PredectiveTextRow(NAME_ROW_TAG) { [unowned self] row in
            row.title = LocalizedString("DIALOG_RECEIPTMENU_HINT_NAME")
            row.placeholder = LocalizedString("DIALOG_RECEIPTMENU_HINT_NAME")
            row.value = self.receipt.name
        }.onChange({ [unowned self] row in
            self.receipt.name = row.value ?? ""
        }).cellSetup({ [unowned self] cell, _ in
            cell.configureCell()
            if self.needFirstResponder {
                cell.textField.becomeFirstResponder()
            }
            if WBPreferences.isAutocompleteEnabled() {
                cell.enableAutocompleteHelper(useReceiptsHints: true)
            }
        })
    
        +++ Section()
        <<< DecimalRow(PRICE_ROW_TAG) { [unowned self] row in
            row.title = LocalizedString("DIALOG_RECEIPTMENU_HINT_PRICE_SHORT")
            row.placeholder = LocalizedString("DIALOG_RECEIPTMENU_HINT_PRICE_SHORT")
            row.value = self.receipt.price().amount.doubleValue != 0 ? self.receipt.price().amount.doubleValue : nil
        }.onChange({ [unowned self] row in
            if let dec = row.value {
                let amount = NSDecimalNumber(value: dec)
                self.receipt.setPrice(amount, currency: self.receipt.currency.code)
                self.taxCalculator?.priceSubject.onNext(Decimal(dec))
            } else {
                self.taxCalculator?.priceSubject.onNext(nil)
            }
            self.exchangeRateCalculator.price = row.value ?? 0
            self.updateTaxPicker()
        }).cellSetup({ cell, _ in
            cell.set(image: #imageLiteral(resourceName: "file-text"))
            cell.configureCell()
            cell.textField.inputView = NumberKeyboard.create(delegate: cell.textField)
        })
            
        <<< DecimalRow(TAX_ROW_TAG) { [unowned self] row in
            row.hidden = Condition(booleanLiteral: !WBPreferences.includeTaxField())
            row.title = LocalizedString("DIALOG_RECEIPTMENU_HINT_TAX")
            row.placeholder = LocalizedString("DIALOG_RECEIPTMENU_HINT_TAX")
            row.value = self.isNewReceipt && !self.hasScan ? nil : self.receipt.taxAmount?.doubleValue
            
            self.taxCalculator?.taxSubject.subscribe(onNext: {
                row.value = Double(string: $0)
                row.updateCell()
            }).disposed(by: self.bag)
            
        }.onChange({ [unowned self] row in
            self.receipt.setTax(NSDecimalNumber(value: row.value ?? 0))
        }).cellSetup({ cell, _ in
            cell.set(image: #imageLiteral(resourceName: "percent"))
            cell.configureCell()
            cell.textField.inputView = NumberKeyboard.create(delegate: cell.textField)
        }).onCellHighlightChanged({ [unowned self] cell, _ in
            self.updateTaxPicker()
            self.canShowTaxPicker = cell.textField.isFirstResponder
            self.form.rowBy(tag: self.TAX_PICKER_ROW_TAG)?.evaluateHidden()
        })
            
        <<< HorizontalPickerRow(TAX_PICKER_ROW_TAG) { row in
            row.hidden = Condition.function([], { [unowned self] _ in return self.needShowTaxPicker() })
        }.onChange({ [unowned self] row in
            if let index = row.value {
                let percent = self.taxPercents()[index]
                self.setValue(cellTag: self.TAX_ROW_TAG, value: self.calculateTax(percent: percent))
            }
            row.evaluateHidden()
        })
        
        <<< PickerInlineRow<String>(CURRENCY_ROW_TAG) { [unowned self] row in
            row.title = LocalizedString("DIALOG_RECEIPTMENU_HINT_CURRENCY")
            row.options = Currency.allCurrencyCodesWithCached()
            row.value = self.receipt.currency.code
        }.onChange({ [unowned self] row in
            guard let code = row.value else { return }
            self.receipt.setPrice(self.receipt.priceAmount, currency: code)
            if code != self.trip.defaultCurrency.code {
                self.updateExchangeRate()
            }
        }).cellSetup({ cell, _ in
            cell.set(image: #imageLiteral(resourceName: "credit-card"))
            cell.configureCell()
        })
            
        <<< ExchangeRateRow(EXCHANGE_RATE_TAG) { [unowned self] row in
            row.title = LocalizedString("DIALOG_RECEIPTMENU_HINT_EXCHANGE_RATE")
            row.hidden = Condition.function([CURRENCY_ROW_TAG], { [unowned self] form -> Bool in
                let picker = self.form.rowBy(tag: self.CURRENCY_ROW_TAG) as? PickerInlineRow<String>
                return picker?.value == self.trip.defaultCurrency.code
            })
            row.value = self.receipt.exchangeRate?.doubleValue
            row.updateTap
                .subscribe(onNext: { [unowned self] in self.updateExchangeRate() })
                .disposed(by: self.bag)
            
            self.exchangeRateCalculator.exchangeRateUpdate
                .filter({ _ in !row.cell.textField.isEditing })
                .subscribe(onNext: { [unowned self] value in
                    self.ignoreChanges = true
                    self.exchangeRateCalculator.exchangeRate = value
                    self.receipt.exchangeRate = NSDecimalNumber(value: value)
                    row.value = value
                    row.updateCell()
                    self.ignoreChanges = false
                }).disposed(by: self.bag)
            
        }.onChange({ [unowned self] row in
            if self.ignoreChanges { return }
            let value = row.value ?? 0
            self.receipt.exchangeRate = NSDecimalNumber(value: value)
            self.exchangeRateCalculator.exchangeRate = value
        }).cellSetup({ [unowned self] cell, row in
            cell.setCell(image: #imageLiteral(resourceName: "repeat"))
            cell.alertPresenter = self
            cell.textField.inputView = NumberKeyboard.create(delegate: cell.textField)
        })
            
        <<< DecimalRow(BASE_CURRENCY_PRICE_TAG) { [unowned self] row in
            row.title = LocalizedString("receipt_input_exchanged_result_hint")
            let formatter = NumberFormatter.exchangeFieldFormatter
            formatter.maximumFractionDigits = 2
            row.formatter = formatter
            row.useFormatterOnDidBeginEditing = true
            row.value = self.exchangeRateCalculator.price * self.exchangeRateCalculator.exchangeRate
            row.hidden = Condition.function([CURRENCY_ROW_TAG], { [unowned self] form -> Bool in
                let picker = self.form.rowBy(tag: self.CURRENCY_ROW_TAG) as? PickerInlineRow<String>
                return picker?.value == self.trip.defaultCurrency.code
            })
            
            self.exchangeRateCalculator.baseCurrencyPriceUpdate
                .filter({ _ in !row.cell.textField.isEditing })
                .subscribe(onNext: { [unowned self] in
                    self.ignoreChanges = true
                    row.value = $0
                    row.updateCell()
                    self.ignoreChanges = false
                }).disposed(by: self.bag)
            
        }.onChange({ [unowned self] row in
            if self.ignoreChanges { return }
            self.exchangeRateCalculator.baseCurrencyPrice = row.value ?? 0
        }).cellSetup({ cell, _ in
            let img = UIImage.image(text: self.trip.defaultCurrency.code, font: .boldSystemFont(ofSize: 12))
            cell.set(image: img)
            cell.configureCell()
            cell.textField.inputView = NumberKeyboard.create(delegate: cell.textField)
        })
        
        +++ Section()
        <<< DateInlineRow() { [unowned self] row in
            row.title = LocalizedString("DIALOG_RECEIPTMENU_HINT_DATE")
            row.value = self.receipt.date
            row.dateFormatter?.timeZone = self.receipt.timeZone
            row.dateFormatter?.addWeekdayFormat()
        }.onChange({ [unowned self] row in
            self.receipt.date = row.value ?? Date()
        }).cellSetup({ cell, _ in
            cell.set(image: #imageLiteral(resourceName: "calendar"))
            cell.configureCell()
        }).onExpandInlineRow({ [unowned self] _, _, datePickerRow in
            datePickerRow.cell.datePicker.timeZone = self.receipt.timeZone
        })
        
        +++ Section()
        <<< InlinePickerButtonRow(CATEGORIES_ROW_TAG) { [unowned self] row in
            row.title = LocalizedString("DIALOG_RECEIPTMENU_HINT_CATEGORY")
            row.options = allCategories()
            row.value = receipt.category?.name ?? ""
            row.buttonTitle = LocalizedString("manage_categories").uppercased()
            self.manageCategoriesTap = row.buttonTap
        }.onChange({ [unowned self] row in
            self.receipt.category = Database.sharedInstance().category(byName: row.value!)
            self.matchCategory(value: row.value)
        }).cellSetup({ cell, _ in
            cell.setCell(image: #imageLiteral(resourceName: "tag"))
        })
        
        <<< TextRow(COMMENT_ROW_TAG) { [unowned self] row in
            row.title = LocalizedString("DIALOG_RECEIPTMENU_HINT_COMMENT")
            row.placeholder = LocalizedString("DIALOG_RECEIPTMENU_HINT_COMMENT")
            row.value = self.receipt.comment
        }.onChange({ [unowned self] row in
            self.receipt.comment = row.value ?? ""
        }).cellSetup({ cell, _ in
            cell.set(image: #imageLiteral(resourceName: "message-square"))
            cell.configureCell()
        })
            
        <<< InlinePickerButtonRow(PAYMENT_METHODS_ROW_TAG) { [unowned self] row in
            row.title = LocalizedString("payment_method")
            row.options = Database.sharedInstance().allPaymentMethodsAsStrings()
            row.value = self.receipt.paymentMethod.method
            row.hidden = Condition.function([], { _ in !WBPreferences.usePaymentMethods() })
            row.buttonTitle = LocalizedString("manage_payment_methods").uppercased()
            self.managePaymentMethodsTap = row.buttonTap
        }.onChange({ [unowned self] row in
            if let name = row.value, let pm = Database.sharedInstance().paymentMethod(byName: name) {
                self.receipt.paymentMethod = pm
            }
        })
          
        +++ Section()
        <<< CheckRow() { [unowned self] row in
            row.title = LocalizedString("DIALOG_RECEIPTMENU_HINT_EXPENSABLE")
            row.value = self.receipt.isReimbursable
        }.onChange({ [unowned self] row in
            self.receipt.isReimbursable = row.value!
        }).cellSetup({ cell, _ in
            cell.configureCell()
            cell.tintColor = AppTheme.primaryColor
        })

        <<< CheckRow() { [unowned self] row in
            row.title = LocalizedString("DIALOG_RECEIPTMENU_HINT_FULLPAGE")
            row.value = self.receipt.isFullPage
        }.onChange({ [unowned self] row in
            self.receipt.isFullPage = row.value!
        }).cellSetup({ cell, _ in
            cell.configureCell()
            cell.tintColor = AppTheme.primaryColor
        })
        
        if isNewReceipt {
            matchCategory(value: receipt.category?.name)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .ulpOfOne
    }
    
    func apply(scan: ScanResult?) {
        guard let gScan = scan else { return }
        hasScan = true
        receipt.name = gScan.recognition?.result.data.merchantName?.data ?? ""
        receipt.date = gScan.recognition?.result.data.date?.data ?? Date()
        
        if let amount = gScan.recognition?.result.data.totalAmount?.data {
            receipt.setPrice(NSDecimalNumber(value: amount), currency: trip.defaultCurrency.code)
        }
        
        guard let tax = gScan.recognition?.result.data.taxAmount?.data, WBPreferences.includeTaxField() else { return }
        if let amount = gScan.recognition?.result.data.totalAmount?.data, WBPreferences.enteredPricePreTax() {
            receipt.setPrice(NSDecimalNumber(value: amount - tax), currency: trip.defaultCurrency.code)
        }
        receipt.setTax(NSDecimalNumber(value: tax))
    }
    
    func validate() {
        receipt.trip = trip
        receiptSubject.onNext(receipt)
    }
    
    func checkHiddenPaymentMethod() {
        form.rowBy(tag: PAYMENT_METHODS_ROW_TAG)?.evaluateHidden()
    }
    
    func makeNameFirstResponder() {
        guard let nameRow = form.rowBy(tag: NAME_ROW_TAG) as? PredectiveTextRow else { return }
        nameRow.cell.textField.becomeFirstResponder()
    }
    
    private func needShowTaxPicker() -> Bool {
        if let priceRow = form.rowBy(tag: PRICE_ROW_TAG) as? DecimalRow,
           let price = priceRow.value, price != 0, canShowTaxPicker {
            return false
        } else {
            return true
        }
    }
    
    private func setValue(cellTag: String, value: Any?) {
        form.rowBy(tag: cellTag)?.baseValue = value
        form.rowBy(tag: cellTag)?.updateCell()
    }
    
    private func matchCategory(value: String?) {
        if WBPreferences.matchNameToCategory() {
            setValue(cellTag: NAME_ROW_TAG, value: value)
        }
        
        if WBPreferences.matchCommentToCategory() {
            setValue(cellTag: COMMENT_ROW_TAG, value: value)
        }
    }
    
    func updateTaxPicker() {
        var taxOptions = [NSAttributedString]()
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        
        for percent in taxPercents() {
            let calculatedTax = calculateTax(percent: percent)
            if let valueString = formatter.string(from: calculatedTax),
                let percentString = formatter.string(from: NSDecimalNumber(string: "\(percent)")) {
                let attributedString = NSMutableAttributedString(string: "\(valueString)  \(percentString)%")
                let range = NSRange(location: 0, length: valueString.count)
                attributedString.addAttribute(.font, value: AppTheme.boldFont, range: range)
                taxOptions.append(attributedString)
            }
        }
        
        let taxPickerRow = form.rowBy(tag: TAX_PICKER_ROW_TAG) as? HorizontalPickerRow
        taxPickerRow?.options = taxOptions
    }
    
    private func taxPercents() -> [Float] {
        let defaultTaxPercent = WBPreferences.defaultTaxPercentage()
        var percents = defaultTaxPercent != 0 ? [defaultTaxPercent] : [Float]()
        percents.append(contentsOf: [0, 5, 10, 20])
        return percents
    }
    
    private func calculateTax(percent: Float) -> NSDecimalNumber {
        let preTax = WBPreferences.enteredPricePreTax()
        let taxPercent = NSDecimalNumber(string: "\(percent)")
        let price = NSDecimalNumber(value: ((form.rowBy(tag: PRICE_ROW_TAG) as? DecimalRow)?.value ?? 0))
        let floatTax = TaxCalculator.taxWithPrice(price, taxPercentage: taxPercent, preTax: preTax).floatValue
        return NSDecimalNumber(string: String(format: "%.2f", floatTax))
    }
    
    private func updateExchangeRate() {
        guard let exchangeRow = form.rowBy(tag: EXCHANGE_RATE_TAG) as? ExchangeRateRow else { return }
        CurrencyExchangeService()
            .exchangeRate(trip.defaultCurrency.code, target: receipt.currency.code, onDate: receipt.date)
            .observe(on: MainScheduler.instance)
            .bind(to: exchangeRow.responseSubject)
            .disposed(by: bag)
        
    }
    
    fileprivate func allCategories() -> [String] {
        var result = [String]()
        for category in Database.sharedInstance().listAllCategories() {
            result.append(category.name)
        }
        return result
    }
}

private let whitespaceWorkaround = EurekaWhitespaceWorkaround()
fileprivate extension BaseCell {
    func configureCell() {
        textLabel?.font = AppTheme.boldFont
        detailTextLabel?.textColor = AppTheme.primaryColor
        detailTextLabel?.font = AppTheme.boldFont
        guard let textCell = self as? TextCell else { return }
        whitespaceWorkaround.configureWhiteSpaceWorkaround(forTextCell: textCell)
    }
}

//MARK: Prepare Cells
fileprivate extension EditReceiptFormView {
    func proposedCategory() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: Date())
        let hour = components.hour!
        
        let categories = allCategories()
        if categories.isEmpty {
            return ""
        }
        
        if WBPreferences.predictCategories() {
            var predictedCategory = String()
            if hour >= 4 && hour < 11 {
                predictedCategory = WBCategory.category_NAME_BREAKFAST()
            } else if hour >= 11 && hour < 16 {
                predictedCategory = WBCategory.category_NAME_LUNCH()
            } else if hour >= 16 && hour < 23 {
                predictedCategory = WBCategory.category_NAME_DINNER()
            }
            
            if categories.contains(predictedCategory) {
                return predictedCategory
            }
        }
        
        return categories.first!
    }
}

fileprivate extension Cell {
    func set(image: UIImage) {
        imageView?.image = image.withRenderingMode(.alwaysTemplate)
        imageView?.tintColor = .black
    }
}
