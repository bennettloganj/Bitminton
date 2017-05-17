//
//  WaitingForTap.swift
//  Bitminton
//
//  Created by LunarLincoln on 5/16/17.
//  Copyright © 2017 LunarLincoln. All rights reserved.
//

import SpriteKit
import GameplayKit

class WaitingForTap: GKState {
    unowned let scene: OnePlayerGameScene
    
    init(scene: SKScene) {
        self.scene = scene as! OnePlayerGameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        let scale = SKAction.scale(to: 1.0, duration: 0.25)
        scene.childNode(withName: GameMessageName)!.run(scale)
    }
    
    override func willExit(to nextState: GKState) {
        if nextState is Playing{
            let scale = SKAction.scale(by: 0, duration: 0.4)
            scene.childNode(withName: GameMessageName)!.run(scale)
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is Playing.Type
    }
    
}
