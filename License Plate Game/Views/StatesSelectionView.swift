//
//  StatesSelectionView.swift
//  License Plate Game
//
//  Created by Dawson Seibold on 6/19/18.
//  Copyright © 2018 Smile App Development. All rights reserved.
//

import UIKit

protocol StatesSelectionViewDelegate: class {
//    var selectedStates: String { get }
    func shouldDismiss()
    func selectionDidChange(selected states: [States], selectionView: StatesSelectionView)
}

class StatesSelectionView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var selectedStates: [States] = []
    
    var selectedStatesCollectionView: UICollectionView!
    var statesPicker: UIPickerView!
    var selectStateButton: UIButton!
    var dismissToolbar: UIToolbar!
    
    weak var delegate: StatesSelectionViewDelegate?
    
    let bestFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 350)
    
    var componentsWidth: CGFloat = 10
    
    init() {
        super.init(frame: bestFrame)
        
        self.backgroundColor = UIColor(red: 42/255, green: 45/255, blue: 52/255, alpha: 1.0)//.gray
        
        componentsWidth = UIApplication.shared.statusBarFrame.width/2
        
        // UI
        createDismissToolbar()
        createSelectStateButton()
        createStatesPickerView()
        createStatesCollectionView()
        
        self.bringSubviewToFront(dismissToolbar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func becomeFirstResponder() -> Bool {
        print("First Responsder")
        statesPicker.reloadAllComponents()
        statesPicker.reloadInputViews()
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        print("Resign Responder")
        return true
    }
    
    // MARK: - Handle UI
    private func createStatesCollectionView() {
        let flowLayout = SelectedStateFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: componentsWidth - 20, height: 65)
        
        selectedStatesCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: componentsWidth, height: self.frame.height), collectionViewLayout: flowLayout)
        selectedStatesCollectionView.contentInset = UIEdgeInsets(top: dismissToolbar.frame.height + 10, left: 10, bottom: 10, right: 10)
        self.addSubview(selectedStatesCollectionView)
        selectedStatesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectedStatesCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            selectedStatesCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            selectedStatesCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            selectedStatesCollectionView.trailingAnchor.constraint(equalTo: statesPicker.leadingAnchor)
        ])
        
        selectedStatesCollectionView.delegate = self
        selectedStatesCollectionView.dataSource = self
        selectedStatesCollectionView.register(SelectedStateCollectionViewCell.self, forCellWithReuseIdentifier: "SelectedStateCell")
        
        selectedStatesCollectionView.reloadData()
        
        selectedStatesCollectionView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
    }
    private func createStatesPickerView() {
        print("Width: \(self.frame.width/2)")
        let width = (componentsWidth <= 360) ? componentsWidth : 400
        statesPicker = UIPickerView(frame: CGRect(x: self.frame.midX, y: 0, width: width, height: self.frame.height))
        statesPicker.tintColor = UIColor.white
        statesPicker.delegate = self
        statesPicker.dataSource = self
        self.addSubview(statesPicker)
        statesPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statesPicker.topAnchor.constraint(equalTo: self.topAnchor),
//            statesPicker.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            statesPicker.bottomAnchor.constraint(equalTo: selectStateButton.topAnchor, constant: -10),
            statesPicker.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            statesPicker.widthAnchor.constraint(equalToConstant: width)
        ])
        
        statesPicker.reloadAllComponents()
        statesPicker.backgroundColor = .clear
    }
    
    private func createSelectStateButton() {
        let width = (componentsWidth <= 360) ? componentsWidth : 400
        selectStateButton = UIButton(frame: .zero)
        selectStateButton.addTarget(nil, action: #selector(StatesSelectionView.selectState), for: .touchUpInside)
        selectStateButton.setTitle("Add State", for: .normal)
        
        selectStateButton.layer.cornerRadius = 32
        selectStateButton.layer.borderColor = UIColor.white.cgColor
        selectStateButton.layer.borderWidth = 2
        selectStateButton.backgroundColor = UIColor.Custom.RussianGreen.withAlphaComponent(0.4) //UIColor.gray.withAlphaComponent(0.4)
        selectStateButton.tintColor = UIColor.black
        
        selectStateButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(selectStateButton)
        NSLayoutConstraint.activate([
            selectStateButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            selectStateButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            selectStateButton.heightAnchor.constraint(equalToConstant: 85 - 20),
            selectStateButton.widthAnchor.constraint(equalToConstant: width - 20)
        ])
    }
    
    func createDismissToolbar() {
        dismissToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(StatesSelectionView.dismiss))
        
        dismissToolbar.setItems([flexSpace, doneButton], animated: true)
        dismissToolbar.sizeToFit()
        
        self.addSubview(dismissToolbar)
    }
    
    @objc private func selectState() {
        let row = statesPicker.selectedRow(inComponent: 0)
        let state = States.allCases[row]
        if !selectedStates.contains(state) {
            selectedStates.append(state)
            selectedStatesCollectionView.insertItems(at: [IndexPath(item: selectedStates.count - 1, section: 0)])
//            selectedStatesCollectionView.reloadData()
            delegate?.selectionDidChange(selected: selectedStates, selectionView: self)
            selectedStatesCollectionView.scrollToItem(at: IndexPath(row: selectedStates.count - 1, section: 0), at: UICollectionView.ScrollPosition.bottom , animated: true)
        }else {
            let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.3) {
                self.selectStateButton.transform = CGAffineTransform(translationX: 10, y: 0)
                self.selectStateButton.layer.borderColor = UIColor.Custom.Orange.cgColor
            }
            
            animator.addAnimations({
                self.selectStateButton.transform = CGAffineTransform(translationX: 0, y: 0)
                self.selectStateButton.layer.borderColor = UIColor.white.cgColor
            }, delayFactor: 0.2)
            
            animator.startAnimation()
        }
    }
    
    @objc private func deleteState(sender: UIButton) {
        if let index: Int = sender.layer.value(forKey: "index") as? Int {
            selectedStates.remove(at: index)
            selectedStatesCollectionView.reloadData()
            delegate?.selectionDidChange(selected: selectedStates, selectionView: self)
        }
    }
    
    @objc private func dismiss(sender: UIButton) {
        delegate?.shouldDismiss()
        self.resignFirstResponder()
//        self.removeFromSuperview()
    }
    
    // MARK: - Public Functions (Geters)
    
}

extension StatesSelectionView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { }
}
extension StatesSelectionView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return States.allCases.count }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return States.allCases[row].description }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor : UIColor.white
        ]
        return NSAttributedString(string: States.allCases[row].description, attributes: attributes)
    }
}

extension StatesSelectionView: UICollectionViewDelegate { }
extension StatesSelectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return selectedStates.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedStateCell", for: indexPath) as! SelectedStateCollectionViewCell
        
        let state = selectedStates[indexPath.row]
        cell.stateLabel.text = state.description
        
        cell.deleteButton.layer.setValue(indexPath.row, forKey: "index")
        cell.deleteButton.addTarget(nil, action: #selector(StatesSelectionView.deleteState(sender:)), for: .touchUpInside)
        
        return cell
    }
}

extension StatesSelectionView {
    func formatedStatesString() -> String {
        if selectedStates.count == 0 { return "None" }
        var states = ""
        for (index, state) in selectedStates.enumerated() {
            if index != 0 { states += ", " }
            states += state.description
        }
        return states
    }
}

class SelectedStateFlowLayout: UICollectionViewFlowLayout {
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes()
        attributes.alpha = 0.0
        attributes.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        return attributes
    }
}
