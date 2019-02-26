//
//  PlayersViewController.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 6/18/18.
//  Copyright © 2018 Smile App Development. All rights reserved.
//

import UIKit

class HostPlayersViewController: UIViewController {

    var playersTableView: UITableView!
    
    var players: [Player] = [] {
        didSet {
            connected.removeAll()
            connecting.removeAll()
            disconnected.removeAll()
            for player in players {
                switch player.connection {
                case .Connected: connected.append(player); break;
                case .Connecting: connecting.append(player); break;
                case .Disconnected: disconnected.append(player); break;
                }
            }
        }
    }
    
    var gameSettings: Any!
    var gameMode: GameMode = .Classic
    
    var sections: [PlayerConnection] = PlayerConnection.allCases
    
    var connecting: [Player] = []
    var connected: [Player] = []
    var disconnected: [Player] = []

    
    var host: GameHost!
    
    override func loadView() {
        super.loadView()
        createUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        finalizeUI()
        
        host = GameHost()
        host.delegate = self
        host.startAdvertising()
    }
    
    // MARK: - UI
    func createUI() {
        playersTableView = UITableView(frame: view.frame, style: .plain)
        self.view.addSubview(playersTableView)
    }
    
    func finalizeUI() {
        playersTableView.delegate = self
        playersTableView.dataSource = self
        playersTableView.register(PlayerTableViewCell.self, forCellReuseIdentifier: "PlayerCell")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start Game", style: .done, target: nil, action: #selector(HostPlayersViewController.continueToGame))
        self.title = "Add Players"
    }
    
    // MARK: - Handle players
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch gameMode {
        case .Classic:
            let vc = segue.destination as! ClassicGameViewController
            vc.currentGame = ClassicGame(settings: (gameSettings as? ClassicGameSettings)!)
        default:
            break;
        }
    }
    
    @objc func continueToGame() {
        self.present(ClassicGameViewController(), animated: true, completion: nil)
    }
    
    func getConnectionTitle(connection: PlayerConnection) -> String {
        switch connection {
        case .Connected: return "Connected Players"
        case .Connecting: return "Connecting Players"
        case .Disconnected: return "Disconnected Players"
        }
    }
    
    func getArrayForConnection(connection: PlayerConnection) -> [Player] {
        switch connection {
        case .Connected: return connected
        case .Connecting: return connecting
        case .Disconnected: return disconnected
        }
    }

}

extension HostPlayersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .Connected:
            return connected.count
        case .Connecting:
            return connecting.count
        case .Disconnected:
            return disconnected.count
        }
//        return players.count// + connectingPlayers.count + disconnectedPlayers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell") as! PlayerTableViewCell

        let player = getArrayForConnection(connection: sections[indexPath.section])[indexPath.row]
        cell.nameLabel.text = player.name

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return getConnectionTitle(connection: sections[section])
    }
    
    
}

extension HostPlayersViewController: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        host.send(data: "Player Tapped", peers: nil)
    }
}

extension HostPlayersViewController: GameHostDelegate {
    
    func presentPeerRequestActionSheet(actionSheet: UIAlertController) {
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func errorStartingAdvertising(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    func dismissPlayersViewController() {
        print("Dismis Players View Controller")
        self.parent?.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Handle connections
    
    func peerIsConnecting(player: Player) {
        if let index = players.index(of: player) {
            players[index].connection = .Connecting
        }
        DispatchQueue.main.sync { playersTableView.reloadData() }
    }
    
    func peerDidConnect(player: Player) {
        print("Did Connect To Peer \(player.name)")
        players.append(player)
        
        playersTableView.reloadData()
    }
    
    func peerDidDisconnect(player: Player) {
        if let index = players.index(of: player) {
            players[index].connection = .Disconnected
        }
        
        DispatchQueue.main.sync { playersTableView.reloadData() }
    }
    
    
    
    
}
