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
            
            let alertController = UIAlertController(title: "New Highscore", message: "", preferredStyle: .alert)
            
            alertController.addTextField { (textField) in
                textField.placeholder = "Your Name"
                
            }
            
            let doneAction = UIAlertAction(title: "Done", style: .default, handler: { (_)->Void in
                let textField = alertController.textFields![0]
                self.name = textField.text!
            })
            
            alertController.addAction(doneAction)
            
            
            self.present(alertController, animated: true, completion: nil)
            
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
        var nameArray = defaults.array(forKey: "nameArray") as! [String]
        nameArray.append(name)
        nameArray = rearrangeStringArray(array: nameArray, fromIndex: nameArray.count-1, toIndex: count)
        nameArray.remove(at: nameArray.count-1)
        defaults.set(nameArray, forKey: "nameArray")
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

