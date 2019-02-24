//
//  Classic.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 6/16/18.
//  Copyright © 2018 Smile App Development. All rights reserved.
//

import Foundation

class ClassicGame: Game {
    
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
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    
    func foundPlateFrom(state: State, stateIndex: Int, player: Player) {
        if !settings.bannedStates.contains(state.object) {
            if settings.onePlatePerState {
                if foundStates.contains(state) {
                    print("This state has already been found")
                    return
                }
            }
            if !state.isPlayable { print("This state is not playable"); return }
            
            print("Raritie Should Be: \(getStateRaritie(state: state))")
            if settings.legendaryStates.contains(state.object) {
                //Legendary state
                print("Legendary State")
                addStateToPlayer(player: player, state: state, pointsToAward: settings.legendaryStateWorth)
            }else if settings.commonStates.contains(state.object) {
                //Common State
                print("Commong State")
                addStateToPlayer(player: player, state: state, pointsToAward: settings.commonStateWorth)
            }else {
                //Rare State
                print("Rare State")
                addStateToPlayer(player: player, state: state, pointsToAward: settings.rareStateWorth)
            }
            
            if settings.onePlatePerState {
                //Make this state unplayable
//                statesList[stateIndex].isPlayable = false
                if let index = statesList.firstIndex(of: state) {
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
        return settings.bannedStates.contains(state.object)
    }
    
    
    
    
    // MARK: enums
    enum Mode {
        case competitive, cooperative
    }
    
}
