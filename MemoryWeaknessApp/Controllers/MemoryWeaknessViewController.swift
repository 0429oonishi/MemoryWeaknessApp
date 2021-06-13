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
    private let userDefault = UserDefault<UserDefautlsKeys.CardKeyType>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupCards()
        // あとでユーザーがどちらが先行かを選択できるようにする
        leftPlayerLabel.backgroundColor = .blue
        
        // ビルドするたびに消す
        userDefault.remove(forKey: .selectedText)
        userDefault.remove(forKey: .tappedCount)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupCollectionViewLayout()
        
    }
    
    private func setupCards() {
        let imageNames = [Int](1...15).map { String($0) }
        imageNames.forEach { imageName in
            cards.append(Card(image: imageName, isHide: true))
            cards.append(Card(image: imageName, isHide: true))
        }
        cards.shuffle()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.register(CardCollectionViewCell.nib,
                                forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
    }
    
    private func setupCollectionViewLayout() {
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
        ) as! CardCollectionViewCell
        let card = cards[indexPath.item]
        cell.tag = indexPath.row
        cell.configure(card: card)
        cell.onTapEvent = { [unowned self] (isCorrect, firstTag, secondTag) in
            switch (player, isCorrect) {
                case (.left, true):
                    leftPlayerScore += 2
                    leftPlayerScoreLabel.text = "\(leftPlayerScore)"
                    cards[firstTag].isHide = true
                    cards[secondTag].isHide = true
                case (.left, false):
                    player.toggle()
                    leftPlayerLabel.backgroundColor = .clear
                    rightPlayerLabel.backgroundColor = .blue
                    cards[firstTag].isHide = false
                    cards[secondTag].isHide = false
                case (.right, true):
                    rightPlayerScore += 2
                    rightPlayerScoreLabel.text = "\(rightPlayerScore)"
                    cards[firstTag].isHide = true
                    cards[secondTag].isHide = true
                case (.right, false):
                    player.toggle()
                    leftPlayerLabel.backgroundColor = .blue
                    rightPlayerLabel.backgroundColor = .clear
                    cards[firstTag].isHide = false
                    cards[secondTag].isHide = false
            }
            if isCorrect {
                cell.hideCards()
            } else {
                
            }
            if (leftPlayerScore + rightPlayerScore) == cards.count {
                print("全てのカードがめくられた")
            }
        }
        return cell
    }
}
