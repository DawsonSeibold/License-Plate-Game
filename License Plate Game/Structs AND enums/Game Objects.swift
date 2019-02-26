//
//  Game Objects.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 6/16/18.
//  Copyright © 2018 Smile App Development. All rights reserved.
//

import Foundation
import MultipeerConnectivity

enum GameMode: CustomStringConvertible, CaseIterable {
    case Classic
    
    
    var description: String {
        switch self {
        case .Classic: return "Classic Game"
        default: return "Game"
        }
    }
    var title: String { return description }
    
    var shortTitle: String {
        switch self {
        case .Classic: return "classicMode"
        default: return "Game"
        }
    }
    
    static func valueFromTitle(title: String) -> GameMode? {
        for mode in self.allCases {
            if mode.description == title { return mode }
        }
        return nil
    }
    
    static func modeFromShortTitle(title: String) -> GameMode? {
        for mode in self.allCases {
            if mode.shortTitle == title { return mode }
        }
        return nil
    }
}

enum PlayerType: String {
    case Owner = "owner"
    case Player = "player"
    case Spectator = "spectator"
    
    init?(fromString: String) {
        switch fromString {
        case "owner": self = .Owner
        case "player": self = .Player
        case "spectator": self = .Spectator
        default: return nil
        }
    }
}

enum PlayerConnection: String, CaseIterable  {
    case Connected = "connected"
    case Connecting = "connecting"
    case Disconnected = "disconnected"
    
    init?(fromString: String) {
        switch fromString {
        case "connected": self = .Connected
        case "connecting": self = .Connecting
        case "disconnected": self = .Disconnected
        default: return nil
        }
    }
}

struct Player: Equatable {
    var name: String = "Unnamed Player"
    var identifier: UUID = UUID()
    var type: PlayerType = .Player
    var score: Int = 0
    var isWinning: Bool = false
    var foundStates: [State] = []
    
    var peerID: MCPeerID?
    var connection: PlayerConnection = .Disconnected
    
    init(player: PlayerExportable) {
        self.name = player.name
        self.identifier = UUID(uuidString: player.identifier) ?? UUID()
        self.type = PlayerType(fromString: player.type)!
        self.score = player.score
        self.isWinning = player.isWinning
        self.foundStates = player.foundStates.map { State(state: States(abbreviation: $0)!) }
//        self.peerID = player.peerID
        self.connection = PlayerConnection(fromString: player.connection)!
    }
}
extension Player {
    init(playerName: String, playerType: PlayerType = .Player) {
        self.name = playerName
        self.type = playerType
    }
}

class PlayerExportable: NSObject, NSCoding {
    var name: String = "Unnamed Player"
    var identifier: String = UUID().uuidString
    var type: String = PlayerType.Player.rawValue
    var score: Int = 0
    var isWinning: Bool = false
    var foundStates: [String] = []

//    var peerID: MCPeerID?
    var connection: String = PlayerConnection.Disconnected.rawValue

    init(player: Player) {
        self.name = player.name
        self.identifier = player.identifier.uuidString
        self.type = player.type.rawValue
        self.score = player.score
        self.isWinning = player.isWinning
        print("Found States: \(player.foundStates)")
        self.foundStates = player.foundStates.map {
            print("Abbrevation \($0.abbreviation)")
            return $0.abbreviation
        }
//        self.peerID = player.peerID
        self.connection = player.connection.rawValue
    }
    
    //MARK: Handle NSCoding
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.identifier, forKey: "identifier")
        aCoder.encode(self.type, forKey: "type")
        aCoder.encode(self.score, forKey: "score")
        aCoder.encode(self.isWinning, forKey: "isWinning")
        aCoder.encode(self.foundStates, forKey: "foundStates")
        aCoder.encode(self.connection, forKey: "connection")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        if let name = aDecoder.decodeObject(forKey: "name") { self.name = name as! String }
        if let identifier = aDecoder.decodeObject(forKey: "identifier") { self.identifier = identifier as! String }
        if let type = aDecoder.decodeObject(forKey: "type") { self.type = type as! String }
        if let score = aDecoder.decodeObject(forKey: "score") { self.score = score as! Int }
        if let isWinning = aDecoder.decodeObject(forKey: "isWinning") { self.isWinning = isWinning as! Bool }
        if let foundStates = aDecoder.decodeObject(forKey: "foundStates") { self.foundStates = foundStates as! [String] }
        if let connection = aDecoder.decodeObject(forKey: "connection") { self.connection = connection as! String }
    }
}

//struct PlayerExportable: Equatable {
//    var name: String = "Unnamed Player"
//    var identifier: String = UUID().uuidString
//    var type: String = PlayerType.Player.rawValue
//    var score: Int = 0
//    var isWinning: Bool = false
//    var foundStates: [String] = []
    
//    var peerID: MCPeerID?
//    var connection: String = PlayerConnection.Disconnected.rawValue
    
//    init(player: Player) {
//        self.name = player.name
//        self.identifier = player.identifier.uuidString
//        self.type = player.type.rawValue
//        self.score = player.score
//        self.isWinning = player.isWinning
//        self.foundStates = player.foundStates.map { $0.abbreviation }
//        self.peerID = player.peerID
//        self.connection = player.connection.rawValue
//    }

//}
