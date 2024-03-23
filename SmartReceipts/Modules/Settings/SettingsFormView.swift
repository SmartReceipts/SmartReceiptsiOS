//
//  SettingsFormView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Eureka
import RxSwift
import StoreKit
import FirebaseCrashlytics

fileprivate let IMAGE_OPTIONS = [512, 1024, 2048, 0]

final class SettingsFormView: FormViewController {
    weak var openModuleSubject: PublishSubject<SettingsRoutes>!
    weak var alertSubject: PublishSubject<AlertTuple>!
    weak var settingsView: SettingsView!
    
    fileprivate var hadPriceRetrieveError = false
    fileprivate var purchaseRow: PurchaseButtonRow!
    fileprivate var footerRow: InputTextRow!
    fileprivate var removeAdsProduct: SKProduct?
    fileprivate let bag = DisposeBag()
    
    private let dateFormats: [String]
    private let hasValidSubscription: Bool
    
    var hud: PendingHUDView?
    var showOption: ShowSettingsOption?
    
    init(settingsView: SettingsView, dateFormats: [String], hasValidSubscription: Bool) {
        self.settingsView = settingsView
        self.dateFormats = dateFormats
        self.hasValidSubscription = hasValidSubscription
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        purchaseRow.markSpinning()
        checkSubscription()
        applySettingsOption()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorColor = UIColor.clear
        
        form
        +++ Section(LocalizedString("pref_pro_header"))
        <<< PurchaseButtonRow() { [unowned self] row in
            row.title = LocalizedString("pro_subscription")
            self.purchaseRow = row
            row.hidden = Condition.function([], { form in
                RemoteConfigService.shared.subscriptionsEnabled
            })
        }.onCellSelection({ [unowned self] _, row in
            if !row.isPurchased() {
                self.hud = PendingHUDView.showFullScreen()
                self.settingsView.purchaseSubscription()
                    .do(onNext: { [weak self] _ in
                        self?.hud?.hide()
                    }, onError: { [weak self] _ in
                        self?.hud?.hide()
                    }).subscribe(onNext: { [weak self] in
                        guard let safeSelf = self else { return }
                        safeSelf.checkSubscription()
                    }, onError: { error in
                        self.alertSubject.onNext((title: LocalizedString("purchase_failed"), message: error.localizedDescription))
                }).disposed(by: self.bag)
            }
        })
            
        <<< ButtonRow() { row in
            row.title = LocalizedString("settings_purchase_restore_label")
            row.hidden = Condition.function([], { form in
                RemoteConfigService.shared.subscriptionsEnabled
            })
        }.cellUpdate({ cell, row in
            cell.textLabel?.textColor = AppTheme.primaryColor
        }).onCellSelection({ [unowned self] _, _ in
            self.hud = PendingHUDView.showFullScreen()
            self.settingsView.restoreSubscription()
                .do(onNext: { [weak self] _ in
                    self?.hud?.hide()
                }, onError: { [weak self] _ in
                    self?.hud?.hide()
                }).filter({ $0.plusValid })
                .subscribe(onNext: { [weak self] validation in
                    self?.setupPurchased(expireDate: validation.plusExpireTime)
                }, onError: { error in
                    self.alertSubject.onNext((title: LocalizedString("purchase_unavailable"), message: error.localizedDescription))
                }).disposed(by: self.bag)
        })
        
        <<< ButtonRow() { row in
            row.title = LocalizedString("ocr_open_subcription_button_text")
            row.hidden = Condition.function([], { form in
                !RemoteConfigService.shared.subscriptionsEnabled
            })
        }.cellUpdate({ cell, row in
            cell.textLabel?.textColor = AppTheme.primaryColor
        }).onCellSelection({ [unowned self] _, _ in
            self.openModuleSubject.onNext(.subscription)
        })
        
        +++ Section(LocalizedString("pref_pro_header"))
        <<< InputTextRow() { [unowned self] row in
            row.title = LocalizedString("pref_pro_pdf_footer_title")
            row.value = WBPreferences.pdfFooterString()
            self.footerRow = row
            row.isEnabled = self.hasValidSubscription
        }.onChange({ row in
            WBPreferences.setPDFFooterString(row.value ?? "")
        }).cellUpdate({ cell, row in
            cell.textField.font = .systemFont(ofSize: 14)
        }).onCellSelection({ [unowned self] _, row in
            if !row.isEnabled {
                self.alertSubject.onNext((title: LocalizedString("pref_pro_header"),
                                        message: LocalizedString("settings_pdf_footer_pro_message_body")))
            }
        })
        
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_pro_separate_by_category_title")
            row.value = WBPreferences.separatePaymantsByCategory()
            row.onSubtitle = LocalizedString("pref_pro_separate_by_category_summaryOn")
            row.offSubtitle = LocalizedString("pref_pro_separate_by_category_summaryOff")
        }.onChange({ row in
            WBPreferences.setSeparatePaymantsByCategory(row.value!)
        }).cellUpdate({ [unowned self] cell, _ in
            cell.isUserInteractionEnabled = self.hasValidSubscription
        })
        
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_pro_categorical_summation_title")
            row.value = WBPreferences.includeCategoricalSummation()
            row.onSubtitle = LocalizedString("pref_pro_categorical_summation_summaryOn")
            row.offSubtitle = LocalizedString("pref_pro_categorical_summation_summaryOff")
        }.onChange({ row in
            WBPreferences.setIncludeCategoricalSummation(row.value!)
        }).cellUpdate({ [unowned self] cell, _ in
            cell.isUserInteractionEnabled = self.hasValidSubscription
        })
            
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_pro_omit_default_table_title")
            row.value = WBPreferences.omitDefaultPdfTable()
        }.onChange({ row in
            WBPreferences.setOmitDefaultPdfTable(row.value!)
        }).cellUpdate({ [unowned self] cell, _ in
            cell.isUserInteractionEnabled = self.hasValidSubscription
        })
        
           
        +++ Section(LocalizedString("pref_email_header"))
        <<< textInput(LocalizedString("pref_email_default_email_to_title"),
            value: WBPreferences.defaultEmailRecipient(),
            placeholder: LocalizedString("pref_email_default_email_emptyValue"))
        .onChange({ row in
            WBPreferences.setDefaultEmailRecipient(row.value ?? "")
        })
        
        <<< textInput(LocalizedString("pref_email_default_email_cc_title"),
            value: WBPreferences.defaultEmailCC(),
            placeholder: LocalizedString("pref_email_default_email_emptyValue"))
        .onChange({ row in
            WBPreferences.setDefaultEmailCC(row.value ?? "")
        })
            
        <<< textInput(LocalizedString("pref_email_default_email_bcc_title"),
            value: WBPreferences.defaultEmailBCC(),
            placeholder: LocalizedString("pref_email_default_email_emptyValue"))
        .onChange({ row in
            WBPreferences.setDefaultEmailBCC(row.value ?? "")
        })
            
        <<< textInput(LocalizedString("pref_email_default_email_subject_title"),
            value: WBPreferences.defaultEmailSubject())
        .onChange({ row in
            WBPreferences.setDefaultEmailSubject(row.value ?? "")
        })

        +++ Section(LocalizedString("pref_general_header"))
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_receipt_enable_autocomplete_title")
            row.onSubtitle = LocalizedString("pref_receipt_enable_autocomplete_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.isAutocompleteEnabled()
        }.onChange({ row in
            WBPreferences.setAutocompleteEnabled(row.value!)
        })
            
        <<< IntRow() { row in
            row.title = LocalizedString("pref_general_trip_duration_title")
            row.value = Int(WBPreferences.defaultTripDuration())
        }.onChange({ row in
            let intValue = row.value ?? 0
            if intValue > 0  && 1000 > intValue {
                WBPreferences.setDefaultTripDuration(Int32(intValue))
            }
        }).cellUpdate({ cell, _ in
            cell.textField.textColor = AppTheme.primaryColor
        }).cellSetup({ cell, _ in
            cell.textLabel?.numberOfLines = 3
        })
            
        <<< DecimalRow() { row in
            row.title = LocalizedString("pref_receipt_minimum_receipts_price_title")
            row.placeholder = LocalizedString("DIALOG_RECEIPTMENU_HINT_PRICE_SHORT")
            let value = WBPreferences.minimumReceiptPriceToIncludeInReports()
            row.value = value == WBPreferences.min_FLOAT() || value == Float(Int32.min) ? nil : Double(value)
        }.onChange({ row in
            let value = row.value == nil ? WBPreferences.min_FLOAT() : Float(row.value!)
            WBPreferences.setMinimumReceiptPriceToIncludeInReports(value)
        }).cellUpdate({ cell, _ in
            cell.textField.textColor = AppTheme.primaryColor
        }).cellSetup({ cell, _ in
            cell.textLabel?.numberOfLines = 3
            cell.textField.inputView = NumberKeyboard.create(delegate: cell.textField)
        })
            
        <<< textInput(LocalizedString("pref_output_username_title"),
            value: WBPreferences.userID())
        .onChange({ row in
            WBPreferences.setUserID(row.value ?? "")
        })

        <<< PickerInlineRow<String>() { row in
            row.title = LocalizedString("pref_general_default_currency_title")
            row.options = Currency.allCurrencyCodesWithCached()
            row.value = WBPreferences.defaultCurrency()
        }.onChange({ row in
            WBPreferences.setDefaultCurrency(row.value!)
        }).cellSetup({ cell, _ in
            cell.detailTextLabel?.textColor = AppTheme.primaryColor
        })
            
        <<< PickerInlineRow<String>() { [unowned self] row in
            row.title = LocalizedString("pref_general_date_format_title")
            
            let dateFormatter = DateFormatter()
            let date = Date()
            dateFormatter.dateFormat = WBPreferences.dateFormat()
            row.value = dateFormatter.string(from: date)
            row.options = self.dateFormats.map { format in
                dateFormatter.dateFormat = format
                return dateFormatter.string(from: date)
            }
        }.onChange({ [weak self] row in
            guard let self = self, let index = row.options.index(of: row.value!) else { return }
            WBPreferences.setDateFormat(self.dateFormats[index])
        }).cellSetup({ cell, _ in
            cell.detailTextLabel?.textColor = AppTheme.primaryColor
        })
            
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_general_track_cost_center_title")
            row.onSubtitle = LocalizedString("pref_general_track_cost_center_summaryOn")
            row.offSubtitle = LocalizedString("pref_general_track_cost_center_summaryOff")
            row.value = WBPreferences.trackCostCenter()
        }.onChange({ row in
            WBPreferences.setTrackCostCenter(row.value!)
        })
        
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_receipt_predict_categories_title")
            row.onSubtitle = LocalizedString("pref_receipt_predict_categories_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.predictCategories()
        }.onChange({ row in
            WBPreferences.setPredictCategories(row.value!)
        })
            
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_receipt_include_tax_field_title")
            row.onSubtitle = LocalizedString("pref_receipt_include_tax_field_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.includeTaxField()
        }.onChange({ row in
            WBPreferences.setIncludeTaxField(row.value!)
        })
            
        <<< decimalRow(LocalizedString("pref_receipt_tax_percent_title"),
            float: WBPreferences.defaultTaxPercentage(),
            placeholder: "%")
        .onChange({ row in
            let value = row.value == nil ? nil : Float(row.value!)
            WBPreferences.setDefaultTaxPercentage(value ?? 0)
        })
            
        <<< switchRow(LocalizedString("pref_receipt_pre_tax_title"),
            value: WBPreferences.enteredPricePreTax())
        .onChange({ row in
            WBPreferences.setEnteredPricePreTax(row.value!)
        })
        
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_receipt_full_page_title")
            row.onSubtitle = LocalizedString("pref_receipt_full_page_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.assumeFullPage()
        }.onChange({ row in
            WBPreferences.setAssumeFullPage(row.value!)
        })
        
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_receipt_match_name_to_category_title")
            row.onSubtitle = LocalizedString("pref_receipt_match_name_to_category_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.matchNameToCategory()
        }.onChange({ row in
            WBPreferences.setMatchNameToCategory(row.value!)
        })
        
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_receipt_match_comment_to_category_title")
            row.onSubtitle = LocalizedString("pref_receipt_match_comment_to_category_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.matchCommentToCategory()
        }.onChange({ row in
            WBPreferences.setMatchCommentToCategory(row.value!)
        })
        
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_receipt_reimbursable_only_title")
            row.onSubtitle = LocalizedString("pref_receipt_reimbursable_only_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.onlyIncludeReimbursableReceiptsInReports()
        }.onChange({ row in
            WBPreferences.setOnlyIncludeReimbursableReceiptsInReports(row.value!)
        })
            
            
        <<< switchRow(LocalizedString("pref_receipt_reimbursable_default_title"),
            value: WBPreferences.expensableDefault())
        .onChange({ row in
            WBPreferences.setExpensableDefault(row.value!)
        })
        
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_receipt_default_to_report_start_date_title")
            row.onSubtitle = LocalizedString("pref_receipt_default_to_report_start_date_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.defaultToFirstReportDate()
        }.onChange({ row in
            WBPreferences.setDefaultToFirstReportDate(row.value!)
        })
            
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_receipt_show_id_title")
            row.onSubtitle = LocalizedString("pref_receipt_show_id_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.showReceiptID()
        }.onChange({ row in
            WBPreferences.setShowReceiptID(row.value!)
        })
            
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_receipt_use_payment_methods_title")
            row.onSubtitle = LocalizedString("pref_receipt_use_payment_methods_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.usePaymentMethods()
        }.onChange({ row in
            WBPreferences.setUsePaymentMethods(row.value!)
        })
            
        <<< openModuleButton(LocalizedString("pref_receipt_payment_methods_title"),
            subtitle: LocalizedString("pref_receipt_payment_methods_summary"), route: .paymentMethods)

        +++ Section(LocalizedString("pref_camera_header"))
        <<< segmentedRow(LocalizedString("settings_max_camera_resolution_label"),
            options: imageOptions(), selected: imageOptionFromPreferences())
        .onChange({ row in
            WBPreferences.setCameraMaxHeightWidth(IMAGE_OPTIONS[row.value!])
        })
        
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_camera_bw_title")
            row.onSubtitle = LocalizedString("pref_camera_bw_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.cameraSaveImagesBlackAndWhite()
        }.onChange({ row in
            WBPreferences.setCameraSaveImagesBlackAndWhite(row.value!)
        })
            
        
        +++ Section(LocalizedString("menu_main_categories"))
        <<< openModuleButton(LocalizedString("manage_categories"),
            subtitle: LocalizedString("pref_receipt_customize_categories_summary"), route: .categories)
        
        +++ Section(LocalizedString("pref_output_custom_csv_title"))
        <<< openModuleButton(LocalizedString("pref_output_custom_csv_title"), route: .columns(isCSV: true))
    
        +++ Section(LocalizedString("pref_output_custom_pdf_title"))
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_output_print_receipt_id_by_photo_title")
            row.onSubtitle = LocalizedString("pref_output_print_receipt_id_by_photo_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.printReceiptIDByPhoto()
        }.onChange({ row in
            WBPreferences.setPrintReceiptIDByPhoto(row.value!)
        })
            
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_output_print_receipt_comment_by_photo_title")
            row.onSubtitle = LocalizedString("pref_output_print_receipt_comment_by_photo_summaryOn")
            row.offSubtitle = LocalizedString("pref_output_print_receipt_comment_by_photo_summaryOff")
            row.value = WBPreferences.printCommentByPhoto()
        }.onChange({ row in
            WBPreferences.setPrintCommentByPhoto(row.value!)
        })

        <<< switchRow(LocalizedString("pref_output_receipts_landscape_title"),
            value: WBPreferences.printReceiptTableLandscape())
        .onChange({ row in
            WBPreferences.setPrintReceiptTableLandscape(row.value!)
        })
            
        <<< PickerInlineRow<String>() { row in
            row.title = LocalizedString("pref_output_preferred_language_title")
            row.options = WBPreferences.languages.map { $0.name }
            let preferred = WBPreferences.preferredReportLanguage()
            row.value = WBPreferences.languageBy(identifier: preferred!)?.name
        }.onChange({ row in
            guard let lang = WBPreferences.languageBy(name: row.value!) else { return }
            WBPreferences.setPreferredReportLanguage(lang.identifier)
        })
            
        <<< segmentedRow(LocalizedString("settings_pdf_page_size"),
            options: pdfFormats(), selected: pdfFormats().index(of: WBPreferences.prefferedPDFSize().rawValue) ?? 0)
        .onChange({ row in
            WBPreferences.setPreferredRawPDFSize(PDFPageSize.pdfPageSizeBy(index: row.value!).rawValue)
        })

        <<< openModuleButton(LocalizedString("pref_output_custom_pdf_title"),
            route: .columns(isCSV: false))
        
        +++ Section(LocalizedString("pref_distance_header"))
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_distance_header")
            row.onSubtitle = LocalizedString("pref_distance_include_price_in_report_summaryOn")
            row.offSubtitle = LocalizedString("pref_distance_include_price_in_report_summaryOff")
            row.value = WBPreferences.isTheDistancePriceBeIncludedInReports()
        }.onChange({ row in
            WBPreferences.setTheDistancePriceBeIncludedInReports(row.value!)
        })
            
        <<< decimalRow(LocalizedString("pref_distance_rate_title"),
            dobule: WBPreferences.distanceRateDefaultValue(),
            placeholder: LocalizedString("distance_rate_field"))
        .onChange({ row in
            WBPreferences.setDistanceRateDefaultValue(row.value ?? -1)
        })
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_distance_print_table_title")
            row.onSubtitle = LocalizedString("pref_distance_print_table_summaryOn")
            row.offSubtitle = LocalizedString("pref_distance_print_table_summaryOff")
            row.value = WBPreferences.printDistanceTable()
        }.onChange({ row in
            WBPreferences.setPrintDistanceTable(row.value!)
        })

        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_distance_print_daily_title")
            row.onSubtitle = LocalizedString("pref_distance_print_daily_summaryOn")
            row.offSubtitle = LocalizedString("pref_distance_print_daily_summaryOff")
            row.value = WBPreferences.printDailyDistanceValues()
        }.onChange({ row in
            WBPreferences.setPrintDailyDistanceValues(row.value!)
        })
        
        +++ Section(LocalizedString("pref_layout_header"))
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_layout_display_date_title")
            row.onSubtitle = LocalizedString("pref_layout_display_date_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.layoutShowReceiptDate()
        }.onChange({ row in
            WBPreferences.setLayoutShowReceiptDate(row.value!)
        })
            
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_layout_display_category_title")
            row.onSubtitle = LocalizedString("pref_layout_display_category_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.layoutShowReceiptCategory()
        }.onChange({ row in
            WBPreferences.setLayoutShowReceiptCategory(row.value!)
        })
            
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_layout_display_photo_title")
            row.onSubtitle = LocalizedString("pref_layout_display_photo_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.layoutShowReceiptAttachmentMarker()
        }.onChange({ row in
            WBPreferences.setLayoutShowReceiptAttachmentMarker(row.value!)
        })
            
        +++ Section(LocalizedString("pref_privacy_header"))
        <<< openModuleButton(LocalizedString("pref_about_privacy_policy_title"), route: .privacyPolicy)
        
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_privacy_enable_analytics_title")
            row.onSubtitle = LocalizedString("pref_privacy_enable_analytics_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.analyticsEnabled()
        }.onChange({ row in
            WBPreferences.setAnalyticsEnabled(row.value!)
            AnalyticsManager.sharedManager.setAnalyticsSending(allowed: row.value!)
        })
            
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_privacy_enable_crash_tracking_title")
            row.onSubtitle = LocalizedString("pref_privacy_enable_crash_tracking_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.crashTrackingEnabled()
        }.onChange({ row in
            WBPreferences.setCrashTrackingEnabled(row.value!)
            Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(row.value!)
        })
            
        <<< DescribedSwitchRow() { row in
            row.hidden = Condition(booleanLiteral: hasValidSubscription)
            row.title = LocalizedString("pref_privacy_enable_ad_personalization_title")
            row.onSubtitle = LocalizedString("pref_privacy_enable_ad_personalization_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.adPersonalizationEnabled()
        }.onChange({ row in
            WBPreferences.setAdPersonalizationEnabled(row.value!)
        })
            
        +++ Section(LocalizedString("pref_about_header"))
        <<< openModuleButton(LocalizedString("pref_about_version_title"), subtitle: UIApplication.shared.version())
        <<< openModuleButton(LocalizedString("pref_about_about_title"), route: .about)
        <<< openModuleButton(LocalizedString("pref_about_terms_title"), route: .termsOfUse)
    
        +++ Section(LocalizedString("pref_help_header"))
        <<< openModuleButton(LocalizedString("pref_help_send_feedback_title"),
            onTap: { [unowned self] in
            self.settingsView.sendFeedback(subject: FeedbackEmailSubject)
        })
        <<< openModuleButton(LocalizedString("pref_help_support_email_title"),
            onTap: { [unowned self] in
            self.settingsView.sendFeedback(subject: FeedbackBugreportEmailSubject)
        })
    }
    
    private func imageOptions() -> [String] {
        let pixelsString = LocalizedString("settings_camera_pixels_label")
        let option1 = "512 "+pixelsString
        let option2 = "1024 "+pixelsString
        let option3 = "2048 "+pixelsString
        let option4 = LocalizedString("settings_camera_value_default_label")
        return [option1, option2, option3, option4]
    }
    
    private func pdfFormats() -> [String] {
        return ["A4", LocalizedString("pref_output_pdf_page_size_letter_entryValue")]
    }
    
    private func imageOptionFromPreferences() -> Int {
        return IMAGE_OPTIONS.index(of: WBPreferences.cameraMaxHeightWidth())!
    }
    
    private func checkSubscription() {
        settingsView.subscriptionValidation().subscribe(onNext: { [weak self] validation in
            self?.hud?.hide()
            if validation.plusValid {
                self?.setupPurchased(expireDate: validation.plusExpireTime)
            } else {
                _ = self?.settingsView.retrivePlusSubscriptionPrice().subscribe(onNext: { [weak self] price in
                    self?.purchaseRow.setPrice(string: price)
                }, onError: { [weak self] error in
                    _ = self?.purchaseRow.markError().subscribe(onNext: { [weak self] in
                        self?.alertSubject.onNext((title: LocalizedString("purchase_failed"),
                                                  message: LocalizedString("purchase_unavailable")))
                    })
                })
            }
        }, onError: { [weak self] _ in
            self?.hud?.hide()
        }).disposed(by: bag)
    }
    
    private func setupPurchased(expireDate: Date?) {
        purchaseRow.markPurchased()
        purchaseRow.setSubscriptionEnd(date: expireDate)
        footerRow.isEnabled = true
        DispatchQueue.main.async { [unowned self] in
            self.form.allSections[1].reload()
        }
    }
    
    private func applySettingsOption() {
        if let option = showOption {
            DispatchQueue.main.async { [unowned self] in
                switch option {
                case .reportCSVOutputSection:
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 6), at: .top, animated: false)
                case .distanceSection:
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 8), at: .top, animated: false)
                case .privacySection:
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 10), at: .top, animated: false)
                }
            }
        }
    }
}

