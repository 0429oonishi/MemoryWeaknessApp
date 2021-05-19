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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let newSelectedText = label.text else { return }
        guard isDisplayed else { return }
        let oldSelectedText = UserDefaults.standard.string(forKey: "key") ?? ""
        if !oldSelectedText.isEmpty {
            if oldSelectedText == newSelectedText {
                print("same")
            } else {
                print("wrong")
            }
        }
        UserDefaults.standard.set(newSelectedText, forKey: "key")
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
