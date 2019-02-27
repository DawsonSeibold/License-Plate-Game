
//  ClassicGameViewController.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 6/16/18.
//  Copyright © 2018 Smile App Development. All rights reserved.
//

import UIKit

class ClassicGameViewController: UIViewController {
    
    var scoreView: Scoreboard!
    var searchView: SearchView!
    let manager = GameManager()
    
    var searchBarHeight: CGFloat = 80
    
    weak var statesTableView: UITableView!
    var currentGame: ClassicGame! //Set from settings view controller
    var currentPlayer: Player!
    
    var playableStates: [State] = []
    
    //Card View
    var visualEffectView: UIVisualEffectView!
    var cardHapticFeedback: UIImpactFeedbackGenerator? = nil
    
    let cardHeight: CGFloat = 400
    let cardMinimunHeight: CGFloat = 100
    let cardHandleHeight: CGFloat = 30
    
    var isCardVisable = false
    var nextCardState: CardState {
        return isCardVisable ? .Collapsed : .Expanded
    }
    
    var animationQueue = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0
    
    enum CardState {
        case Expanded
        case Collapsed
    }
    
    override func loadView() {
        super.loadView()
        currentGame.delegate = self
        playableStates = currentGame.statesList
        
        createUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var playerAlreadyAdded = false
        let playerName = NSFullUserName()
        for player in currentGame.players {
            if player.name == playerName {
                playerAlreadyAdded = true
                currentPlayer = player
                break
            }
        }
        if !playerAlreadyAdded {
            currentPlayer = Player(playerName: playerName, playerType: .Owner)
            currentGame.addNewPlayer(newPlayer: currentPlayer)
        }
        
//        currentGame.addNewPlayer(newPlayer: Player(playerName: "Diane"))
//        currentGame.addNewPlayer(newPlayer: Player(name: "Jackson", identifier: UUID(), type: PlayerType.Player , score: 2, isWinning: true, foundStates: []))
//        currentGame.addNewPlayer(newPlayer: currentPlayer)
        
        finalizeUI()
        
        if (currentGame != nil) { manager.save(game: currentGame) }
    }
    
    func createUI() {
        createStatesTableView()
        createScoreView()
        createSearchView()
    }
    
    func finalizeUI() {
        statesTableView.delegate = self
        statesTableView.dataSource = self
        statesTableView.register(ClassicStateTableViewCell.self, forCellReuseIdentifier: "ClassicGameStateCell")
    }
    
