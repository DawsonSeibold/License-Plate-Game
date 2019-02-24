//
//  Game.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 6/16/18.
//  Copyright © 2018 Smile App Development. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol GameDelegate: class { //@objc
    func didUpdateStatesList()
    func beganLoading() //Optional
    func finishedLoading() //Optional
    func playersScoreDidChange(player: Player, newScore: Int) //Optional
    
//    @objc optional func playersScoreDidChange(player: Player, newScore: Int)
}

extension GameDelegate {
    //Optional Funcs
    func playersScoreDidChange(player: Player, newScore: Int) { /*Left blank for optional*/ }
    func beganLoading() {}
    func finishedLoading() {}
}

public class Game: NSObject, NSCoding {

    weak var delegate: GameDelegate?
    
    //Helper UI
    var scoreView: Scoreboard!
    
    ///Current Games Players
    //var players: Dictionary<UUID,Player> = [:]
    var players: [Player] = []
    var winningPlayer: [Player]?
    var highiestScore: Int = 0

    var gameName: String = "Unnamed Game"
    var gameID: UUID = UUID()
    
    
//    var foundStatesDict: Dictionary<State, State> = [:]
    var foundStates: [State] = []
    var statesList: [State] = []
    
    override init() {
        
        delegate?.beganLoading()
        for state in States.allCases {
//            print("State: \(state.description)")
            statesList.append(State(state: state, playable: true))

        }
        
        //Score Board UI
//        let statusHeight = UIApplication.shared.statusBarFrame.height
//        scoreView = Scoreboard(frame: CGRect(x: 0, y: 0, width: 300, height: 100 + statusHeight))
        scoreView = Scoreboard(frame: CGRect(x: 0, y: 0, width: 300, height: 100), addStatusBarInset: false)
    }
    
    // MARK: - Handle UI
    
    
    // MARK: - Handle Players
    ///Add a new player to the current game
    func addNewPlayer(newPlayer: Player) {
        players.append(newPlayer)
        print("Added new player: \(newPlayer.name); Total Players: \(players.count)")
        scoreView.addPlayerToScoreboard(player: newPlayer)
        
//        players[newPlayer.identifier] = newPlayer
//        print("Added new player: \(newPlayer.name); Total Players: \(players.count)")
//        scoreView.addPlayerToScoreboard(player: players[newPlayer.identifier]!)
    }
    
    func removePlayer(_ player: Player) {
        guard let index: Int = players.firstIndex(where: { (playerValue) -> Bool in
            return playerValue.identifier == player.identifier
        }) else { return }
        scoreView.removePlayerFromScoreboard(player: player)
        players.remove(at: index)
        
//        let identifier = player.identifier
//        guard let _ = players[identifier] else { return }
//        scoreView.removePlayerFromScoreboard(player: players[identifier]!)
//        players.removeValue(forKey: identifier)
    }
    
    
    
