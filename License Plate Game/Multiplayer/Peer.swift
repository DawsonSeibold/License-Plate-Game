//
//  Peer.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 6/18/18.
//  Copyright © 2018 Smile App Development. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import UIKit

protocol GamePeerDelegate: class {
    func presentBrowser(browser: MCBrowserViewController)
    func dismissBrowser()
    func avaliableGameesDidChange(games: [AvaliableGame])
}


class GamePeer: NSObject {
    
    weak var delegate: GamePeerDelegate?
    
    private let gameServiceType = "licence-plate"
    
    let localPeerID = MCPeerID(displayName: UIDevice.current.name)
    
    var avalibleGames: [AvaliableGame] = []
    
    var browser: MCNearbyServiceBrowser!
    var session: MCSession!
    
    override init() {
        super.init()
        
    }

    
    func searchForHosts() {
        session = MCSession(peer: localPeerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: localPeerID, serviceType: gameServiceType)
        browser.delegate = self
        
//        let browserViewController = MCBrowserViewController(browser: browser, session: session)
//        browserViewController.delegate = self
//        browserViewController.title = "Find Game Host"
//        delegate?.presentBrowser(browser: browserViewController)
        browser.startBrowsingForPeers()
    }
}

extension GamePeer: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("Found Host \(peerID.displayName)")
        if let gameDetails = info {
            print("Game Mode: \(gameDetails["gameMode"] ?? "None")")
            
            if let gameModeTitle = gameDetails["gameMode"] {
                if let gameMode = GameMode.modeFromShortTitle(title: gameModeTitle) {
                    let game = AvaliableGame(mode: gameMode, host: Player(playerName: peerID.displayName, playerType: .Owner), hostPeer: peerID)
                    avalibleGames.append(game)
                }else { print("error getting game mode from short title") }
            }else { print("error getting game mode title") }
        }else { print("error getting game details") }
        
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
        self.delegate?.avaliableGameesDidChange(games: avalibleGames)
        browser.stopBrowsingForPeers()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost connection to host")
        for (index, game) in avalibleGames.enumerated() {
            if game.hostPeer == peerID {
                avalibleGames.remove(at: index)
            }
        }
        self.delegate?.avaliableGameesDidChange(games: avalibleGames)
        browser.startBrowsingForPeers()
    }
    
    func browserViewController(_ browserViewController: MCBrowserViewController, shouldPresentNearbyPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Bool {
        return true
    }
    
}

extension GamePeer: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        print("Browser View Controller Did Finnish")
        //update UI
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        print("Browser View Controller Was Cancelled")
        self.delegate?.dismissBrowser()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("Failed to start browsing for peers")
    }

}

extension GamePeer: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connecting:
            print("Peer connecting... \(peerID.displayName)")
//            self.delegate?.peerIsConnecting(player: Player(playerName: peerID.displayName))
            break;
        case .connected:
            print("Peer connected: \(peerID.displayName)")
            break;
        case .notConnected:
            print("Peer disconnected: \(peerID.displayName)")
            for (index, game) in avalibleGames.enumerated() {
                if game.hostPeer == peerID {
                    avalibleGames.remove(at: index)
                }
            }
            DispatchQueue.main.async {
                self.delegate?.avaliableGameesDidChange(games: self.avalibleGames)
            }
//            for (index, player) in players.enumerated() {
//                if player.peerID == peerID {
//                    self.delegate?.peerDidDisconnect(player: player)
//                    players.remove(at: index)
//                    if let peerIndex = peers.index(of: player.peerID!) {
//                        peers.remove(at: peerIndex)
//                    }
//                }
//            }
            break;
        default:
            break;
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let response = String(data: data, encoding: .utf8) {
            print("Received Stream: \(response)")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
}
