//
//  Playing.swift
//  Bitminton
//
//  Created by LunarLincoln on 5/16/17.
//  Copyright © 2017 LunarLincoln. All rights reserved.
//

import SpriteKit
import GameplayKit

class Playing: GKState {
    unowned let scene: OnePlayerGameScene
    
    init(scene: SKScene) {
        self.scene = scene as! OnePlayerGameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState is WaitingForTap {
            let ball = scene.childNode(withName: BallCategoryName) as! SKSpriteNode
            ball.physicsBody!.applyImpulse(CGVector(dx: randomDirection(), dy: randomDirection()))
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        let ball = scene.childNode(withName: BallCategoryName) as! SKSpriteNode
        let maxSpeed: CGFloat = 600.0
        
        let xSpeed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx)
        let ySpeed = sqrt(ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)
        
        let speed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx + ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)
        
        //
        ball.physicsBody!.velocity.dx = ball.physicsBody!.velocity.dx*1.014
        ball.physicsBody!.velocity.dy = ball.physicsBody!.velocity.dy*1.014
        
        if xSpeed <= 10.0 {
            ball.physicsBody!.applyImpulse(CGVector(dx: randomDirection(), dy: 0.0))
        }
        if ySpeed <= 10.0 {
            ball.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: randomDirection()))
        }
        
        if speed > maxSpeed {
            ball.physicsBody!.linearDamping = 0.4
        } else {
            ball.physicsBody!.linearDamping = 0.0
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameOver.Type
    }
    
    func randomDirection() -> CGFloat {
        let speedFactor: CGFloat = 50.0
        if scene.randomFloat(from: 0.0, to: 100.0) >= 50 {
            return -speedFactor
        } else {
            return speedFactor
        }
    }
    
}
