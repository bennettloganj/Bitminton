//
//  GameOver.swift
//  Bitminton
//
//  Created by LunarLincoln on 5/16/17.
//  Copyright © 2017 LunarLincoln. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOver: GKState {
    unowned let scene: OnePlayerGameScene
    
    init(scene: SKScene) {
        self.scene = scene as! OnePlayerGameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState is Playing{
            let ball = scene.childNode(withName:BallCategoryName) as! SKSpriteNode
            ball.physicsBody!.isDynamic = false
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WaitingForTap.Type
    }
    
}
