//
//  MemoryWeaknessViewController.swift
//  MemoryWeaknessApp
//
//  Created by 大西玲音 on 2021/05/19.
//

import UIKit

final class MemoryWeaknessViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var leftPlayerLabel: UILabel!
    @IBOutlet private weak var rightPlayerLabel: UILabel!
    @IBOutlet private weak var leftPlayerScoreLabel: UILabel!
    @IBOutlet private weak var rightPlayerScoreLabel: UILabel!
    
    private var cards = [Card]()
    private var isLeftPlayerPlaying = true
    private var leftPlayerScore = 0
    private var rightPlayerScore = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.register(CardCollectionViewCell.nib,
                                forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
        
        let imageNames = ["1", "2", "3"]
        for _ in 0..<25 {
            let imageName = imageNames.randomElement()!
            cards.append(Card(image: imageName))
        }
        
        // あとでユーザーがどちらが先行かを選択できるようにする
        leftPlayerLabel.backgroundColor = .blue
        
        // ビルドするたびに消す
        UserDefaults.standard.removeObject(forKey: "SelectedText")
        UserDefaults.standard.removeObject(forKey: "TappedCount")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureCollectionViewLayout()
        
    }
    
    private func configureCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 2
        let horizontalItemCount: CGFloat = 5
        let collectionViewWidth = collectionView.frame.size.width
        let itemWidth = (collectionViewWidth - itemSpacing * (horizontalItemCount + 1)) / horizontalItemCount
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: itemSpacing,
                                           bottom: 0,
                                           right: itemSpacing)
        collectionView.collectionViewLayout = layout
    }
    
}

extension MemoryWeaknessViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CardCollectionViewCell.identifier,
            for: indexPath
        ) as!CardCollectionViewCell
        let card = cards[indexPath.item]
        cell.configure(card: card)
        cell.delegate = self
        cell.onTapEvent = { [weak self] in
            guard let self = self else { return }
            if self.isLeftPlayerPlaying {
                self.leftPlayerLabel.backgroundColor = .clear
                self.rightPlayerLabel.backgroundColor = .blue
            } else {
                self.leftPlayerLabel.backgroundColor = .blue
                self.rightPlayerLabel.backgroundColor = .clear
            }
            self.isLeftPlayerPlaying.toggle()
        }
        return cell
    }
}

extension MemoryWeaknessViewController: CardCollectionViewCellDelegate {
    func didTapped(isCorrect: Bool) {
        if isCorrect {
            if isLeftPlayerPlaying {
                leftPlayerScore += 2
                leftPlayerScoreLabel.text = "\(leftPlayerScore)"
            } else {
                rightPlayerScore += 2
                rightPlayerScoreLabel.text = "\(rightPlayerScore)"
            }
        }
    }
}
