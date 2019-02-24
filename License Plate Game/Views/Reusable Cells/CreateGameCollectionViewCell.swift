//
//  CreateGameCollectionViewCell.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 2/19/19.
//  Copyright © 2019 Smile App Development. All rights reserved.
//

import UIKit

class CreateGameCollectionViewCell: UICollectionViewCell {
    
    private let goldColor: UIColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 0.3) //Gold
    
    weak var nameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let createGameText = UILabel(frame: .zero)
        createGameText.adjustsFontSizeToFitWidth = true
        createGameText.text = "Start New Game"
        createGameText.textColor = .white
        createGameText.font = UIFont.boldSystemFont(ofSize: 25)
        createGameText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(createGameText)
        
        NSLayoutConstraint.activate([
            createGameText.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            createGameText.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        self.nameLabel = createGameText
        
        self.layer.cornerRadius = 12
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = UIColor(red: 0/255, green: 128/255, blue: 255/255, alpha: 1.0)
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
