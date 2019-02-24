//
//  PlayerScoreCollectionViewCell.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 6/17/18.
//  Copyright © 2018 Smile App Development. All rights reserved.
//

import UIKit

class PlayerScoreCollectionViewCell: UICollectionViewCell {
    
    private let playerColor: UIColor = UIColor(red: 72/255, green: 209/255, blue: 204/255, alpha: 0.5) //Medium Turquoise
    private let winningColor: UIColor = UIColor(red: 0/255, green: 250/255, blue: 154/255, alpha: 0.3) //Medium Spring Green
    private let nonWinningColor: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
    private let goldColor: UIColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 0.3) //Gold

    weak var nameLabel: UILabel!
    weak var scoreLabel: UILabel!
    
    var isWinning: Bool = false {
        didSet {
            self.backgroundColor = isWinning ? winningColor : nonWinningColor
            self.layer.borderColor = isWinning ? winningColor.withAlphaComponent(1.0).cgColor : nonWinningColor.withAlphaComponent(1.0).cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
        self.backgroundColor = nonWinningColor
        
        
        let playerNameLabel = UILabel(frame: .zero)
        playerNameLabel.adjustsFontSizeToFitWidth = true
        playerNameLabel.minimumScaleFactor = 5
        playerNameLabel.numberOfLines = 1
        playerNameLabel.clipsToBounds = true
        playerNameLabel.textAlignment = .center
        playerNameLabel.backgroundColor = playerColor
        
        playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(playerNameLabel)
        NSLayoutConstraint.activate([
            playerNameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            playerNameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            playerNameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            playerNameLabel.heightAnchor.constraint(equalToConstant: self.contentView.frame.height/2)
            ])
        self.nameLabel = playerNameLabel
        
        let playerScoreLabel = UILabel(frame: .zero)
        playerScoreLabel.adjustsFontSizeToFitWidth = true
        playerScoreLabel.minimumScaleFactor = 5
        playerScoreLabel.numberOfLines = 1
        playerScoreLabel.clipsToBounds = true
        playerScoreLabel.textAlignment = .center
        
        playerScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(playerScoreLabel)
        NSLayoutConstraint.activate([
            playerScoreLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            playerScoreLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            playerScoreLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            playerScoreLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            ])
        self.scoreLabel = playerScoreLabel
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("Interface Builder is not supported!")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("Interface Builder is not supported!")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isWinning = false
    }
    
}




