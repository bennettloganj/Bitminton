//
//  TwoPlayerGameScene.swift
//  Bitminton
//
//  Created by LunarLincoln on 5/22/17.
//  Copyright © 2017 LunarLincoln. All rights reserved.
//

import SpriteKit
import GameplayKit

private var p1strikeCount: Int = 0
private var p2strikeCount: Int = 0
private var strikeChange: Bool = false

class TwoPlayerGameScene: SKScene, SKPhysicsContactDelegate {

    var isFingerOnPaddle1 = false
    var isFingerOnPaddle2 = false
    var viewController: UIViewController?
    
    var selectedNodes: [UITouch:SKSpriteNode] = [:]

    let Paddle1CategoryName = "paddle1"
    let Paddle2CategoryName = "paddle2"
    
    let BallCategory   : UInt32 = 0x1 << 0
    let BottomCategory : UInt32 = 0x1 << 1
    let TopCategory : UInt32 = 0x1 << 2
    let BorderCategory : UInt32 = 0x1 << 3
    let Paddle1Category : UInt32 = 0x1 << 4
    let Paddle2Category : UInt32 = 0x1 << 5
    let UpperHalfCategory : UInt32 = 0x1 << 6
    let LowerHalfCategory : UInt32 = 0x1 << 7
    
    lazy var gameState: GKStateMachine = GKStateMachine(states: [
        TwoPlayerWaitingForTap(scene: self),
        TwoPlayerPlaying(scene: self),
        TwoPlayerGameOver(scene: self)])
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        
        
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        physicsWorld.contactDelegate = self
        
        let ball = childNode(withName: BallCategoryName) as! SKSpriteNode
        let birdieImageData = defaults.data(forKey: "currentPlayBirdie")
        let birdieImage = UIImage(data: birdieImageData!, scale: 1.0)
        
        let balltexture = SKTexture(image: (birdieImage?.circleMasked!)!)
        
        
        ball.texture = balltexture
        
        
        let paddle1 = childNode(withName: Paddle1CategoryName) as! SKSpriteNode
        let paddle2 = childNode(withName: Paddle2CategoryName) as! SKSpriteNode
        
        let lowerHalf = childNode(withName: "lowerHalf") as! SKSpriteNode
        let upperHalf = childNode(withName: "upperHalf") as! SKSpriteNode
        