    func setupScoreCard() {
        visualEffectView = UIVisualEffectView(frame: self.view.frame)
        visualEffectView.isUserInteractionEnabled = false
        self.view.addSubview(visualEffectView)
        
        let visualTap = UITapGestureRecognizer(target: self, action: #selector(ClassicGameViewController.handleCardTap(recognizer:)))
        visualEffectView.addGestureRecognizer(visualTap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ClassicGameViewController.handleCardTap(recognizer:)))
        tap.cancelsTouchesInView = false
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ClassicGameViewController.handleCardPan(recognizer:)))
        pan.cancelsTouchesInView = false
        
        currentGame.scoreView.addGestureRecognizer(tap)
        currentGame.scoreView.addGestureRecognizer(pan)
        
        cardHapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    }
    
    func createScoreView() {
        setupScoreCard()
        
        view.addSubview(currentGame.scoreView)
        NSLayoutConstraint.activate([
            currentGame.scoreView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            currentGame.scoreView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            currentGame.scoreView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
        currentGame.scoreView.cardTopConstraint = currentGame.scoreView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height - (cardMinimunHeight + cardHandleHeight))
        currentGame.scoreView.cardTopConstraint.isActive = true
    }
    
    func createStatesTableView() {
        let width = view.frame.width - ( view.safeAreaInsets.left + view.safeAreaInsets.right )
        let height = view.frame.height - ( view.safeAreaInsets.top + view.safeAreaInsets.bottom )
        let tableView = UITableView(frame: CGRect(x: view.safeAreaInsets.left, y: view.safeAreaInsets.top, width: width, height: height), style: UITableView.Style.plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.keyboardDismissMode = .onDrag
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
            ])
        statesTableView = tableView
        statesTableView.contentInset = UIEdgeInsets(top: self.view.safeAreaInsets.top + searchBarHeight, left: 0, bottom: (cardMinimunHeight + cardHandleHeight), right: 0)
    }
    
    func createSearchView() {
        searchView = SearchView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: searchBarHeight))
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.searchBar.delegate = self
        self.view.addSubview(searchView)
        NSLayoutConstraint.activate([
            searchView!.topAnchor.constraint(equalTo: self.view.topAnchor),
            searchView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            searchView!.heightAnchor.constraint(equalToConstant: searchBarHeight)
        ])
    }
    
    @objc func handleCardTap(recognizer: UITapGestureRecognizer) {
        cardHapticFeedback?.prepare()
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextCardState, duration: 0.9)
        default:
            break
        }
    }
    
    @objc func handleCardPan(recognizer: UIPanGestureRecognizer) {
        cardHapticFeedback?.prepare()
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextCardState, duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: self.currentGame.scoreView.draggerView)
            var fractionComplete = translation.y / (cardHeight + cardHandleHeight)
            fractionComplete = isCardVisable ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break;
        }
    }
    
    func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        if animationQueue.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .Expanded:
                    //self.currentGame.scoreView.frame.origin.y = self.view.frame.height - self.cardHeight
                    self.currentGame.scoreView.cardTopConstraint.constant = self.view.frame.height - (self.cardHeight + self.cardHandleHeight)
                case .Collapsed:
                    //self.currentGame.scoreView.frame.origin.y = self.view.frame.height - self.cardHandleHeight - self.cardMinimunHeight
                    self.currentGame.scoreView.cardTopConstraint.constant = self.view.frame.height - (self.cardMinimunHeight + self.cardHandleHeight)
                }
                self.view.layoutIfNeeded()
            }
            
            frameAnimator.addCompletion { (_) in
                self.isCardVisable.toggle()
                self.animationQueue.removeAll()
                self.cardHapticFeedback?.impactOccurred()
            }
            
            frameAnimator.startAnimation()
            animationQueue.append(frameAnimator)
            
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .Expanded:
                    let blur = UIBlurEffect(style: .dark)
                    self.visualEffectView.effect = blur
                case .Collapsed:
                    self.visualEffectView.effect = nil
                }
            }
            
            blurAnimator.addCompletion { (_) in
                switch state {
                case .Expanded: self.visualEffectView.isUserInteractionEnabled = true
                case .Collapsed: self.visualEffectView.isUserInteractionEnabled = false
                }
            }
            
            blurAnimator.startAnimation()
            animationQueue.append(blurAnimator)
        }
    }
    
    func startInteractiveTransition(state: CardState, duration: TimeInterval) {
        if animationQueue.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        
        for animator in animationQueue {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in animationQueue {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition() {
        for animator in animationQueue {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    @objc func showMenu() {
        let alert = UIAlertController(title: "Menu", message: "Choose one of the options below.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Rename Game", style: .default, handler: { (action) in
            let nameAlert = UIAlertController(title: "Rename Game", message: "", preferredStyle: .alert)
            nameAlert.addTextField(configurationHandler: { (textfield) in
                textfield.placeholder = "Game Name"
                textfield.autocapitalizationType = .words
            })
            nameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            nameAlert.addAction(UIAlertAction(title: "Rename", style: .default, handler: { (action: UIAlertAction) in
                if let textFields = nameAlert.textFields {
                    if let textField = textFields.first {
                        if let text = textField.text {
                            self.currentGame.gameName = text
                        }
                    }
                }
            }))
            self.present(nameAlert, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Save Game", style: .default , handler: { (action) in
            GameManager().save(game: self.currentGame)
        }))
        alert.addAction(UIAlertAction(title: "Quit Game", style: .destructive , handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.width, y: self.view.bounds.height, width: 1.0, height: 1.0)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent //.default for black style
    }
    
    private func sortStates(by string: String) -> [State] {
        
        if string.isEmpty || string.replacingOccurrences(of: " ", with: "") == "" {
            return currentGame.statesList
        }
        
        return currentGame.statesList.filter { (state) -> Bool in
            if let name = state.name {
                let text: NSString = name as NSString
                let range = text.range(of: string, options: .caseInsensitive)
                return range.location != NSNotFound
            }
            return false
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ClassicGameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playableStates.count //currentGame.statesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stateCell = tableView.dequeueReusableCell(withIdentifier: "ClassicGameStateCell", for: indexPath) as! ClassicStateTableViewCell
        
        let state = playableStates[indexPath.row] //currentGame.statesList[indexPath.row]
        stateCell.nameLabel.text = state.name
        stateCell.stateImage.image = UIImage(named: state.name.lowercased())
        if !state.isPlayable {
            stateCell.toggleEnabled(enabled: false)
        }
        
        return stateCell
    }
}

extension ClassicGameViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state = playableStates[indexPath.row]
        currentGame.foundPlateFrom(state: state, player: currentPlayer)
    }
    
}

extension ClassicGameViewController: GameDelegate {
    func didUpdateStatesList() {
        if let searchText = searchView.searchBar.text {
            playableStates = sortStates(by: searchText)
            statesTableView.reloadData()
        }
    }
    func playersScoreDidChange(player: Player, newScore: Int) {
        if player.identifier == currentPlayer.identifier {
            //Current player score just changed
        }
    }
    
    // MARK: - Game Delegate UI
    func beganLoading() {
//        activityView.startAnimating()
    }
    
    func finishedLoading() {
//        activityView.stopAnimating()
    }
    
}

extension ClassicGameViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        playableStates = sortStates(by: searchText)
        statesTableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        playableStates = currentGame.statesList
//        statesTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        playableStates = currentGame.statesList
        statesTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchView.searchBar.endEditing(true)
    }
}


