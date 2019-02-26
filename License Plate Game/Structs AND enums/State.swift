//
//  State.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 6/17/18.
//  Copyright © 2018 Smile App Development. All rights reserved.
//

import Foundation

struct State: Equatable {
    var capital: String!
    var abbreviation: String!
    var name: String!
    
    var isPlayable: Bool = true
    
    var object: States!
    
    //Classic Game Play Values
    var raritie: StateRaritie?
    
    
    init(state: States) {
//        self.capital = state.capital
        self.abbreviation = state.abbreviation
        self.name = state.description
        
        self.object = state
    }
    
    init(state: States, playable: Bool) {
        self.init(state: state)
    
        self.isPlayable = playable
    }

}
