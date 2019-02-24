//
//  SearchView.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 2/21/19.
//  Copyright © 2019 Smile App Development. All rights reserved.
//

import UIKit

class SearchView: UIView {

    var searchBar: UISearchBar!
    var menuButton: UIButton!
    var vibracyView: UIVisualEffectView!
    var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = frame
//        blurEffectView.backgroundColor = UIColor.Custom.RussianGreen.withAlphaComponent(0.3)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(blurEffectView)
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: self.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        let vibracyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        vibracyView = UIVisualEffectView(effect: vibracyEffect)
        vibracyView.frame = frame
        vibracyView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.contentView.addSubview(vibracyView)
        NSLayoutConstraint.activate([
            vibracyView.topAnchor.constraint(equalTo: blurEffectView.topAnchor),
            vibracyView.bottomAnchor.constraint(equalTo: blurEffectView.bottomAnchor),
            vibracyView.leadingAnchor.constraint(equalTo: blurEffectView.leadingAnchor),
            vibracyView.trailingAnchor.constraint(equalTo: blurEffectView.trailingAnchor)
        ])
        
        let statusHeight = UIApplication.shared.statusBarFrame.height
        
        contentView = UIView(frame: .zero)
        contentView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.backgroundColor = UIColor.Custom.Orange
        self.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: statusHeight),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        menuButton = UIButton(frame: .zero)
        menuButton.setImage( UIImage(named: "Menu_Light"), for: .normal)
        menuButton.addTarget(self.superview, action: #selector(ClassicGameViewController.showMenu), for: .touchUpInside)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(menuButton)
        NSLayoutConstraint.activate([
            menuButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            menuButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
            menuButton.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        searchBar = UISearchBar(frame: .zero)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.tintColor = .black
        searchBar.backgroundColor = .clear
        searchBar.barTintColor = .clear
        searchBar.searchBarStyle = .minimal
        if let inputField = searchBar.input {
            inputField.textColor = .black
            inputField.backgroundColor = UIColor.white
            inputField.borderStyle = .none
            inputField.layer.cornerRadius = 12
            inputField.clipsToBounds = true
        }
        contentView.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            searchBar.trailingAnchor.constraint(equalTo: menuButton.leadingAnchor, constant: 0)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    

}

extension UISearchBar {
    var input: UITextField? {
        return self.value(forKey: "_searchField") as? UITextField
//        return findInputInSubviews(of: self)
    }
    
//    private func findInputInSubviews(of view: UIView) -> UITextField? {
//        guard view.subviews.count > 0 else { return nil }
//        for view in view.subviews {
//            if view.isKind(of: UITextField.self) {
//                return view as? UITextField
//            }
//            let subview = findInputInSubviews(of: view)
//            if subview != nil { return subview }
//        }
//        return nil
//    }
}
