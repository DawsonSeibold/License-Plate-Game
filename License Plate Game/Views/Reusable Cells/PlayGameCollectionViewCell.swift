//
//  GameCollectionViewCell.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 2/19/19.
//  Copyright © 2019 Smile App Development. All rights reserved.
//

import UIKit

class PlayGameCollectionViewCell: UICollectionViewCell {
 
    weak var gameNameLabel: UILabel!
    weak var statesFound: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let nameLabel = UILabel(frame: .zero)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            nameLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        self.gameNameLabel = nameLabel
        
        let statesLabel = UILabel(frame: .zero)
        statesLabel.adjustsFontSizeToFitWidth = true
        statesLabel.textColor = .white
        statesLabel.font = UIFont.boldSystemFont(ofSize: 25)
        statesLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(statesLabel)
        
        NSLayoutConstraint.activate([
            statesLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            statesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        ])
        self.statesFound = statesLabel

        
        self.layer.cornerRadius = 12
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = UIColor(red: 16/255, green: 52/255, blue: 166/255, alpha: 1.0)
        
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
//        isWinning = false
    }
    
}
