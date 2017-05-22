//
//  TwoPlayerGameOver.swift
//  Bitminton
//
//  Created by LunarLincoln on 5/22/17.
//  Copyright © 2017 LunarLincoln. All rights reserved.
//

import SpriteKit
import GameplayKit

class TwoPlayerGameOver: GKState {
    unowned let scene: TwoPlayerGameScene
    
    init(scene: SKScene) {
        self.scene = scene as! TwoPlayerGameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState is Playing{
            let ball = scene.childNode(withName:BallCategoryName) as! SKSpriteNode
            ball.physicsBody!.isDynamic = false
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is TwoPlayerWaitingForTap.Type
    }
    
}
