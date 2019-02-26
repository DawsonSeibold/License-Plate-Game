//
//  Classic Game.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 6/16/18.
//  Copyright © 2018 Smile App Development. All rights reserved.
//

import Foundation

enum StateRaritie {
    case Common, Rare, Legendary
}


struct ClassicGameSettings {
    var multiplayer: Bool = false
    var gameName: String = "Unnamed Classic Game"
    var mode: ClassicGame.Mode = .competitive
    var gameLength: String? = nil
    var onePlatePerState: Bool = true
    
    var commonStates: [States] = []
    var legendaryStates: [States] = []
    var bannedStates: [States] = []
    
    ///Scoring
    var commonStateWorth: Int = 1
    var rareStateWorth: Int = 2
    var legendaryStateWorth: Int = 3
    
    init() {
    }
    
    init?(gameSettings: ClassicGameSettingsExportable) {
        self.multiplayer = gameSettings.multiplayer
        self.gameName = gameSettings.gameName
        self.mode = ClassicGame.Mode(fromString: gameSettings.mode)!
        self.gameLength = gameSettings.gameLength
        self.onePlatePerState = gameSettings.onePlatePerState
        
        self.commonStates = gameSettings.commonStates.map { States(abbreviation: $0)! }
        self.legendaryStates = gameSettings.legendaryStates.map { States(abbreviation: $0)! }
        self.bannedStates = gameSettings.bannedStates.map { States(abbreviation: $0)! }
        
        self.commonStateWorth = gameSettings.commonStateWorth
        self.rareStateWorth = gameSettings.rareStateWorth
        self.legendaryStateWorth = gameSettings.legendaryStateWorth
    }
}

class ClassicGameSettingsExportable: NSObject, NSCoding {
    var multiplayer: Bool = false
    var gameName: String = "Unnamed Classic Game"
    var mode: String = ClassicGame.Mode.competitive.rawValue
    var gameLength: String? = nil
    var onePlatePerState: Bool = true
    
    var commonStates: [String] = []
    var legendaryStates: [String] = []
    var bannedStates: [String] = []
    
    ///Scoring
    var commonStateWorth: Int = 1
    var rareStateWorth: Int = 2
    var legendaryStateWorth: Int = 3
    
    init(gameSettings: ClassicGameSettings) {
        self.multiplayer = gameSettings.multiplayer
        self.gameName = gameSettings.gameName
        self.mode = gameSettings.mode.rawValue
        self.gameLength = gameSettings.gameLength
        self.onePlatePerState = gameSettings.onePlatePerState
        
        self.commonStates = gameSettings.commonStates.map {
            print("Abbrevation \($0.abbreviation)")
            return $0.abbreviation
        }
        self.legendaryStates = gameSettings.legendaryStates.map { $0.abbreviation }
        self.bannedStates = gameSettings.bannedStates.map { $0.abbreviation }
        
        self.commonStateWorth = gameSettings.commonStateWorth
        self.rareStateWorth = gameSettings.rareStateWorth
        self.legendaryStateWorth = gameSettings.legendaryStateWorth
    
    }
    
    //MARK: Handle NSCoding
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.multiplayer, forKey: "multiplayer")
        aCoder.encode(self.gameName, forKey: "gameName")
        aCoder.encode(self.mode, forKey: "mode")
        aCoder.encode(self.gameLength, forKey: "gameLength")
        aCoder.encode(self.onePlatePerState, forKey: "onePlatePerState")
        aCoder.encode(self.commonStates, forKey: "commonStates")
        aCoder.encode(self.legendaryStates, forKey: "legendaryStates")
        aCoder.encode(self.bannedStates, forKey: "bannedStates")
        aCoder.encode(self.commonStateWorth, forKey: "commonStateWorth")
        aCoder.encode(self.rareStateWorth, forKey: "rareStateWorth")
        aCoder.encode(self.legendaryStateWorth, forKey: "legendaryStateWorth")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        if let multiplayer = aDecoder.decodeObject(forKey: "multiplayer") { self.multiplayer = multiplayer as! Bool }
        if let gameName = aDecoder.decodeObject(forKey: "gameName") { self.gameName = gameName as! String }
        if let mode = aDecoder.decodeObject(forKey: "mode") { self.mode = mode as! String }
        if let gameLength = aDecoder.decodeObject(forKey: "gameLength") { self.gameLength = gameLength as? String }
        if let onePlatePerState = aDecoder.decodeObject(forKey: "onePlatePerState") { self.onePlatePerState = onePlatePerState as! Bool }
        if let commonStates = aDecoder.decodeObject(forKey: "commonStates") { self.commonStates = commonStates as! [String] }
        if let legendaryStates = aDecoder.decodeObject(forKey: "legendaryStates") { self.legendaryStates = legendaryStates as! [String] }
        if let bannedStates = aDecoder.decodeObject(forKey: "bannedStates") { self.bannedStates = bannedStates as! [String] }
        if let commonStateWorth = aDecoder.decodeObject(forKey: "commonStateWorth") { self.commonStateWorth = commonStateWorth as! Int }
        if let rareStateWorth = aDecoder.decodeObject(forKey: "rareStateWorth") { self.rareStateWorth = rareStateWorth as! Int }
        if let legendaryStateWorth = aDecoder.decodeObject(forKey: "legendaryStateWorth") { self.legendaryStateWorth = legendaryStateWorth as! Int }
    }
}
