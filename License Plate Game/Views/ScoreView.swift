//
//  Score.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 6/17/18.
//  Copyright © 2018 Smile App Development. All rights reserved.
//

import Foundation
import UIKit

class Scoreboard: UIView {
    
    var playerCollectionView: UICollectionView!
    var draggerView: UIView!
    var vibracyView: UIVisualEffectView!
    var containerView: UIView!
    var height: CGFloat = 100
    let cardHandleHeight: CGFloat = 25
    
    var cardTopConstraint: NSLayoutConstraint!
    
    var players: [Player] = []
    
    //TODO: add a animation of "+3" or however many points was just awarded
    var score: Int = 0 {
        didSet {
            
        }
    }
    
    
    init(frame: CGRect, addStatusBarInset: Bool = true) {
        super.init(frame: frame)
        
        let statusHeight = UIApplication.shared.statusBarFrame.height
        var adjustedFrame = frame
        height = frame.height
        if addStatusBarInset {
            adjustedFrame = CGRect(x: frame.minX, y: statusHeight, width: frame.width, height: frame.height - statusHeight + cardHandleHeight)
        }else {
            adjustedFrame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height + cardHandleHeight)
        }
        self.frame = adjustedFrame
        self.layer.cornerRadius = 12
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        print("Status Height \(UIApplication.shared.statusBarFrame.height)")
        
        self.backgroundColor = .clear
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = frame
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 0.3)
        self.addSubview(blurEffectView)
        NSLayoutConstraint.activate([
            blurEffectView.widthAnchor.constraint(equalTo: self.widthAnchor),
            blurEffectView.heightAnchor.constraint(equalTo: self.heightAnchor),
            
            blurEffectView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            blurEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            
        ])
        
        let vibracyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        vibracyView = UIVisualEffectView(effect: vibracyEffect)
        vibracyView.frame = blurEffectView.frame
        vibracyView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.contentView.addSubview(vibracyView)
        NSLayoutConstraint.activate([
            vibracyView.widthAnchor.constraint(equalTo: blurEffectView.widthAnchor),
            vibracyView.heightAnchor.constraint(equalTo: blurEffectView.heightAnchor),
            
            vibracyView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            vibracyView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            vibracyView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            vibracyView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        createDraggerView()
        
        containerView = UIView(frame: CGRect(x: adjustedFrame.minX, y: adjustedFrame.minY, width: adjustedFrame.width, height: adjustedFrame.height - cardHandleHeight))
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        vibracyView.contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
//            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: statusHeight),
//            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            containerView.topAnchor.constraint(equalTo: draggerView.bottomAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        var size = CGSize(width: 200, height: 90)
        if (players.count == 1) {
            size.width = self.frame.width - 20
        }
        flowLayout.itemSize = size
        
        playerCollectionView = UICollectionView(frame: adjustedFrame, collectionViewLayout: flowLayout)
        playerCollectionView.translatesAutoresizingMaskIntoConstraints = false
    
        containerView.addSubview(playerCollectionView)
        NSLayoutConstraint.activate([
            playerCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
            playerCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            playerCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            playerCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        
        playerCollectionView.delegate = self
        playerCollectionView.dataSource = self
        playerCollectionView.register(PlayerScoreCollectionViewCell.self, forCellWithReuseIdentifier: "playerScoreCell")

        let padding = (adjustedFrame.height - flowLayout.itemSize.height)/2
        playerCollectionView.contentInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        playerCollectionView.backgroundColor = .clear
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createDraggerView() {
        draggerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: cardHandleHeight))
        draggerView.translatesAutoresizingMaskIntoConstraints = false
        draggerView.backgroundColor = .clear//UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        vibracyView.contentView.addSubview(draggerView)
        
        NSLayoutConstraint.activate([
            draggerView.topAnchor.constraint(equalTo: self.topAnchor),
            draggerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            draggerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            draggerView.heightAnchor.constraint(equalToConstant: cardHandleHeight)
        ])
        
        let handle = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 6))
        handle.translatesAutoresizingMaskIntoConstraints = false
        handle.backgroundColor = .gray
        handle.layer.cornerRadius = 3.0
        draggerView.addSubview(handle)
        
        NSLayoutConstraint.activate([
            handle.centerYAnchor.constraint(equalTo: draggerView.centerYAnchor),
            handle.centerXAnchor.constraint(equalTo: draggerView.centerXAnchor),
            handle.widthAnchor.constraint(equalToConstant: 60),
            handle.heightAnchor.constraint(equalToConstant: 8),
        ])
    }
    
    func updatePlayerScoreWidth() {
        let flowLayout = playerCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        if players.count == 1 {
            flowLayout.itemSize.width = playerCollectionView.bounds.size.width
        }else {
            flowLayout.itemSize.width = 200
        }
        playerCollectionView.layoutIfNeeded()
    }
    
    func addPlayerToScoreboard(player: Player) {
        print("Called \(players)")
        
        players.append(player)
        players.sort(by: { $0.score > $1.score })
        
        updatePlayerScoreWidth()
        playerCollectionView.reloadData()
        print("After: \(players)")
    }
    
    func removePlayerFromScoreboard(player: Player) {
        players.remove(at: getIndexOfPlayer(player: player))
        
        updatePlayerScoreWidth()
        playerCollectionView.reloadData()
    }
    
    func updatePlayerScore(updatedPlayers: [Player]) {
        print("Called Update Score")
//        self.players = players
//        self.players.sort(by: { $0.score > $1.score } )
        self.players = updatedPlayers.sorted(by: { $0.score > $1.score })
        playerCollectionView.reloadData()
    }
    
    func updateWinners(players: [Player]) {
        self.players = players.sorted(by: { $0.score > $1.score })
        playerCollectionView.reloadData()
    }
    
    
    func getIndexOfPlayer(player: Player) -> Int {
        var index = 0
        for oldPlayer in players {
            if oldPlayer.identifier == player.identifier {
                return index
            }
            index += 1
        }
        return 0
    }
    
}

extension Scoreboard: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return players.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playerScoreCell", for: indexPath) as! PlayerScoreCollectionViewCell
        
        let player = players[indexPath.row]
        print("player: \(player)")
        
        cell.nameLabel.text = player.name
        cell.scoreLabel.text = "\(player.score)"
        
        if player.isWinning {
            cell.isWinning = true
        }
    
        return cell
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
//        let totalCellWidth = flowLayout.itemSize.width * CGFloat(players.count)
//        let totalSpacingWidth = CGFloat(5 * (players.count - 1))
//        
//        let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
//        let rightInset = leftInset
//        
//        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
//    }
    
}

extension Scoreboard: UICollectionViewDelegate {
    
}