// MARK: ROW METHODS
extension SettingsFormView {
    fileprivate func textInput(_ title: String, value: String? = nil, placeholder: String? = nil) -> InputTextRow {
        return InputTextRow() { row in
            row.title = title
            row.value = value
            row.cell.textField.placeholder = placeholder
        }.cellUpdate({ cell, row in
            cell.textField.font = .systemFont(ofSize: 14)
        })
    }
    
    fileprivate func switchRow(_ title: String, value: Bool = false) -> SwitchRow {
        return SwitchRow() { row in
            row.title = title + "  " //  Fix offset between UILabel and UISwtich
            row.value = value
        }.cellSetup({ cell, row in
            cell.switchControl.onTintColor = AppTheme.primaryColor
            cell.textLabel?.numberOfLines = 3
        })
    }
    
    fileprivate func openModuleButton(_ title: String, subtitle: String? = nil, route: SettingsRoutes) -> DescribedButtonRow {
        return DescribedButtonRow() { row in
            row.title = title
            row.subtitle = subtitle
        }.cellUpdate({ cell, row in
            cell.textLabel?.textAlignment = .left
            cell.accessoryType = .disclosureIndicator
            cell.editingAccessoryType = cell.accessoryType
            cell.textLabel?.textColor = .black
        }).onCellSelection({ [unowned self] _,_  in
            self.openModuleSubject.onNext(route)
        })
    }
    
