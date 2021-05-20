//
//  CardCollectionViewCell.swift
//  MemoryWeaknessApp
//
//  Created by 大西玲音 on 2021/05/19.
//

import UIKit

protocol CardCollectionViewCellDelegate: AnyObject {
    func didTapped(isCorrect: Bool)
}

final class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var label: UILabel!
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
    private var isDisplayed = true
    private var tappedCount = 0
    var delegate: CardCollectionViewCellDelegate?
    private enum TapCount {
        case one
        case two
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDisplayed else { return }
        countCardDidSelected()
        hideCard()
    }
    
    private func countCardDidSelected() {
        tappedCount = UserDefaults.standard.integer(forKey: .tappedCount)
        let isCorrect = isCorrect()
        if tappedCount == 0 {
            tappedCount = 1
        } else if tappedCount == 1 {
            tappedCount = 0
            delegate?.didTapped(isCorrect: isCorrect)
        }
        UserDefaults.standard.set(tappedCount, forKey: .tappedCount)
    }
    
    private func isCorrect() -> Bool {
        let newSelectedText = label.text ?? ""
        let oldSelectedText = UserDefaults.standard.string(forKey: .selectedText) ?? ""
        UserDefaults.standard.set(newSelectedText, forKey: .selectedText)
        return newSelectedText == oldSelectedText
    }
    
    private func hideCard() {
        label.text = ""
        backgroundColor = .clear
        isDisplayed = false
    }
    
}

extension CardCollectionViewCell {
    func configure(card: Card) {
        label.text = card.image
        backgroundColor = .red
    }
}
