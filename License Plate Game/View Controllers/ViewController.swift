//
//  ViewController.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 6/15/18.
//  Copyright © 2018 Smile App Development. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var storyboardMain: UIStoryboard? = nil
    
    var gamesCollectionView: UICollectionView!
    
    let manager = GameManager()
    
    var multiplayer: Bool = true
    var games: [ClassicGame] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.title = "License Plate Game"
        
        storyboardMain = UIStoryboard(name: "Main", bundle: nil)
        
        games = GameManager().getSavedGames() ?? []
        createGamesCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        games.removeAll()
        games = GameManager().getSavedGames() ?? []
        if gamesCollectionView != nil {
            gamesCollectionView.reloadData()
        }
    }


    @objc func joinGame() {
        self.navigationController?.pushViewController(PeerPlayersViewController(), animated: true)
    }
    
    @objc func startNewGame() {
        let vc = storyboardMain?.instantiateViewController(withIdentifier: "classicGameSettings")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func startClassicGame() {
        multiplayer = false
        let vc = storyboardMain?.instantiateViewController(withIdentifier: "classicGameSettings") as! ClassicGameSettingsViewController
        vc.multiplayer = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func createGamesCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: self.view.frame.width - 20, height: 165)
        flowLayout.minimumInteritemSpacing = 10
        
        gamesCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        gamesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        gamesCollectionView.backgroundColor = .white
        
        self.view.addSubview(gamesCollectionView)
        
        NSLayoutConstraint.activate([
            gamesCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            gamesCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            gamesCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            gamesCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        gamesCollectionView.delegate = self
        gamesCollectionView.dataSource = self
        gamesCollectionView.register(PlayGameCollectionViewCell.self, forCellWithReuseIdentifier: "playGameCell")
        gamesCollectionView.register(CreateGameCollectionViewCell.self, forCellWithReuseIdentifier: "createGameCell")
        
        let padding: CGFloat = 10
        gamesCollectionView.contentInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "classicGameSettings") {
//            let vc = segue.destination as! ClassicGameSettingsViewController
//            vc.multiplayer = multiplayer
//        }
    }
    
}

extension ViewController: UICollectionViewDelegate {
 
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 { //Create new classic game
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "createGameCell", for: indexPath) as! CreateGameCollectionViewCell
            
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playGameCell", for: indexPath) as! PlayGameCollectionViewCell
            let game = games[indexPath.row - 1]
            
            cell.gameNameLabel.text = game.gameName
            cell.statesFound.text = "\(game.foundStates.count)/\(game.statesList.count)"
            let percentage: Double = Double(game.foundStates.count / game.statesList.count)
            print("Percentage: \(percentage)")
            cell.progressGradient.locations = [percentage, 0.0] as [NSNumber]

            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 { //Create a new game
            startClassicGame()
        }else { //Start a previous game
            let game = games[indexPath.row - 1]
            print("Loading Game: \(game.gameName)")
            let newGame = ClassicGame(settings: game.settings)
            newGame.isLoadingFromSavedGame = true
            newGame.gameName = game.gameName
            newGame.gameID = game.gameID
            
            for player in game.players {
                newGame.addNewPlayer(newPlayer: player)
                for state in player.foundStates {
                    newGame.foundPlateFrom(state: state, player: player)
                }
            }
            newGame.isLoadingFromSavedGame = false
            
            let vc: ClassicGameViewController = ClassicGameViewController()
            vc.currentGame = newGame
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}



