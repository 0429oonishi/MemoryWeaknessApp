//
//  MemoryWeaknessViewController.swift
//  MemoryWeaknessApp
//
//  Created by 大西玲音 on 2021/05/19.
//

import UIKit

private enum Player {
    case left
    case right
    mutating func toggle() {
        switch self {
            case .left: self = .right
            case .right: self = .left
        }
    }
}

final class MemoryWeaknessViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var leftPlayerLabel: UILabel!
    @IBOutlet private weak var rightPlayerLabel: UILabel!
    @IBOutlet private weak var leftPlayerScoreLabel: UILabel!
    @IBOutlet private weak var rightPlayerScoreLabel: UILabel!
    
    private var cards = [Card]()
    private var player: Player = .left
    private var leftPlayerScore = 0
    private var rightPlayerScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureCards()
        // あとでユーザーがどちらが先行かを選択できるようにする
        leftPlayerLabel.backgroundColor = .blue
        
        // ビルドするたびに消す
        UserDefaults.standard.removeObject(forKey: .selectedText)
        UserDefaults.standard.removeObject(forKey: .tappedCount)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureCollectionViewLayout()
        
    }
    
    private func configureCards() {
        let imageNames = ["1", "2", "3", "4", "5"]
        for _ in 0..<30 {
            let imageName = imageNames.randomElement()!
            cards.append(Card(image: imageName))
        }
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.register(CardCollectionViewCell.nib,
                                forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
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
        return cell
    }
}

extension MemoryWeaknessViewController: CardCollectionViewCellDelegate {
    func didTapped(isCorrect: Bool) {
        switch player {
            case .left: changeRightPlayer()
            case .right: changeLeftPlayer()
        }
        player.toggle()
        
        func changeRightPlayer() {
            leftPlayerLabel.backgroundColor = .clear
            rightPlayerLabel.backgroundColor = .blue
            if isCorrect {
                leftPlayerScore += 2
                leftPlayerScoreLabel.text = "\(leftPlayerScore)"
            }
        }
        
        func changeLeftPlayer() {
            leftPlayerLabel.backgroundColor = .blue
            rightPlayerLabel.backgroundColor = .clear
            if isCorrect {
                rightPlayerScore += 2
                rightPlayerScoreLabel.text = "\(rightPlayerScore)"
            }
        }
    }
    
}
