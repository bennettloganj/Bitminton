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
let lowerHalfName = "lowerHalf"
let upperAreaName = "upperHalf"
let BlockCategoryName = "block"
let GameMessageName = "gameMessage"
let PauseName = "Pause"

let scoreKeyConstant = "HighScores"


class OnePlayerGameScene: SKScene, SKPhysicsContactDelegate {
    
    var isFingerOnPaddle = false
    var newHighScore = false
    var count = 0
    var viewController: UIViewController?

    
    let BallCategory   : UInt32 = 0x1 << 0
    let BottomCategory : UInt32 = 0x1 << 1
    let PaddleCategory : UInt32 = 0x1 << 3
    let BorderCategory : UInt32 = 0x1 << 4
    let LowerHalfCategory : UInt32 = 0x1 << 5
    let PauseCategory : UInt32 = 0x1 << 6
    
    private var strikeCount: Int = 0
    private var strikeChange: Bool = false
    var scoreCount: Int = 0
    
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
        let birdieImageData = defaults.data(forKey: "currentPlayBirdie")
        let birdieImage = UIImage(data: birdieImageData!, scale: 1.0)
        let circleBirdieImage = birdieImage?.circleMasked
        
        let swiftcolor = UIColor.white
        let borderedCircleBirdImage = circleBirdieImage?.roundedImageWithBorder(width: 20, color: swiftcolor)
        
        
        let balltexture = SKTexture(image: borderedCircleBirdImage!)
        
        ball.texture = balltexture
        
        let paddle = childNode(withName: PaddleCategoryName) as! SKSpriteNode
        
   
        let lowerHalf = childNode(withName: "lowerHalf") as! SKSpriteNode
        
        let pause = childNode(withName: PauseName) as! SKSpriteNode
        
