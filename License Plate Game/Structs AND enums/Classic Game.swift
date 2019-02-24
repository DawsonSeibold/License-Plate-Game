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
}