    // MARK: - Handle States
    func addStateToPlayer(player: Player, state: State, pointsToAward: Int) {
        guard let index: Int = players.firstIndex(where: { (playerValue) -> Bool in
            return playerValue.identifier == player.identifier
        }) else { return }
        players[index].foundStates.append(state)
        players[index].score += pointsToAward
        delegate?.playersScoreDidChange(player: player, newScore: (players[index].score))
        scoreView.updatePlayerScore(updatedPlayers: players)
        
        print("Found States: \(players[index].foundStates ?? []), \(players[index].score ?? 0)")
        foundStates.append(state)
        
        checkIfPlayerBecameWinner(player: player)
        
//        let identifier = player.identifier
//        guard let _ = players[identifier] else { return }
//        players[identifier]?.foundStates.append(state)
//        players[identifier]?.score += pointsToAward
//        delegate?.playersScoreDidChange(player: player, newScore: (players[identifier]?.score)!)
//        scoreView.updatePlayerScore(updatedPlayers: Array(players.values))
//
//        print("Found States: \(players[identifier]?.foundStates ?? []), \(players[identifier]?.score ?? 0)")
//        foundStates.append(state)
//
//        checkIfPlayerBecameWinner(player: players[identifier]!)
    }
    
    
    // MARK: - Handle Score
    func updateWinner() {
        var highScore = 0
        winningPlayer?.removeAll()
        for (index, player) in players.enumerated() {
            if player.score >= highScore && player.score > 0 {
                players[index].isWinning = true
                highScore = player.score
                winningPlayer?.append(player)
            }else {
                players[index].isWinning = false
            }
        }
        print("Winner(s): \(winningPlayer), \(highiestScore)")
        scoreView.updateWinners(players: players)
        
//        for player in players {
//            if player.value.score >= highScore && player.value.score > 0 {
//                players[player.key]?.isWinning = true
//                highScore = player.value.score
//                winningPlayer?.append(player.value)
//            }else {
//                players[player.key]?.isWinning = false
//            }
//        }
//        print("Winner(s): \(winningPlayer), \(highiestScore)")
//        scoreView.updateWinners(players: Array(players.values))
    }
    
    private func checkIfPlayerBecameWinner(player: Player) {
        if player.score >= highiestScore { //New winner or tied
            updateWinner()
        }
    }
    
    
    //MARK: Handle NSCoding
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.highiestScore, forKey: "highestScore")
        aCoder.encode(self.gameName, forKey: "gameName")
        aCoder.encode(self.gameID, forKey: "gameID")
        aCoder.encode(self.foundStates.map { $0.abbreviation }, forKey: "foundStates")
        
//        var stringPlayers = Dictionary<UUID, PlayerExportable>()
//        self.players.forEach { (key, player) in
//            stringPlayers[key] = PlayerExportable(player: player)
//        }
//        aCoder.encode(stringPlayers, forKey: "players")
        
        var stringPlayers: [PlayerExportable] = []
        for player in self.players {
            stringPlayers.append(PlayerExportable(player: player))
        }
        aCoder.encode(stringPlayers, forKey: "players")

        if self.winningPlayer != nil {
            var stringWinningPlayers: [PlayerExportable] = []
            for player in self.winningPlayer! {
                stringWinningPlayers.append(PlayerExportable(player: player))
            }
            aCoder.encode(stringWinningPlayers, forKey: "winningPlayer")
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        if let highestScore = aDecoder.decodeObject(forKey: "highestScore") { self.highiestScore = highestScore as! Int }
        if let gameName = aDecoder.decodeObject(forKey: "gameName") { self.gameName = gameName as! String }
        if let gameID = aDecoder.decodeObject(forKey: "gameID") { self.gameID = gameID as! UUID }
        if let foundStates = aDecoder.decodeObject(forKey: "foundStates") {
            let states: [State] = (foundStates as! [String?]).map {
                if let stateAbbreviation = $0 {
                    if let state = States(abbreviation: stateAbbreviation) { return State(state: state) }
                }
                return State(state: States.alabama)
            }
            self.foundStates = states
        }
        
//        var playersDic = Dictionary<UUID, Player>()
//        if let players = aDecoder.decodeObject(forKey: "players") {
//            (players as! Dictionary<UUID, PlayerExportable>).forEach { (arg) in
//                let (key, player) = arg
//                playersDic[key] = Player(player: player)
//            }
//            self.players = playersDic
//        }

        self.players.removeAll()
        if let players = aDecoder.decodeObject(forKey: "players") {
            for player in players as! [PlayerExportable] {
                self.players.append(Player(player: player))
            }
        }
        
        self.winningPlayer?.removeAll()
        if let winningPlayers = aDecoder.decodeObject(forKey: "winningPlayer") {
            for player in winningPlayers as! [PlayerExportable] {
                self.winningPlayer?.append(Player(player: player))
            }
        }
    }
}


