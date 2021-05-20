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

private enum TapCount: Int {
    case zero
    case one
    mutating func adjust(completion: () -> Void) {
        switch self {
            case .zero:
                self = .one
            case .one:
                completion()
                self = .zero
        }
    }
}

final class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var label: UILabel!
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
    private var isDisplayed = true
    var delegate: CardCollectionViewCellDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDisplayed else { return }
        countCardDidSelected()
        hideCard()
    }
    
    private func countCardDidSelected() {
        let countNum = UserDefaults.standard.integer(forKey: .tappedCount)
        guard var tapCount = TapCount(rawValue: countNum) else { fatalError() }
        let isCorrect = isCorrect()
        tapCount.adjust { delegate?.didTapped(isCorrect: isCorrect) }
        UserDefaults.standard.set(tapCount.rawValue, forKey: .tappedCount)
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
