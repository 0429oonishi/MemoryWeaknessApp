//
//  ViewController.swift
//  MemoryWeaknessApp
//
//  Created by 大西玲音 on 2021/05/19.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private var cards = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CardCollectionViewCell.nib,
                                forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
        
        cards.append(Card(color: .red))
        cards.append(Card(color: .blue))
        cards.append(Card(color: .red))
        cards.append(Card(color: .blue))
        cards.append(Card(color: .red))
        
    }
    
    
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CardCollectionViewCell.identifier,
            for: indexPath
        ) as!CardCollectionViewCell
        let card = cards[indexPath.row]
        cell.configure(card: card)
        return cell
    }
}
