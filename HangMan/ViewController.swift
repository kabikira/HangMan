//
//  ViewController.swift
//  HangMan
//
//  Created by koala panda on 2023/02/19.
//

import UIKit

class ViewController: UITableViewController {
    var words = [String]()
    var usedLetters = [String]()
    var wrongAnswers = 0
    var promptWord = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                words = startWords.components(separatedBy: "\n")
                if promptWord.isEmpty {
                    for _ in 0...words[0].count {
                        promptWord += "?"
                    }
                    title = "\(promptWord),間違えた回数:\(wrongAnswers)"
                } else {
                    title = "\(promptWord),間違えた回数:\(wrongAnswers)"
                }
            }
        }
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedLetters.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Letter", for: indexPath)
        cell.textLabel?.text = usedLetters[indexPath.row]
        return cell
    }
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    func submit(_ answer: String) {
        let upperAnswer = answer.uppercased()
        
        if upperAnswer.count == 1 && upperAnswer != " " {
            if usedLetters.contains(upperAnswer) {
                print("被ってる")
               return
            }
            if words[0].contains(upperAnswer) {
                promptWord = ""
                usedLetters.append(upperAnswer)
                print(usedLetters)

                for letter in words[0] {
                    let strLetter = String(letter)
                    if usedLetters.contains(strLetter) {
                        promptWord += strLetter
                        print(promptWord)
                    } else {
                        promptWord += "?"
                    }
                    
                }
            } else {
                wrongAnswers += 1
                print(wrongAnswers)
            }
            
            viewDidLoad()
        }
        if wrongAnswers == 7 {
            let ac = UIAlertController(title: title, message: "Wrong!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default))
            present(ac, animated: true)
            wrongAnswers = 0
            usedLetters.removeAll()
            promptWord = ""
            viewDidLoad()
            
        }
        if promptWord == words[0] {
            let ac = UIAlertController(title: title, message: "End Of Game", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Done", style: .default))
            present(ac, animated: true)
            wrongAnswers = 0
            usedLetters.removeAll()
            promptWord = ""
            viewDidLoad()
        }
        
        
    }

}

