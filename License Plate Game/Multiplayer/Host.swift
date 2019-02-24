//
//  Host.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 6/18/18.
//  Copyright © 2018 Smile App Development. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

protocol GameHostDelegate: class {
    func presentPeerRequestActionSheet(actionSheet: UIAlertController)
    func errorStartingAdvertising(alert: UIAlertController)
    func dismissPlayersViewController()
    
    
    func peerIsConnecting(player: Player)
    func peerDidConnect(player: Player)
    func peerDidDisconnect(player: Player)
}

class GameHost: NSObject {
    
    private let gameServiceType = "licence-plate"
    
    private var blockedPeers: [MCPeerID] = []
    
    weak var delegate: GameHostDelegate?
    
    let localPeerID = MCPeerID(displayName: UIDevice.current.name)

    var peers: [MCPeerID] = []
    var players: [Player] = []
    
    var advertiser: MCNearbyServiceAdvertiser!
    var session: MCSession!
    
    override init() {
        super.init()
        
    }
    
    func startAdvertising() {
        print("Starting Advertising")
        
        advertiser = MCNearbyServiceAdvertiser(peer: localPeerID, discoveryInfo: ["gameMode":GameMode.Classic.shortTitle], serviceType: gameServiceType)
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
    }
    
    func acceptedPeer(peer: MCPeerID) {
        var player = Player(playerName: peer.displayName)
        player.peerID = peer
        player.connection = .Connected
        players.append(player)
        self.peers.append(peer)
        self.delegate?.peerDidConnect(player: player)
        
        send(data: "Test", peers: nil)
    }
    
    /// Send data to peers, pass nil to peers to send the data to all connected peers
    func send(data: String, peers: [MCPeerID]?) {
        var sendToPeers = peers
        if sendToPeers == nil { sendToPeers = session.connectedPeers }
        
        if session.connectedPeers.count > 0 {
            do {
                try session.send(data.data(using: .utf8 )!, toPeers: sendToPeers!, with: .reliable)
            }catch {
                print("Error sending data: \(data)")
            }
        }
    }
    
}

extension GameHost: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("Did Receive Invintation From Peer \(peerID.displayName)")
        
        if blockedPeers.contains(peerID) {
            invitationHandler(false, nil)
            print("A blocked peer tried to connect")
            return
        }
        
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        
        let actionSheet = UIAlertController(title: "\(peerID.displayName) Wants To Play", message: "Do you want to allow \(peerID.displayName) to join the current game?", preferredStyle: .actionSheet)
        //Cancel
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("Cancel")
            invitationHandler(false, nil)
        }))
        //Block Peer
        actionSheet.addAction(UIAlertAction(title: "Block", style: .destructive, handler: { (action) in
            print("Block Peer")
            self.blockedPeers.append(peerID)
            invitationHandler(false, nil)
        }))
        //Accept
        actionSheet.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (action) in
            print("Accept")
            invitationHandler(true, self.session)
            self.acceptedPeer(peer: peerID)
        }))
    
        self.delegate?.presentPeerRequestActionSheet(actionSheet: actionSheet)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("Error Starting to Advertise: \(error.localizedDescription)")
        let alert = UIAlertController(title: "Error Looking For Players", message: "There was an error while trying to look for other players.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            self.delegate?.dismissPlayersViewController()
        }))
    }
    
    
    
}

extension GameHost: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connecting:
            print("Peer connecting... \(peerID.displayName)")
            self.delegate?.peerIsConnecting(player: Player(playerName: peerID.displayName))
            break;
        case .connected:
            print("Peer connected: \(peerID.displayName)")
            break;
        case .notConnected:
            print("Peer disconnected: \(peerID.displayName)")
            for (index, player) in players.enumerated() {
                if player.peerID == peerID {
                    self.delegate?.peerDidDisconnect(player: player)
                    players.remove(at: index)
                    if let peerIndex = peers.index(of: player.peerID!) {
                        peers.remove(at: peerIndex)
                    }
                }
            }
            break;
        default:
            break;
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
}
