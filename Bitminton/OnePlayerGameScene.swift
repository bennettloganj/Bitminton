//
//  GameScene.swift
//  Bitminton
//
//  Created by LunarLincoln on 5/16/17.
//  Copyright © 2017 LunarLincoln. All rights reserved.
//

import SpriteKit
import GameplayKit

let BallCategoryName = "ball"
let PaddleCategoryName = "paddle"
let BlockCategoryName = "block"
let GameMessageName = "gameMessage"

let BallCategory   : UInt32 = 0x1 << 0
let BottomCategory : UInt32 = 0x1 << 1
let PaddleCategory : UInt32 = 0x1 << 3
let BorderCategory : UInt32 = 0x1 << 4

var strikeCount: Int = 0
var scoreCount: Int = 0

class OnePlayerGameScene: SKScene, SKPhysicsContactDelegate {
    
    var isFingerOnPaddle = false
    
    lazy var gameState: GKStateMachine = GKStateMachine(states: [
        WaitingForTap(scene: self),
        Playing(scene: self),
        GameOver(scene: self)])
    
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        
        
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        physicsWorld.contactDelegate = self
        
        let ball = childNode(withName: BallCategoryName) as! SKSpriteNode
        
        let paddle = childNode(withName: PaddleCategoryName) as! SKSpriteNode
        
        let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        addChild(bottom)
        
        bottom.physicsBody!.categoryBitMask = BottomCategory
        ball.physicsBody!.categoryBitMask = BallCategory
        paddle.physicsBody!.categoryBitMask = PaddleCategory
        borderBody.categoryBitMask = BorderCategory
        
        ball.physicsBody!.contactTestBitMask = BottomCategory
        paddle.physicsBody!.contactTestBitMask = BallCategory
        
        let gameMessage = SKSpriteNode(imageNamed: "TapToPlay")
        gameMessage.name = GameMessageName
        gameMessage.position = CGPoint(x: frame.midX, y: frame.midY+50)
        gameMessage.zPosition = 4
        gameMessage.setScale(0.0)
        addChild(gameMessage)
        
        gameState.enter(WaitingForTap.self)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        //let ball = childNode(withName: BallCategoryName) as! SKSpriteNode
        let scoreCounter = childNode(withName: "ScoreCounter") as! SKLabelNode
        
        // 2
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        // 3
        
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {
            print("Hit bottom. First contact has been made.")
            //ball.position = CGPoint(x:0.1 , y:-32.59 )
            print(strikeCount)
            
            let redStrikeOne = childNode(withName: "redStrikeOne") as! SKSpriteNode
            let redStrikeTwo = childNode(withName: "redStrikeTwo") as! SKSpriteNode
            let redStrikeThree = childNode(withName: "redStrikeThree") as! SKSpriteNode
            
            
            
            strikeCount += 1
            
            switch strikeCount {
            case 1:
                redStrikeOne.zPosition = 5
            case 2:
                redStrikeTwo.zPosition = 5
            case 3:
                redStrikeThree.zPosition = 5
                gameState.enter(GameOver.self)
            default:
                break
            }
            
        }else if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == PaddleCategory {
            print("Hit Paddle")
            var scoreValue: Int = Int(scoreCounter.text!)!
            scoreValue += 1
            scoreCounter.text = String(scoreValue)
        }
        
        
        
        
    }
    
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState.currentState {
        case is WaitingForTap:
            gameState.enter(Playing.self)
            isFingerOnPaddle = true
            
        case is Playing:
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            
            if let body = physicsWorld.body(at: touchLocation){
                if body.node!.name == PaddleCategoryName {
                    isFingerOnPaddle = true
                }
            }
            
        default:
            break
        }
     }
    
     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isFingerOnPaddle {
            
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            let previousLocation = touch!.previousLocation(in: self)
            
            let paddle = childNode(withName: PaddleCategoryName) as! SKSpriteNode
            
            let paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            
            /*
            paddleX = max(paddleX, paddle.size.width/2)
            paddleX = min(paddleX, size.width - paddle.size.width/2)
            */
            
            paddle.position = CGPoint(x: paddleX, y: paddle.position.y)
        }
     }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isFingerOnPaddle = false
    }
    
    override func update(_ currentTime: TimeInterval){
        gameState.update(deltaTime: currentTime)
    }
    
    /*func isGameWon() -> Bool{
        
    }*/
    
    func randomFloat(from: CGFloat, to: CGFloat) -> CGFloat {
        let rand: CGFloat = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        return (rand) * (to - from) + from
    }
    
    func randomDirection() -> CGFloat {
        let speedFactor: CGFloat = 50.0
        if randomFloat(from: 0.0, to: 100.0) >= 50 {
            return -speedFactor
        } else {
            return speedFactor
        }
    }
    
}


