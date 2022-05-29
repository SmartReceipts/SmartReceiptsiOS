//
//  ReceiptCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/08/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift

class ReceiptCell: SyncableTableCell {
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var imageButton: UIButton!
    @IBOutlet private weak var categoryLabel: UILabel!
    
    private let bag = DisposeBag()
    
    var onImageTap: VoidBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.onImageTap?()
            }).disposed(by: bag)
        
        imageButton.layer.cornerRadius = Constants.imageRadius
        imageButton.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageButton.setImage(Constants.cameraImage, for: .normal)
    }
    
    @discardableResult
    func configure(receipt: WBReceipt) -> Self {
        priceLabel.text = receipt.formattedPrice()
        nameLabel.text = receipt.name
        categoryLabel.text = receipt.category?.name
        
        var image: UIImage?
        let path = receipt.imageFilePath(for: receipt.trip)
        
        if receipt.hasImage() {
            image = UIImage(contentsOfFile: path)
        } else if receipt.hasPDF() {
            image = generatePDFIcon(url: URL(fileURLWithPath: path))
        }
        
        updateState(receipt: receipt)
        
        guard let buttonImage = image else { return self }
        imageButton.setImage(buttonImage.withRenderingMode(.alwaysOriginal), for: .normal)
    
        return self
    }
    
    private func updateState(receipt: WBReceipt) {
        var state: ModelSyncState = .disabled
        if SyncProvider.current != .none {
            if receipt.attachemntType != .none {
                state = receipt.isSynced(syncProvider: .last) ? .synced : .notSynced
            } else {
                state = .modelState(modelChangeDate: receipt.lastLocalModificationTime)
            }
        }
        setState(state)
    }
    
    private func generatePDFIcon(url: URL) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }
        let pageRect = page.getBoxRect(.mediaBox)
        let scale = imageButton.bounds.width/pageRect.width
        let renderer = UIGraphicsImageRenderer(size: imageButton.bounds.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)
            ctx.cgContext.translateBy(x: 0.0, y: imageButton.bounds.size.height)
            ctx.cgContext.scaleBy(x: scale, y: -scale)
            ctx.cgContext.drawPDFPage(page)
        }
        return img
    }
}

private extension ReceiptCell {
    struct Constants {
        static let imageRadius: CGFloat = 9
        static let cameraImage = #imageLiteral(resourceName: "camera-icon")
    }
}
