//
//  CardCollectionViewCell.swift
//  MemoryWeaknessApp
//
//  Created by 大西玲音 on 2021/05/19.
//

import UIKit

final class CardCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension CardCollectionViewCell {
    func configure(card: Card) {
        backgroundColor = card.color
    }
}
