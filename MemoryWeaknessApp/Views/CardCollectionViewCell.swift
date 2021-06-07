//
//  CardCollectionViewCell.swift
//  MemoryWeaknessApp
//
//  Created by 大西玲音 on 2021/05/19.
//

import UIKit

private enum TapCount: Int {
    case one = 1
    case two = 2
    mutating func toggle() {
        switch self {
            case .one: self = .two
            case .two: self = .one
        }
    }
}

typealias TapEvent = (Bool, Int, Int) -> Void

final class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var label: UILabel!
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
    private var isDisplayed = true
    var onTapEvent: TapEvent?
    var firstTag = 0
    var secondTag = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .red
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDisplayed else { return }
        countCardDidSelected()
    }
    
    private func countCardDidSelected() {
        let countNum = UserDefaults.standard.integer(forKey: .tappedCount)
        var tapCount = TapCount(rawValue: countNum) ?? .one
        let isCorrect = isCorrect()
        switch tapCount {
            case .one:
                firstTag = self.tag
                label.textColor = .black
            case .two:
                secondTag = self.tag
                label.textColor = .black
                onTapEvent?(isCorrect, firstTag, secondTag)
        }
        tapCount.toggle()
        UserDefaults.standard.set(tapCount.rawValue, forKey: .tappedCount)
    }
    
    private func isCorrect() -> Bool {
        let newSelectedText = label.text ?? ""
        let oldSelectedText = UserDefaults.standard.string(forKey: .selectedText) ?? ""
        UserDefaults.standard.set(newSelectedText, forKey: .selectedText)
        return newSelectedText == oldSelectedText
    }
    
    func hideCards() {
        label.textColor = .clear
        label.backgroundColor = .clear
    }
    
}

extension CardCollectionViewCell {
    func configure(card: Card) {
        label.textColor = .clear
        label.text = card.image
    }
}
