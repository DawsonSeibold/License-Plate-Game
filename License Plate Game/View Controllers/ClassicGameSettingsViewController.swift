//
//  ClassicGameSettingsViewController.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 6/16/18.
//  Copyright © 2018 Smile App Development. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ClassicGameSettingsViewController: UITableViewController {

    var settings: ClassicGameSettings!
    var multiplayer: Bool = true
    var statePicker: UIPickerView!
    
    var selectStatesViews: [StatesSelectionView] = []
    
    @IBOutlet weak var commonStatesPointsLabel: UILabel!
    @IBOutlet weak var legendaryStatesPointsLabel: UILabel!
    @IBOutlet weak var rareStatesPointsLabel: UILabel!
    
    @IBOutlet weak var commonStatesLabel: UITextField!
    @IBOutlet weak var legendaryStatesLabel: UITextField!
    @IBOutlet weak var bannedStatesLabel: UITextField!
    
    override func loadView() {
        super.loadView()
        settings = ClassicGameSettings()
        
        createUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Classic Game"
        settings.multiplayer = multiplayer
        
        finalizeUI()
        
    }
    
    // MARK: - UI
    func createUI() {
        initStatesSelectionView()
        
        //Navigation Bar
        let startButton = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(ClassicGameSettingsViewController.startGame))
        self.navigationItem.rightBarButtonItem = startButton
    }
    
    func finalizeUI() {
        let tap = UITapGestureRecognizer(target: nil, action: #selector(ClassicGameSettingsViewController.hideInputViews))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    
        self.tableView.keyboardDismissMode = .onDrag
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideInputViews()
    }
    
    func initStatesSelectionView() {
        for index in 0...3 {
            let selctionView = StatesSelectionView()
            selctionView.delegate = self
            
            switch index {
            case 0: commonStatesLabel.inputView = selctionView
            case 1: legendaryStatesLabel.inputView = selctionView
            case 2: bannedStatesLabel.inputView = selctionView
            default: break;
            }
            selectStatesViews.append(selctionView)
        }
    }

    // MARK: - Hide Input View
    @objc func hideInputViews() {
        commonStatesLabel.resignFirstResponder()
        legendaryStatesLabel.resignFirstResponder()
        bannedStatesLabel.resignFirstResponder()
        self.becomeFirstResponder()
    }

    @objc func startGame() {
        if (settings.multiplayer) {
            self.navigationController?.pushViewController(HostPlayersViewController(), animated: true)
        }else { //Not multiplayer, don't show the multiplayer screen
            let vc: ClassicGameViewController = ClassicGameViewController()
            vc.currentGame = ClassicGame(settings: settings)
            self.present(vc, animated: true, completion: {
                if let navigationController = self.navigationController {
                    navigationController.popToRootViewController(animated: false)
                }
            })
        }
    }
    
    // MARK: - Changes
    @IBAction func gameNameDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        settings.gameName = text
    }
    @IBAction func modeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: settings.mode = .competitive
            break;
        case 1: settings.mode = .cooperative
            break;
        default:
            settings.mode = .cooperative
        }
    }
    @IBAction func OnePerStateChanged(_ sender: UISwitch) {
        settings.onePlatePerState = sender.isOn
    }
    @IBAction func pointsForCommonChanged(_ sender: UIStepper) {
        settings.commonStateWorth = Int(sender.value)
        commonStatesPointsLabel.text = String(Int(sender.value))
    }
    @IBAction func pointsForRareChanged(_ sender: UIStepper) {
        settings.rareStateWorth = Int(sender.value)
        rareStatesPointsLabel.text = String(Int(sender.value))
    }
    @IBAction func pointsForLegendaryChanged(_ sender: UIStepper) {
        settings.legendaryStateWorth = Int(sender.value)
        legendaryStatesPointsLabel.text = String(Int(sender.value))
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (settings.multiplayer) {
            let vc = segue.destination as! HostPlayersViewController
            vc.gameSettings = settings
            vc.gameMode = .Classic
        }else {
            let vc = segue.destination as! ClassicGameViewController
            let game = ClassicGame(settings: settings)
            vc.currentGame = game
        }
    }

}

extension ClassicGameSettingsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.superview?.tag {
        case 0:
            commonStatesLabel.text = States.all[row].description
            break;
        case 1:
            legendaryStatesLabel.text = States.all[row].description
            break;
        case 2:
            bannedStatesLabel.text = States.all[row].description
            break;
        default:
            break;
        }
    }
}

extension ClassicGameSettingsViewController: GamePeerDelegate {
    func avaliableGameesDidChange(games: [AvaliableGame]) {
        
    }
    
    func presentBrowser(browser: MCBrowserViewController) {
        print("Present Browser View Controller")
        self.present(browser, animated: true, completion: nil)
    }
    
    func dismissBrowser() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ClassicGameSettingsViewController: StatesSelectionViewDelegate {
    
    func selectionDidChange(selected states: [States], selectionView: StatesSelectionView) {
        let selectedStatesString = selectionView.formatedStatesString()
        let selectedStates = selectionView.selectedStates
        
//        let globalSelectionView = self.selectStatesViews.first { (view) -> Bool in return view == selectionView }
//        if globalSelectionView == nil { return }
        
        if selectionView == selectStatesViews[0] {
            commonStatesLabel.text = selectedStatesString
            settings.commonStates = selectedStates
        }else if selectionView == selectStatesViews[1] {
            legendaryStatesLabel.text = selectedStatesString
            settings.legendaryStates = selectedStates
        }else if selectionView == selectStatesViews[2] {
            bannedStatesLabel.text = selectedStatesString
            settings.bannedStates = selectedStates
        }
        
//        switch globalSelectionView!.superview?.tag {
//        case 0:
//            commonStatesLabel.text = selectedStatesString
//            settings.commonStates = selectedStates
//            break;
//        case 1:
//            legendaryStatesLabel.text = selectedStatesString
//            settings.legendaryStates = selectedStates
//            break;
//        case 2:
//            bannedStatesLabel.text = selectedStatesString
//            settings.bannedStates = selectedStates
//            break;
//        default:
//            break;
//        }
    }
    
    func shouldDismiss() {
        hideInputViews()
    }
    
}
