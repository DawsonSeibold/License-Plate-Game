//
//  SelectedStateCollectionViewCell.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 6/19/18.
//  Copyright © 2018 Smile App Development. All rights reserved.
//

import UIKit

class SelectedStateCollectionViewCell: UICollectionViewCell {
    
    private let playerColor: UIColor = UIColor(red: 72/255, green: 209/255, blue: 204/255, alpha: 0.5) //Medium Turquoise
    private let winningColor: UIColor = UIColor(red: 0/255, green: 250/255, blue: 154/255, alpha: 0.3) //Medium Spring Green
    private let nonWinningColor: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
    private let goldColor: UIColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 0.3) //Gold
    
    var stateLabel: UILabel!
    var deleteButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
        self.backgroundColor = UIColor.Custom.Orange //nonWinningColor
        
        deleteButton = UIButton(frame: .zero)
        deleteButton.setTitle("X", for: .normal)
        deleteButton.tintColor = UIColor.white
        deleteButton.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        deleteButton.layer.borderWidth = 1
        deleteButton.layer.borderColor = UIColor.white.cgColor
        deleteButton.layer.cornerRadius = 15
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            deleteButton.heightAnchor.constraint(equalToConstant: 30),
            deleteButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            deleteButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        stateLabel = UILabel(frame: .zero)
        stateLabel.adjustsFontSizeToFitWidth = true
        stateLabel.minimumScaleFactor = 5
        stateLabel.numberOfLines = 1
        stateLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        stateLabel.textColor = .white
        stateLabel.clipsToBounds = true
        stateLabel.textAlignment = .center
//        stateLabel.backgroundColor = playerColor
        
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(stateLabel)
        NSLayoutConstraint.activate([
            stateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            stateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            stateLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -10),
//            stateLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            stateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])

        
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
        self.stateLabel.text = nil
    }
    
}
