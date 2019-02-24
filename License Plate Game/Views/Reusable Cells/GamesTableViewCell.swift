//
//  PlayerTableViewCell.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 6/18/18.
//  Copyright © 2018 Smile App Development. All rights reserved.
//

import UIKit

class GamesTableViewCell: UITableViewCell {

    var nameLabel: UILabel!
    var hostLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.nameLabel = UILabel(frame: .zero)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 5
        nameLabel.numberOfLines = 0
        nameLabel.clipsToBounds = true
        nameLabel.backgroundColor = .red
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: (self.contentView.frame.height * (2/3) ))
            ])
    
        
        self.hostLabel = UILabel(frame: .zero)
        hostLabel.adjustsFontSizeToFitWidth = true
        hostLabel.minimumScaleFactor = 5
        hostLabel.numberOfLines = 0
        hostLabel.clipsToBounds = true
        hostLabel.font = UIFont(name: "System", size: 9)
        hostLabel.textColor = UIColor.gray
        hostLabel.backgroundColor = .blue
        
        hostLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(hostLabel)
        NSLayoutConstraint.activate([
            hostLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor),
            hostLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            hostLabel.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            hostLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
//            hostLabel.heightAnchor.constraint(equalToConstant: (self.contentView.frame.height * (1/3) ))
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
        
        self.nameLabel.text = nil
        self.hostLabel.text = nil
    }
    
}
