//
//  ViewController.swift
//  BullsAndCows
//
//  Created by Evgenia Galetskaya on 10/15/18.
//  Copyright © 2018 Evgenia Galetskaya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let game = Game.init()
    lazy var numberToGuess = game.randomNumber
    private var bulls = 0
    private var cows = 0
    
    private var inputNumber = ""
    private var resultOfComparing = ""
    
    private var allAttempts = [String]()
    
    private var numberOfRaws = 0
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var bottomScrollViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var guessNumberLabel: UILabel!
    @IBOutlet private weak var newGameButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var sendButton: UIButton!
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserversToKeyboard()
        configureGame()
        configureContentView()
        print(numberToGuess)
    }
    
    private func configureContentView() {
        contentView.backgroundColor = #colorLiteral(red: 1, green: 0.9129201285, blue: 0.5342976985, alpha: 1)
        
        sendButton.isEnabled = true
        newGameButton.isEnabled = true
        
        guessNumberLabel.text = "Guess the Number"
        guessNumberLabel.textColor = UIColor.black
        
        scrollView.keyboardDismissMode = .interactive
        textField.delegate = self
        
        addTapGesture()
    }
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(view.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
    }
    
    private func addObserversToKeyboard() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShowNotification(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHideNotification(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    
    
    
    @objc func keyboardWillShowNotification(notification: NSNotification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let keyboardHeight = keyboardRect.height
        UIView.animate(withDuration: 0.1) {
            self.bottomScrollViewConstraint.constant = keyboardHeight
            self.contentView.layoutIfNeeded()
        }
       
    }
    
    @objc func keyboardWillHideNotification(notification: NSNotification) {
        UIView.animate(withDuration: 0.1) {
            self.bottomScrollViewConstraint.constant = 0
            self.contentView.layoutIfNeeded()
        }
       
        
    }
    
    
    
    
    
    
    private func configureGame() {
        allAttempts.removeAll()
        resultOfComparing = ""
        textField.text = ""
        inputNumber = ""
        tableView.reloadData()
    }
    
    
    private func startNewGame() {
        let game = Game.init()
        numberToGuess = game.randomNumber
        configureGame()
        configureContentView()
        
    }
    
    @IBAction private func sendButtonPressed(_ sender: UIButton) {
        if inputNumber.count == 4 {
            resultOfComparing = self.compareTo(number: inputNumber)
            addNewGuessLine()
            if inputNumber == numberToGuess {
                guessNumberLabel.text = "\(numberToGuess)"
                guessNumberLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                guessNumberLabel.shadowColor = UIColor.darkGray
                sendButton.isEnabled = false
            }
        } else {
            print("Enter 4 numbers")
        }
        inputNumber = ""
    }
    
    
    private func addNewGuessLine() {
        allAttempts.append(resultOfComparing)
        let indexPath = IndexPath(row: allAttempts.count - 1, section: 0)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
        textField.text = ""
        view.endEditing(true)
    }
    
    
    @IBAction private func newGamePressed(_ sender: UIButton) {
        startNewGame()
        print(numberToGuess)
    }
    
    
    
    // comparing 2 numbers & printing the result
    private func compareTo(number: String) -> String {
        bulls = 0
        cows = 0
        for index in number.indices {
            if numberToGuess.contains(number[index]) {
                if numberToGuess[index] == number[index] {
                    bulls += 1
                } else {
                    cows += 1
                }
            }
        }
        return "\(inputNumber) B:\(bulls) C:\(cows)"
    }
    
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRaws = allAttempts.count
        return numberOfRaws
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indexPath = indexPath
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        cell.textLabel?.text = allAttempts[indexPath.row]
        return cell
        
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("should begin editing")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("resign 1st responder")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputNumber = textField.text!
    }
}
