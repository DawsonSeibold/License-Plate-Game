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

public class Game: NSObject {

    weak var delegate: GameDelegate?
    
    //Helper UI
    var scoreView: Scoreboard!
    
    ///Current Games Players
    var players: [Player] = []
    var winningPlayer: [Player]?
    var highiestScore: Int = 0

    var gameName: String = "Unnamed Game"
    var gameID: UUID = UUID()
    
    var isLoadingFromSavedGame = false
    
    var foundStates: [State] = []
    var statesList: [State] = []
    
    override init() {
        
        delegate?.beganLoading()
        for state in States.allCases {
            statesList.append(State(state: state, playable: true))
        }
        
        //Score Board UI
        scoreView = Scoreboard(frame: CGRect(x: 0, y: 0, width: 300, height: 100), addStatusBarInset: false)
    }
    
    // MARK: - Handle UI
    
    
    // MARK: - Handle Players
    ///Add a new player to the current game
    func addNewPlayer(newPlayer: Player) {
        players.append(newPlayer)
        scoreView.addPlayerToScoreboard(player: newPlayer)
    }
    
    func removePlayer(_ player: Player) {
        guard let index: Int = players.firstIndex(where: { (playerValue) -> Bool in
            return playerValue.identifier == player.identifier
        }) else { return }
        scoreView.removePlayerFromScoreboard(player: player)
        players.remove(at: index)
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
        
        foundStates.append(state)
        
        checkIfPlayerBecameWinner(player: player)
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
        scoreView.updateWinners(players: players)
    }
    
    private func checkIfPlayerBecameWinner(player: Player) {
        if player.score >= highiestScore { //New winner or tied
            updateWinner()
        }
    }
    
}


