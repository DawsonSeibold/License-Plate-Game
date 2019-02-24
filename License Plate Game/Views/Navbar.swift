//
//  Navbar.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 6/16/18.
//  Copyright © 2018 Smile App Development. All rights reserved.
//

import UIKit

class Navbar { //: UINavigationBar

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var controller: UINavigationController!
    var navBar: UINavigationBar!
    var navItem: UINavigationItem!
    var navFrame: CGRect!
    var navTopView: UIView!
    
    init(barController: UINavigationController, frame: CGRect?, view: UIView, title: String?) {
        controller = barController
        navBar = barController.navigationBar

//        if let givenFrame = frame {
//            navFrame = givenFrame
//        }else {
//            navFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
//        }
//        super.init(frame: navFrame)
        
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        navItem = UINavigationItem()
        if let navTitle = title {
            navItem.title = navTitle
        }
        navBar.setItems([navItem], animated: false)
        
        navTopView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 20))
        navTopView.translatesAutoresizingMaskIntoConstraints = false
        navTopView.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)//self.barTintColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addButtonWith(title: String, style: UIBarButtonItem.Style, target: Any?, action: Selector?, buttonLocation: NavSide) -> UIBarButtonItem {
        //Add Bar Buttons
        let item = UIBarButtonItem(title: title, style: style, target: target, action: action)
        return item
//        addButton(button: item, location: buttonLocation)
    }
    
    func addSystemButton(type: UIBarButtonItem.SystemItem, target: Any?, action: Selector?, buttonLocation: NavSide) {
        let item = UIBarButtonItem(barButtonSystemItem: type, target: target, action: action)
        addButton(button: item, location: buttonLocation)
    }
    
    private func addButton(button: UIBarButtonItem, location: NavSide) {
        switch location {
        case .Left:
            navItem.leftBarButtonItem = button
            break;
        case .Right:
            navItem.rightBarButtonItem = button
            break;
        default:
            navItem.rightBarButtonItem = button
            break;
        }
//        nav.setItems([navItem], animated: true)
    }
    
    enum NavSide {
        case Left, Right
    }
}


//        nav = Navbar(barController: self.navigationController!, frame: nil, view: self.view, title: "Classic Game")
//        nav = Navbar(frame: nil, view: self.view, title: "Classic Game")
//        self.view.addSubview(nav)
//        NSLayoutConstraint.activate([
//            nav.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
//            nav.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            nav.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])

//        self.view.addSubview(nav.navTopView)
//        NSLayoutConstraint.activate([
//            nav.navTopView.topAnchor.constraint(equalTo: view.topAnchor),
//            nav.navTopView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            nav.navTopView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            nav.navTopView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])

//        nav.addButtonWith(title: "Start", style: .done, target: nil, action: #selector(ClassicGameSettingsViewController.startGame), buttonLocation: .Right)
