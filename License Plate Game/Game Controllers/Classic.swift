//
//  Classic.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 6/16/18.
//  Copyright © 2018 Smile App Development. All rights reserved.
//

import Foundation

class ClassicGame: Game, NSCoding {
    
    var settings: ClassicGameSettings!
    
    init(settings: ClassicGameSettings) {
        super.init()
        self.settings = settings
    
        for (index, state) in statesList.enumerated() {
            statesList[index].raritie = getStateRaritie(state: state)
            if isStateBanned(state: state) { statesList[index].isPlayable = false }
        }
        
        delegate?.finishedLoading()
    }
    
    func foundPlateFrom(state: State, player: Player) {
        if !settings.bannedStates.contains(state.object) {
            if settings.onePlatePerState || isLoadingFromSavedGame == false {
                if foundStates.contains(state) {
                    print("This state has already been found")
                    return
                }
            }
            if !state.isPlayable { print("This state is not playable"); return }
            
            print("Raritie Should Be: \(getStateRaritie(state: state))")
            if settings.legendaryStates.contains(state.object) { //Legendary state
                addStateToPlayer(player: player, state: state, pointsToAward: settings.legendaryStateWorth)
            }else if settings.commonStates.contains(state.object) { //Common State
                addStateToPlayer(player: player, state: state, pointsToAward: settings.commonStateWorth)
            }else { //Rare State
                addStateToPlayer(player: player, state: state, pointsToAward: settings.rareStateWorth)
            }
            
            
            
            if settings.onePlatePerState || isLoadingFromSavedGame == true { //Make this state unplayable
                if let index = statesList.firstIndex(where: { (s) -> Bool in return s.abbreviation == state.abbreviation }) {
                    statesList[index].isPlayable = false
                    delegate?.didUpdateStatesList()
                }
            }
        }else {
            //This state is banned
            print("This state is banned")
        }
    }
    
    func getStateRaritie(state: State) -> StateRaritie {
        if settings == nil { return .Common }
        guard let stateObject = state.object else { return .Common }
        if settings.legendaryStates.contains(stateObject) {
            return .Legendary
        }else if settings.commonStates.contains(stateObject) {
            return .Common
        }else {
            return .Rare
        }
    }
    
    func isStateBanned(state: State) -> Bool {
        if settings == nil { return false }
        return settings.bannedStates.contains(state.object)
    }
    
    // MARK: enums
    enum Mode: String, CaseIterable {
        case competitive = "competitive"
        case cooperative = "cooperative"
        
        init?(fromString: String) {
            switch fromString {
            case "competitive": self = .competitive
            case "cooperative": self = .cooperative
            default: return nil
            }
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
        
        let stringSettings = ClassicGameSettingsExportable(gameSettings: self.settings)
        aCoder.encode(stringSettings, forKey: "settings")
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init()
        
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
        
        if let settings = aDecoder.decodeObject(forKey: "settings") {
            self.settings = ClassicGameSettings(gameSettings: settings as! ClassicGameSettingsExportable)
        }
    }
    
}
