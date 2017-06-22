//
//  TwoPlayerViewController.swift
//  Bitminton
//
//  Created by LunarLincoln on 5/22/17.
//  Copyright © 2017 LunarLincoln. All rights reserved.
//


import UIKit
import SpriteKit

class TwoPlayerGameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = TwoPlayerGameScene(fileNamed:"TwoPlayerGameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.isMultipleTouchEnabled = true
            
            scene.viewController = self
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .fill
            
            skView.presentScene(scene)
            
        }
        
    }
    
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        let skView = self.view as! SKView
        if (skView.scene?.isPaused)! {
            return true
        }
        else {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let skView = self.view as! SKView
        let scene = skView.scene
        
        let p1lastStrike: SKSpriteNode = scene?.childNode(withName: "p1redStrikeThree") as! SKSpriteNode
        
        
        if segue.identifier == "TwoPlayerSegueToGameOver" {
            if let destination = segue.destination as? TwoPlayerGameOverViewController {
                if p1lastStrike.zPosition > 3{
                    destination.player1Won = false
                }
                else{
                    destination.player1Won = true
                }
            }
        }
    }
    
    
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
