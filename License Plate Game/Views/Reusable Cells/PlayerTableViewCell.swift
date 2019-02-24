//
//  PlayerTableViewCell.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 6/18/18.
//  Copyright © 2018 Smile App Development. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

    weak var nameLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let titleLabel = UILabel(frame: .zero)
        //        titleLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        //        titleLabel.textColor = .white
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 5
        titleLabel.numberOfLines = 0
        titleLabel.clipsToBounds = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            ])
        self.nameLabel = titleLabel
        
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
        
        self.nameLabel.text = nil
    }
    
}
