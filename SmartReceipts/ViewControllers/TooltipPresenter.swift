//
//  TooltipPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 30/08/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift

class TooltipPresenter {
    private let bag = DisposeBag()
    private weak var view: UIView!
    private let trip: WBTrip
    
    private var reportTooltip: TooltipView?
    private var syncErrorTooltip: TooltipView?
    private var reminderTooltip: TooltipView?
    
    private let errorTapSubject = PublishSubject<SyncError>()
    private let generateTapSubject = PublishSubject<Void>()
    private let updateInsetsSubject = PublishSubject<UIEdgeInsets>()
    private let reminderTapSubject = PublishSubject<Void>()
    
    var updateInsets: Observable<UIEdgeInsets> { return updateInsetsSubject.asObservable() }
    var errorTap: Observable<SyncError> { return errorTapSubject.asObservable() }
    var generateTap: Observable<Void> { return generateTapSubject.asObservable() }
    var reminderTap: Observable<Void> { return reminderTapSubject.asObservable() }
    
    init(view: UIView, trip: WBTrip) {
        self.trip = trip
        self.view = view
        
        BackupProvidersManager.shared.getCriticalSyncErrorStream()
            .filter({ $0 != .unknownError })
            .delay(.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] syncError in
                self.presentSyncError(syncError)
            }).disposed(by: bag)
        
        AppNotificationCenter.didSyncBackup
            .subscribe(onNext: { [unowned self] in
                self.presentBackupReminderIfNeeded()
            }).disposed(by: bag)
    }
    
    func presentSyncError(_ syncError: SyncError) {
        syncErrorTooltip?.removeFromSuperview()
        syncErrorTooltip = nil
        
        updateInsetsSubject.onNext(TOOLTIP_INSETS)
        let text = syncError.localizedDescription
        
        syncErrorTooltip = TooltipView.showErrorOn(view: view, text: text)
        
        syncErrorTooltip?.rx.action.subscribe(onNext: { [unowned self] in
            self.syncErrorTooltip = nil
            self.errorTapSubject.onNext(syncError)
            self.updateViewInsets()
        }).disposed(by: bag)
        
        syncErrorTooltip?.rx.close.subscribe(onNext: { [unowned self] in
            self.syncErrorTooltip = nil
            self.updateViewInsets()
        }).disposed(by: bag)
    }
    
    func presentBackupReminderIfNeeded() {
        guard let text = TooltipService.shared.tooltipBackupReminder(), reportTooltip == nil else { return }
        reminderTooltip?.removeFromSuperview()
        reminderTooltip = nil
        
        updateInsetsSubject.onNext(TOOLTIP_INSETS)
        let offset = CGPoint(x: 0, y: TooltipView.HEIGHT)
        
        reminderTooltip = TooltipView.showOn(view: view, text: text, image: #imageLiteral(resourceName: "info"), offset: offset)
        
        reminderTooltip?.rx.action.subscribe(onNext: { [unowned self] in
            TooltipService.shared.markBackupReminderDismissed()
            self.reminderTapSubject.onNext(())
            self.reminderTooltip = nil
            self.updateViewInsets()
        }).disposed(by: bag)
        
        reminderTooltip?.rx.close.subscribe(onNext: { [unowned self] in
            TooltipService.shared.markBackupReminderDismissed()
            self.reminderTooltip = nil
            self.updateViewInsets()
        }).disposed(by: bag)
    }
    
    func presentReportHint() {
        guard let text = TooltipService.shared.reportHint(), reportTooltip == nil else { return }
        reminderTooltip?.removeFromSuperview()
        reminderTooltip = nil
        
        updateInsetsSubject.onNext(TOOLTIP_INSETS)
        
        reminderTooltip = TooltipView.showOn(view: view, text: text, image: #imageLiteral(resourceName: "info"))
        guard let tooltip = reminderTooltip else { return }
        Observable.merge([tooltip.rx.action.asObservable(), tooltip.rx.close.asObservable()])
            .subscribe(onNext: {
                TooltipService.shared.markReportHintInteracted()
                self.reminderTapSubject.onNext(())
                self.reminderTooltip = nil
                self.updateViewInsets()
            }).disposed(by: bag)
    }
    
    func presentBackupPlusTooltip() {
        guard let text = TooltipService.shared.backupPlusReminder(), reportTooltip == nil else { return }
        reminderTooltip?.removeFromSuperview()
        reminderTooltip = nil
        
        updateInsetsSubject.onNext(TOOLTIP_INSETS)
        
        reminderTooltip = TooltipView.showOn(view: view, text: text, image: #imageLiteral(resourceName: "info"))
        reminderTooltip?.rx.action.subscribe(onNext: { [unowned self] in
            TooltipService.shared.markBackupPlusDismissed()
            self.reminderTapSubject.onNext(())
            self.reminderTooltip = nil
            self.updateViewInsets()
        }).disposed(by: bag)
        
        reminderTooltip?.rx.close.subscribe(onNext: { [unowned self] in
            TooltipService.shared.markBackupPlusDismissed()
            self.reminderTooltip = nil
            self.updateViewInsets()
        }).disposed(by: bag)
    }
    
    func presentGenerateIfNeeded() {
        if !TooltipService.shared.moveToGenerateTrigger(for: trip) || syncErrorTooltip != nil || reminderTooltip != nil {
            return
        }
        
        guard let text = TooltipService.shared.generateTooltip(for: trip), reportTooltip == nil else { return }
        updateInsetsSubject.onNext(TOOLTIP_INSETS)
        
        reportTooltip = TooltipView.showOn(view: view, text: text)
        
        reportTooltip?.rx.action.subscribe(onNext: { [unowned self] in
            TooltipService.shared.markMoveToGenerateDismiss()
            self.generateTapSubject.onNext(())
            self.reportTooltip = nil
            self.updateViewInsets()
        }).disposed(by: bag)
        
        reportTooltip?.rx.close.subscribe(onNext: { [unowned self] in
            TooltipService.shared.markMoveToGenerateDismiss()
            self.reportTooltip = nil
            self.updateViewInsets()
        }).disposed(by: bag)
    }
    
    private func updateViewInsets() {
        let insets: UIEdgeInsets = reportTooltip == nil && reminderTooltip == nil && syncErrorTooltip == nil ? .zero : TOOLTIP_INSETS
        self.updateInsetsSubject.onNext(insets)
    }
}
