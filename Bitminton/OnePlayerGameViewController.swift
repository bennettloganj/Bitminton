//
//  OnePlayerGameViewController.swift
//  Bitminton
//
//  Created by LunarLincoln on 5/16/17.
//  Copyright © 2017 LunarLincoln. All rights reserved.
//

import UIKit
import SpriteKit

class OnePlayerGameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = OnePlayerGameScene(fileNamed:"OnePlayerGameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            scene.viewController = self
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFit
            
            skView.presentScene(scene)
            
        }
        
        if shouldPerformSegue(withIdentifier: "SegueToGameOver", sender: self) {
            performSegue(withIdentifier: "SegueToGameOver", sender: self)
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
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
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


/*
 to reset a gameplay scene
 supposed to be in scene that you are trying to restart
 
 https://developerplayground.net/pong_swift_playground_ipad/
 
let scene = GameScene(size: self.size) // Whichever scene you want to restart (and are in)
let animation = SKTransition.crossFade(withDuration: 0.5) // ...Add transition if you like
self.view?.presentScene(scene, transition: animation)
 
 
 if (skView.scene?.isPaused)! {
 performSegue(withIdentifier: "SegueToGameOver", sender: self)
 }
*/