        let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 0.001)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        addChild(bottom)
        
        pause.physicsBody!.categoryBitMask = PauseCategory
        lowerHalf.physicsBody!.categoryBitMask = LowerHalfCategory
        bottom.physicsBody!.categoryBitMask = BottomCategory
        ball.physicsBody!.categoryBitMask = BallCategory
        paddle.physicsBody!.categoryBitMask = PaddleCategory
        borderBody.categoryBitMask = BorderCategory
        
        ball.physicsBody!.contactTestBitMask = BottomCategory
        paddle.physicsBody!.contactTestBitMask = BallCategory

        ball.physicsBody!.collisionBitMask = BottomCategory | PaddleCategory | BorderCategory
        
        ball.physicsBody!.usesPreciseCollisionDetection = true
        bottom.physicsBody!.usesPreciseCollisionDetection = true
        
        let gameMessage = SKSpriteNode(imageNamed: "TapToPlay")
        gameMessage.name = GameMessageName
        gameMessage.position = CGPoint(x: frame.midX, y: frame.midY+50)
        gameMessage.zPosition = 4
        gameMessage.setScale(0.0)
        addChild(gameMessage)
        
        gameState.enter(WaitingForTap.self)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        
        let scoreCounter = childNode(withName: "ScoreCounter") as! SKLabelNode
        
    
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {
            print("Hit bottom. ")
            
            
            
            print(strikeCount)
            
            let redStrikeOne = childNode(withName: "redStrikeOne") as! SKSpriteNode
            let redStrikeTwo = childNode(withName: "redStrikeTwo") as! SKSpriteNode
            let redStrikeThree = childNode(withName: "redStrikeThree") as! SKSpriteNode
            
            let whiteStrikeOne = childNode(withName: "whiteStrikeOne") as! SKSpriteNode
            let whiteStrikeTwo = childNode(withName: "whiteStrikeTwo") as! SKSpriteNode
            let whiteStrikeThree = childNode(withName: "whiteStrikeThree") as! SKSpriteNode
            
            strikeCount += 1
            
            switch strikeCount {
            case 2:
                redStrikeOne.zPosition = 5
                whiteStrikeOne.zPosition = 0
                strikeChange = true
            case 4:
                redStrikeTwo.zPosition = 5
                whiteStrikeTwo.zPosition = 0
                strikeChange = true
            case 6:
                redStrikeThree.zPosition = 5
                whiteStrikeThree.zPosition = 0
                strikeChange = true
                gameState.enter(GameOver.self)
            default:
                break
            }
            
        }else if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == PaddleCategory {
            print("Hit Paddle")
            var scoreValue: Int = Int(scoreCounter.text!)!
            scoreValue += 1
            scoreCount += 1
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
                
                
                if body.node!.name == PauseName {
                    self.isPaused = true
                    
                    let alertController = UIAlertController(title: "Game Paused", message: "", preferredStyle: .alert)
                    
                    let resumeAction = UIAlertAction(title: "Resume", style: .default, handler: { (_)->Void in
                        self.isPaused = false
                    })
                    
                    let menuAction = UIAlertAction(title: "Main Menu", style: .default, handler: { (_)->Void in
                        self.viewController?.performSegue(withIdentifier: "fromGameToMenuSegue", sender: self.viewController)                    })
                    
                    alertController.addAction(resumeAction)
                    alertController.addAction(menuAction)
                    
                    self.viewController?.present(alertController, animated: true, completion: nil)
                }
                
                if body.node!.name == lowerHalfName {
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
        
        let ball = childNode(withName: BallCategoryName) as! SKSpriteNode
        
        if strikeChange {
            ball.position = CGPoint(x:0.1 , y:-32.59)
            strikeChange = false
        }
        
        if gameState.currentState is GameOver {
            
            let scoreCounter = childNode(withName: "ScoreCounter") as! SKLabelNode
            
            //transition to gameover screen
            self.isPaused = true
            strikeCount = 0
            let scoreValue: Int = Int(scoreCounter.text!)!
            
            let defaults = UserDefaults.standard
            var scoreArray = defaults.array(forKey: "scoreArray") as! [Int]
            for score in scoreArray {
                if scoreValue > score {
                    newHighScore = true
                    scoreArray.append(scoreValue)
                    scoreArray = rearrangeIntArray(array: scoreArray, fromIndex: scoreArray.count-1, toIndex: count)
                    scoreArray.remove(at: scoreArray.count-1)
                    defaults.set(scoreArray, forKey: "scoreArray")
                    defaults.synchronize()
                    //add player name stuff
                    
                    break
                }
                count += 1
            }
            
            self.viewController?.performSegue(withIdentifier: "SegueToGameOver", sender: viewController)
        }
    }
    
    /*func isGameWon() -> Bool{
        
    }*/
    
    func rearrangeIntArray(array: [Int], fromIndex: Int, toIndex: Int) -> [Int] {
        
        var temp = array
        let item = temp.remove(at: fromIndex)
        temp.insert(item, at: toIndex)
        
        return temp
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

extension UIImage {
    var isPortrait:  Bool    { return size.height > size.width }
    var isLandscape: Bool    { return size.width > size.height }
    var breadth:     CGFloat { return min(size.width, size.height) }
    var breadthSize: CGSize  { return CGSize(width: breadth, height: breadth) }
    var breadthRect: CGRect  { return CGRect(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait  ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func roundedImageWithBorder(width: CGFloat, color: UIColor) -> UIImage? {
        let square = CGSize(width: min(size.width, size.height) + width * 2, height: min(size.width, size.height) + width * 2)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .center
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = width
        imageView.layer.borderColor = color.cgColor
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    
    func fixOrientation() -> UIImage {
        
        // No-op if the orientation is already correct
        if ( self.imageOrientation == UIImageOrientation.up ) {
            return self;
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        if ( self.imageOrientation == UIImageOrientation.down || self.imageOrientation == UIImageOrientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        }
        
        if ( self.imageOrientation == UIImageOrientation.left || self.imageOrientation == UIImageOrientation.leftMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2.0))
        }
        
        if ( self.imageOrientation == UIImageOrientation.right || self.imageOrientation == UIImageOrientation.rightMirrored ) {
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi / 2.0));
        }
        
        if ( self.imageOrientation == UIImageOrientation.upMirrored || self.imageOrientation == UIImageOrientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        if ( self.imageOrientation == UIImageOrientation.leftMirrored || self.imageOrientation == UIImageOrientation.rightMirrored ) {
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                       bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                       space: self.cgImage!.colorSpace!,
                                       bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!;
        
        ctx.concatenate(transform)
        
        if ( self.imageOrientation == UIImageOrientation.left ||
            self.imageOrientation == UIImageOrientation.leftMirrored ||
            self.imageOrientation == UIImageOrientation.right ||
            self.imageOrientation == UIImageOrientation.rightMirrored ) {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
        } else {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
        }
        
        // And now we just create a new UIImage from the drawing context and return it
        return UIImage(cgImage: ctx.makeImage()!)
    }
}


