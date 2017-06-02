//
//  TwoPlayerGameOverViewController.swift
//  Bitminton
//
//  Created by LunarLincoln on 5/22/17.
//  Copyright © 2017 LunarLincoln. All rights reserved.
//

import UIKit

class TwoPlayerGameOverViewController: UIViewController {
    
    var player1Won: Bool = false
    
    @IBOutlet weak var grayImageView: UIImageView!
    
    @IBOutlet weak var WinnerLabel: UILabel!
    
    @IBAction func menuButton(_ sender: UIButton) {
    }
    @IBAction func ReplayButton(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        grayImageView.layer.cornerRadius = 4.0
        
        if player1Won{
            WinnerLabel.text = "Player 1 Wins"
        }
        else{
            WinnerLabel.text = "Player 2 Wins"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
