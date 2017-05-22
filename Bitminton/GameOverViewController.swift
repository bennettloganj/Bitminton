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
    
    @IBAction func ReplayButton(_ sender: UIButton) {
        
    }
   
    @IBAction func mainMenu(_ sender: UIButton) {
        
    }
    
    @IBOutlet weak var ScoreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ScoreLabel.text = stringPassed
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