        let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 0.001)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        addChild(bottom)
        
        let topRect = CGRect(x: frame.minX, y: frame.maxY, width: frame.size.width, height: 0.001)
        let top = SKNode()
        top.physicsBody = SKPhysicsBody(edgeLoopFrom: topRect)
        addChild(top)
        
        bottom.physicsBody!.categoryBitMask = BottomCategory
        top.physicsBody!.categoryBitMask = TopCategory
        ball.physicsBody!.categoryBitMask = BallCategory
        paddle1.physicsBody!.categoryBitMask = Paddle1Category
        paddle2.physicsBody!.categoryBitMask = Paddle2Category
        borderBody.categoryBitMask = BorderCategory
        lowerHalf.physicsBody!.categoryBitMask = LowerHalfCategory
        upperHalf.physicsBody!.categoryBitMask = UpperHalfCategory
        
        ball.physicsBody!.contactTestBitMask = BottomCategory | TopCategory
        paddle1.physicsBody!.contactTestBitMask = BallCategory
        paddle2.physicsBody!.contactTestBitMask = BallCategory
        
        ball.physicsBody!.collisionBitMask = BottomCategory | TopCategory | Paddle1Category | Paddle2Category | BorderCategory
        
        ball.physicsBody!.usesPreciseCollisionDetection = true
        bottom.physicsBody!.usesPreciseCollisionDetection = true
        top.physicsBody!.usesPreciseCollisionDetection = true
        
        let gameMessage = SKSpriteNode(imageNamed: "TapToPlay")
        gameMessage.name = GameMessageName
        gameMessage.position = CGPoint(x: frame.midX, y: frame.midY+50)
        gameMessage.zPosition = 4
        gameMessage.setScale(0.0)
        addChild(gameMessage)
        
        gameState.enter(TwoPlayerWaitingForTap.self)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {
            print("Hit bottom. Player One Strike")
            
            
            
            print(p1strikeCount)
            
            let p1redStrikeOne = childNode(withName: "p1redStrikeOne") as! SKSpriteNode
            let p1redStrikeTwo = childNode(withName: "p1redStrikeTwo") as! SKSpriteNode
            let p1redStrikeThree = childNode(withName: "p1redStrikeThree") as! SKSpriteNode
            
            
            
            p1strikeCount += 1
            
            switch p1strikeCount {
            case 2:
                p1redStrikeOne.zPosition = 5
                strikeChange = true
            case 4:
                p1redStrikeTwo.zPosition = 5
                strikeChange = true
            case 6:
                p1redStrikeThree.zPosition = 5
                strikeChange = true
                gameState.enter(TwoPlayerGameOver.self)
            default:
                break
            }
            
        }else if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == TopCategory{
            print("Hit top. Player Two Strike")
            
            
            
            print(p2strikeCount)
            
            let p2redStrikeOne = childNode(withName: "p2redStrikeOne") as! SKSpriteNode
            let p2redStrikeTwo = childNode(withName: "p2redStrikeTwo") as! SKSpriteNode
            let p2redStrikeThree = childNode(withName: "p2redStrikeThree") as! SKSpriteNode
            
            
            
            p2strikeCount += 1
            
            switch p2strikeCount {
            case 2:
                p2redStrikeOne.zPosition = 5
                strikeChange = true
            case 4:
                p2redStrikeTwo.zPosition = 5
                strikeChange = true
            case 6:
                p2redStrikeThree.zPosition = 5
                strikeChange = true
                gameState.enter(TwoPlayerGameOver.self)
            default:
                break
            }
        }
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState.currentState {
        case is TwoPlayerWaitingForTap:
            gameState.enter(TwoPlayerPlaying.self)
            isFingerOnPaddle1 = true
            isFingerOnPaddle2 = true
            
        case is TwoPlayerPlaying:
            for touch in touches {
                let touchLocation = touch.location(in:self)
                
                
                if let node = self.atPoint(touchLocation) as? SKSpriteNode{
                    if node.name == lowerHalfName  {
                        let paddle = childNode(withName: Paddle1CategoryName) as! SKSpriteNode
                        selectedNodes[touch] = paddle
                    }
                    
                    if node.name == upperAreaName  {
                        let paddle = childNode(withName: Paddle2CategoryName) as! SKSpriteNode
                        selectedNodes[touch] = paddle
                    }
                }
            }
        default:
            break
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch in touches{
            let touchLocation = touch.location(in: self)
            
            
            if let node = selectedNodes[touch] {
                let previousLocation = touch.previousLocation(in:self)
                let paddleX = node.position.x + (touchLocation.x - previousLocation.x)
                node.position = CGPoint(x: paddleX, y: node.position.y)
            }
            
            /*
            if let body = physicsWorld.body(at: touchLocation){
                if body.node!.name == Paddle1CategoryName {
                    let touch = touches.first
                    let touchLocation = touch!.location(in: self)
                    let previousLocation = touch!.previousLocation(in: self)
         
                    let paddle1 = childNode(withName: Paddle1CategoryName) as! SKSpriteNode
         
                    let paddleX = paddle1.position.x + (touchLocation.x - previousLocation.x)
         
                    /*
                    paddleX = max(paddleX, paddle.size.width/2)
                    paddleX = min(paddleX, size.width - paddle.size.width/2)
                    */
         
                    paddle1.position = CGPoint(x: paddleX, y: paddle1.position.y)
                }
                if body.node!.name == Paddle2CategoryName {
                    let touch = touches.first
                    let touchLocation = touch!.location(in: self)
                    let previousLocation = touch!.previousLocation(in: self)
                    
                    let paddle2 = childNode(withName: Paddle2CategoryName) as! SKSpriteNode
                    
                    let paddleX = paddle2.position.x + (touchLocation.x - previousLocation.x)
                    
                    /*
                     paddleX = max(paddleX, paddle.size.width/2)
                     paddleX = min(paddleX, size.width - paddle.size.width/2)
                     */
                    
                    paddle2.position = CGPoint(x: paddleX, y: paddle2.position.y)
                }
            }
    */
            
         
        }
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            if selectedNodes[touch] != nil {
                selectedNodes[touch] = nil
            }
            
            /*
            let touchLocation = touch.location(in: self)
            
            if let body = physicsWorld.body(at: touchLocation){
                if body.node!.name == Paddle1CategoryName {
                    isFingerOnPaddle1 = false
                }
                if body.node!.name == Paddle2CategoryName {
                    isFingerOnPaddle2 = false
                }
            }
             */
        }
    }
    
    override func update(_ currentTime: TimeInterval){
        gameState.update(deltaTime: currentTime)
        
        let ball = childNode(withName: BallCategoryName) as! SKSpriteNode
        
        if strikeChange {
            ball.position = CGPoint(x:0.1 , y:-32.59 )
            strikeChange = false
        }
        
        if gameState.currentState is TwoPlayerGameOver {
            //transition to gameover screen
            self.isPaused = true
            p1strikeCount = 0
            p2strikeCount = 0
            
            
            
            self.viewController?.performSegue(withIdentifier: "TwoPlayerSegueToGameOver", sender: viewController)
        }
    }
    
    
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