    fileprivate func openModuleButton(_ title: String, subtitle: String? = nil, onTap: (()->Void)? = nil) -> DescribedButtonRow {
        return DescribedButtonRow() { row in
                row.title = title
                row.subtitle = subtitle
            }.cellUpdate({ cell, row in
                cell.textLabel?.textAlignment = .left
                cell.accessoryType = .disclosureIndicator
                cell.editingAccessoryType = cell.accessoryType
                cell.textLabel?.textColor = .black
            }).onCellSelection({ _,_  in
                onTap?()
            })
    }
    
    fileprivate func segmentedRow(_ title: String, options: [String], selected: Int? = nil,
      selectedOption: String? = nil) -> CustomSegmentedRow {
        var value = 0
        if let intVal = selected {
            value = intVal
        } else {
            if let stringValue = selectedOption {
                value = options.firstIndex(of: stringValue) ?? 0
            }
        }
        
        return CustomSegmentedRow() { row in
            row.title = title
            row.options = options
            row.value = value
        }.cellUpdate({ cell, row in
            cell.titleLabel?.font = .systemFont(ofSize: 12)
        })
    }
    
    fileprivate func decimalRow(_ title: String, float: Float, placeholder: String? = nil) -> DecimalRow {
        return DecimalRow() { row in
            row.title = title
            let value = Double(float)
            row.value = value <= 0 ? nil : value
            row.placeholder = placeholder
        }.cellUpdate({ cell, _ in
            cell.textField.textColor = AppTheme.primaryColor
        }).cellSetup({ cell, _ in
            cell.textLabel?.numberOfLines = 3
        })
    }
    
    fileprivate func decimalRow(_ title: String, dobule: Double, placeholder: String? = nil) -> DecimalRow {
        return DecimalRow() { row in
            row.title = title
            let value = dobule
            row.value = value <= 0 ? nil : value
            row.placeholder = placeholder
        }.cellUpdate({ cell, _ in
            cell.textField.textColor = AppTheme.primaryColor
        }).cellSetup({ cell, _ in
            cell.textLabel?.numberOfLines = 3
        })
    }
}
