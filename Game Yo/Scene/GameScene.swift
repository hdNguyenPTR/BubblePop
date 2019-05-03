//
//  GameScene.swift
//  Game Yo
//
//  Created by Huu Nguyen on 1/5/19.
//  Copyright © 2019 Huu Nguyen. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let instructLabel = SKLabelNode(text: "Pop the Bubbles")
    var locationArray: [CGPoint] = []
    var pointLabel: SKLabelNode!
    var point = 0 {
        didSet{
            pointLabel.text = "Points: \(point)"
        }
    }
    var maxBubble:UInt32 = 15
    var levelTimerLabel: SKLabelNode!
    //Immediately after leveTimerValue variable is set, update label's text
    var levelTimerValue: Int = 60 {
        didSet {
            levelTimerLabel.text = "Time left: \(levelTimerValue)"
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        let pop = SKSpriteNode(imageNamed: "Circle White")
        pop.size = CGSize(width: 20, height: 20)
        pop.position = touchLocation
        pop.physicsBody = SKPhysicsBody(circleOfRadius: pop.size.width/2)
        pop.physicsBody?.isDynamic = true
        pop.physicsBody?.categoryBitMask = PhysicsCategory.pop
        pop.physicsBody?.contactTestBitMask = PhysicsCategory.bubble
        pop.physicsBody?.collisionBitMask = PhysicsCategory.none
        pop.physicsBody?.usesPreciseCollisionDetection = true
        addChild(pop)
        
        let actionPop = SKAction.fadeOut(withDuration: 0.2)
        let actionDone = SKAction.removeFromParent()
        pop.run(SKAction.sequence([actionPop, actionDone]))
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        self.backgroundColor = .white
        instructLabel.position = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 0.8)
        instructLabel.fontColor = .black
        pointLabel = SKLabelNode()
        pointLabel.text = "Point: 0"
        pointLabel.position = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 0.7)
        pointLabel.fontColor = .black
        levelTimerLabel = SKLabelNode()
        levelTimerLabel.text = "Time left: 60"
        levelTimerLabel.position = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 0.9)
        levelTimerLabel.fontColor = .black
        addChild(levelTimerLabel)
        addChild(pointLabel)
        addChild(instructLabel)
            run(SKAction.repeatForever(SKAction.sequence([SKAction.run(randomBubble),SKAction.run(timer),                                  SKAction.wait(forDuration: 1)])
            ))
    }
    
    func timer(){
        if self.levelTimerValue > 0{
            self.levelTimerValue -= 1
        }
    }
    
    func randomCG() -> CGFloat {
          return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func randomCG(min: CGFloat, max: CGFloat) -> CGFloat {
        return (randomCG() * (max - min)) + min
    }
    
    func randomBubble(){
        let bubbleNumber = arc4random_uniform(maxBubble + 1)
        run(SKAction.repeat(SKAction.run(addBubble), count: Int(bubbleNumber)))
    }
    
    func addBubble() {
        if(levelTimerValue > 0){
            let bubble = SKSpriteNode(imageNamed: "Circle White")
            bubble.size = CGSize(width: 50, height: 50)
            let r = Int(arc4random_uniform(99))
            switch(r){
            case 0..<40:
                bubble.name = "Red"
                bubble.color = .red
            case 40..<70:
                bubble.name = "Pink"
                bubble.color = UIColor(red: 1, green: 0, blue: 0.7804, alpha: 1.0)
            case 70..<85:
                bubble.name = "Green"
                bubble.color = .green
            case 85..<95:
                bubble.name = "Blue"
                bubble.color = .blue
            case 95..<100:
                bubble.name = "Black"
                bubble.color = .black
            default: bubble.name = "sux"
            }
            bubble.colorBlendFactor = 1
            bubble.physicsBody = SKPhysicsBody(circleOfRadius: bubble.size.height / 2) // 1
            bubble.physicsBody?.isDynamic = true // 2
            bubble.physicsBody?.categoryBitMask = PhysicsCategory.bubble // 3
            bubble.physicsBody?.contactTestBitMask = PhysicsCategory.pop // 4
            bubble.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
            var actualY:CGFloat
            var actualX:CGFloat
//            repeat{
                actualY = randomCG(min: bubble.size.height  , max: size.height * 0.6)
                actualX = randomCG(min: bubble.size.width   , max: (size.width) - (bubble.size.width))
//            } while (isPositionEmpty(point: CGPoint(x: actualX, y: actualY)))
            
            
            bubble.position = CGPoint(x: actualX, y: actualY)
            addChild(bubble)
            let actionMove = SKAction.fadeIn(withDuration: 1)
            let actionDone = SKAction.removeFromParent()
            bubble.run(SKAction.sequence([actionMove,actionDone]))
        }
    }

    func isPositionEmpty(point: CGPoint) -> Bool {
        let b = SKSpriteNode(imageNamed: "Circle White")
        b.size = CGSize(width: 50, height: 50)
        for p in locationArray{
            
        }
        
        return true
    }
    
    func popDidCollideWithBubble(pop: SKSpriteNode, bubble: SKSpriteNode) {
        print("Hit")
        switch(bubble.name){
        case "Red": point += 1
        case "Pink": point += 2
        case "Green": point += 5
        case "Blue": point += 8
        case "Black": point += 10
        default: point += 0
        }
        print(bubble)
        pop.removeFromParent()
        bubble.removeFromParent()
    }

}
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.bubble != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.pop != 0)) {
            if let bubble = firstBody.node as? SKSpriteNode,
                let pop = secondBody.node as? SKSpriteNode {
                popDidCollideWithBubble(pop: pop, bubble: bubble)
            }
        }
    }

}
