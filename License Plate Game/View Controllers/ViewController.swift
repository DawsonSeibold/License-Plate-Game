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
    
    var joinGameButton: UIButton!
    var startGameButton: UIButton!
    var startClassicGameButton: UIButton!
    
    var gamesCollectionView: UICollectionView!
    
    let manager = GameManager()
    
    var multiplayer: Bool = true
    var games: [Game] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "License Plate Game"
        
        let viewFrame = view.frame
        let buttonX = viewFrame.midX - 100
//        //Join A Game Button
//        joinGameButton = createStartGameModeButton(frame: CGRect(x: buttonX, y: viewFrame.midY-55, width: 200, height: 50), buttonTittle: "Join A Game", action: #selector(ViewController.joinGame))
//
//        //Start A New Game Button
//        startGameButton = createStartGameModeButton(frame: CGRect(x: buttonX, y: viewFrame.midY+5, width: 200, height: 50), buttonTittle: "Start A New Game", action: #selector(ViewController.startNewGame))
        
        //Classic Game (One Player)
//        startClassicGameButton = createStartGameModeButton(frame: CGRect(x: buttonX, y: viewFrame.midY + 65, width: 200, height: 50), buttonTittle: "Classic Game", action: #selector(ViewController.startClassicGame))
        
        storyboardMain = UIStoryboard(name: "Main", bundle: nil)
        
//        var testSettings = ClassicGameSettings()
//        testSettings.bannedStates = [.alaska, .hawaii]
//        var testGame = ClassicGame(settings: testSettings)
//        testGame.foundStates = [State.init(state: .montana)]
//        testGame.gameName = "Favorite Game"
//
//        games.append(testGame)
//
//        for _ in 0...4 {
//            games.append(ClassicGame(settings: testSettings))
//        }
        
        games = GameManager().getSavedGames() ?? []
        
        createGamesCollectionView()
        
//        manager.loadGame(withName: "test")
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
    
    
    func createStartGameModeButton(frame: CGRect, buttonTittle: String, action: Selector) -> UIButton {
        let gameModeButton = UIButton(type: .roundedRect)
        gameModeButton.frame = frame
        gameModeButton.setTitle(buttonTittle, for: .normal)
        gameModeButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        gameModeButton.layer.cornerRadius = 5
        gameModeButton.layer.borderWidth = 1.5
        gameModeButton.layer.borderColor = UIColor.black.withAlphaComponent(0.8).cgColor
        gameModeButton.setTitleColor(.white, for: .normal)
        
        gameModeButton.addTarget(nil, action: action, for: .touchUpInside)
        self.view.addSubview(gameModeButton)
        
        return gameModeButton
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
        print("Prepare: \(segue.identifier)")
        if (segue.identifier == "classicGameSettings") {
            let vc = segue.destination as! ClassicGameSettingsViewController
            vc.multiplayer = multiplayer
            print("Multiplayer Prepare")
        }
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

            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 { //Create a new game
            startClassicGame()
        }else { //Start a previous game
            let game = games[indexPath.row - 1]
            print("Game: \(game.gameName)")
        }
    }
    
}



