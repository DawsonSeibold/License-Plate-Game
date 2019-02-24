//
//  PlayersViewController.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 6/18/18.
//  Copyright © 2018 Smile App Development. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class PeerPlayersViewController: UIViewController {

    var gamesTableView: UITableView!
    
    var avalibleGames: [AvaliableGame] = []
    
    var peer: GamePeer!
    
    override func loadView() {
        super.loadView()
        createUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        finalizeUI()
        
        peer = GamePeer()
        peer.delegate = self
        peer.searchForHosts()
    }
    
    // MARK: - UI
    func createUI() {
        gamesTableView = UITableView(frame: view.frame, style: .plain)
        self.view.addSubview(gamesTableView)
    }
    
    func finalizeUI() {
        gamesTableView.delegate = self
        gamesTableView.dataSource = self
        gamesTableView.register(GamesTableViewCell.self, forCellReuseIdentifier: "GameCell")
        
        self.title = "Find Games"
    }
    
    // MARK: - Handle players
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

struct AvaliableGame {
    var mode: GameMode = .Classic
    var host: Player?
    var hostPeer: MCPeerID
}

extension PeerPlayersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return avalibleGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell") as! GamesTableViewCell
        
        let game = avalibleGames[indexPath.row]
        
        cell.nameLabel.text = game.mode.title
        
        cell.hostLabel.text = game.host?.name
        
        return cell
    }

    
}

extension PeerPlayersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

extension PeerPlayersViewController: GamePeerDelegate {
    func presentBrowser(browser: MCBrowserViewController) {
        
    }
    
    func dismissBrowser() {
        
    }
    
    func avaliableGameesDidChange(games: [AvaliableGame]) {
        avalibleGames = games
        gamesTableView.reloadData()
    }
    
    
}
