//
//  CardCollectionViewCell.swift
//  MemoryWeaknessApp
//
//  Created by 大西玲音 on 2021/05/19.
//

import UIKit

final class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var label: UILabel!
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
    private var isDisplayed = true
    private var tappedCount = 0
    var onTapEvent: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDisplayed else { return }
        hideCard()
        countCardDidSelected()
    }
    
    private func hideCard() {
        guard let newSelectedText = label.text else { return }
        let oldSelectedText = UserDefaults.standard.string(forKey: "SelectedText") ?? ""
        if !oldSelectedText.isEmpty {
            if oldSelectedText == newSelectedText {
                print("same")
            } else {
                print("wrong")
            }
        }
        UserDefaults.standard.set(newSelectedText, forKey: "SelectedText")
        label.text = ""
        backgroundColor = .clear
        isDisplayed = false
    }
    
    private func countCardDidSelected() {
        tappedCount = UserDefaults.standard.integer(forKey: "TappedCount")
        if tappedCount == 0 {
            tappedCount = 1
        } else if tappedCount == 1 {
            tappedCount = 0
            onTapEvent?()
        }
        UserDefaults.standard.set(tappedCount, forKey: "TappedCount")
    }
    
}

extension CardCollectionViewCell {
    func configure(card: Card) {
        label.text = card.image
        backgroundColor = .red
    }
}
