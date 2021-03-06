//
//  GameOverViewController.swift
//  Bitminton
//
//  Created by LunarLincoln on 5/18/17.
//  Copyright © 2017 LunarLincoln. All rights reserved.
//

import UIKit




class GameOverViewController: UIViewController {
    
    var stringPassed: String = ""
    var name:String = ":("
    var isHighScore:Bool = false
    var count:Int = 0
    var isHighScoreEntered: Bool?
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var grayImageView: UIImageView!
    
    @IBAction func ReplayButton(_ sender: UIButton) {
    }
    
    @IBAction func mainMenu(_ sender: UIButton) {
    }
    
    @IBOutlet weak var ScoreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        grayImageView.layer.cornerRadius = 4.0
        ScoreLabel.text = stringPassed
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        if isHighScore {
            if !isHighScoreEntered!{
            
                let alertController = UIAlertController(title: "New Highscore", message: "", preferredStyle: .alert)
            
                alertController.addTextField { (textField) in
                    textField.placeholder = "Your Name"
                    textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
                }
                
                let doneAction = UIAlertAction(title: "Done", style: .default, handler: { (_)->Void in
                    let textField = alertController.textFields![0]
                    self.name = textField.text!
                })
            
            
                let shareAction = UIAlertAction(title: "Share", style: .default, handler: { (_)->Void in
                    let textField = alertController.textFields![0]
                    self.name = textField.text!
                    let string = "I just scored \(self.stringPassed) in Bitminton!"
                    let shareCard = UIImage(named: "Share Card")
                
                    let activityViewController = UIActivityViewController(activityItems: [string, shareCard!], applicationActivities: nil)
                    activityViewController.excludedActivityTypes = [
                        UIActivityType.addToReadingList,
                        UIActivityType.airDrop,
                        UIActivityType.assignToContact,
                        UIActivityType.copyToPasteboard,
                        UIActivityType.openInIBooks,
                        UIActivityType.print,
                        UIActivityType.saveToCameraRoll
                    ]
                
                    self.present(activityViewController, animated: true, completion: nil)
                
                })
            
                doneAction.isEnabled = false
                shareAction.isEnabled = false
            
                alertController.addAction(shareAction)
                alertController.addAction(doneAction)
            
            
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
    }
    
    func textChanged(_ sender: Any) {
        let textField = sender as! UITextField
        var resp : UIResponder! = textField
        while !(resp is UIAlertController) { resp = resp.next }
        let alert = resp as! UIAlertController
        alert.actions[0].isEnabled = (textField.text != "")
        alert.actions[1].isEnabled = (textField.text != "")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if !isHighScoreEntered!{
            var nameArray = defaults.array(forKey: "nameArray") as! [String]
            nameArray.append(name)
            nameArray = rearrangeStringArray(array: nameArray, fromIndex: nameArray.count-1, toIndex: count)
            nameArray.remove(at: nameArray.count-1)
            defaults.set(nameArray, forKey: "nameArray")
            isHighScoreEntered = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rearrangeStringArray(array: [String], fromIndex: Int, toIndex: Int) -> [String] {
        
        var temp = array
        let item = temp.remove(at: fromIndex)
        temp.insert(item, at: toIndex)
        
        return temp
    }
    
    
}

