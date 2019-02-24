//
//  ClassicStateTableViewCell.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 6/16/18.
//  Copyright © 2018 Smile App Development. All rights reserved.
//

import UIKit

class ClassicStateTableViewCell: UITableViewCell {

    weak var stateImage: UIImageView!
    weak var nameLabel: UILabel!
    var isEnabled: Bool = true
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: self.frame.height),
            imageView.heightAnchor.constraint(equalToConstant: self.frame.height)
            ])
        stateImage = imageView
        
        let titleLabel = UILabel(frame: .zero)
//        titleLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
//        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 21)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 5
        titleLabel.numberOfLines = 0
        titleLabel.clipsToBounds = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: stateImage.trailingAnchor, constant: 10),
//            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
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
        if !isEnabled {
            toggleEnabled(enabled: true)
        }
    }
    
    func toggleEnabled(enabled: Bool) {
        for view in contentView.subviews {
            view.isUserInteractionEnabled = enabled
            view.alpha = enabled ? 1 : 0.5
        }
        self.isEnabled = enabled
        self.isUserInteractionEnabled = enabled //TODO: Maybe remove so a message can be presented telling the user why its disabled
    }
}

