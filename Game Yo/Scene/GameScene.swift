//
//  GameScene.swift
//  Game Yo
//
//  Created by Huu Nguyen on 1/5/19.
//  Copyright © 2019 Huu Nguyen. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let instructLabel = SKLabelNode(text: "Pop the Bubbles")
    var consecBubble:String = ""
    var bubbleArray: [SKSpriteNode] = []
    var pointLabel: SKLabelNode!
    var point = 0 {
        didSet{
            pointLabel.text = "Points: \(point)"
        }
    }
    var maxBubble:UInt32 = UInt32(UserDefaults.standard.integer(forKey: "maxBubble"))
    var levelTimerLabel: SKLabelNode!
    //Immediately after leveTimerValue variable is set, update label's text
    var levelTimerValue: Int = UserDefaults.standard.integer(forKey: "timeMax") {
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
        levelTimerLabel.text = "Time left: \(levelTimerValue)"
        levelTimerLabel.position = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 0.9)
        levelTimerLabel.fontColor = .black
        addChild(levelTimerLabel)
        addChild(pointLabel)
        addChild(instructLabel)
            run(SKAction.repeatForever(SKAction.sequence([SKAction.run(randomBubble),SKAction.run(timer),SKAction.wait(forDuration: 1),SKAction.run(randomBubbleRemove)])
            ),withKey: "start")
    }
    
    func timer() {
        if self.levelTimerValue > 0 {
            self.levelTimerValue -= 1
        }
    }
    
    func randomCG() -> CGFloat {
          return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func randomCG(min: CGFloat, max: CGFloat) -> CGFloat {
        return (randomCG() * (max - min)) + min
    }
    
    func randomBubble() {
        let bubbleNumber = arc4random_uniform(maxBubble - UInt32(bubbleArray.count) + 1)
        run(SKAction.repeat(SKAction.run(addBubble), count:  Int(bubbleNumber)))
    }
    
    func randomBubbleRemove() {
        if(levelTimerValue > 0){
            let bubbleNumber = arc4random_uniform(UInt32(bubbleArray.count))
            run(SKAction.repeat(SKAction.run(bubbleExpire), count:  Int(bubbleNumber)))
        }
    }
    
    func bubbleExpire() {
        let expiredBubble = bubbleArray.randomElement()
        self.bubbleArray = self.bubbleArray.filter() {$0 != expiredBubble}
        expiredBubble?.run(SKAction.removeFromParent())
    }
    
    func removeBubble(point: SKSpriteNode){
        
        self.bubbleArray = self.bubbleArray.filter() {$0 != point}
        point.run(SKAction.sequence([SKAction.resize(byWidth: 50, height: 50, duration: 0.5 ), SKAction.removeFromParent()]))
    }
    
    func addBubble() {
        if(levelTimerValue > 0){
            let bubbleBase = Bubbles()
            let bubbleT = bubbleBase.createBubble()
            var actualY:CGFloat
            var actualX:CGFloat
            repeat{
                actualY = randomCG(min: bubbleT.size.height  , max: size.height * 0.6)
                actualX = randomCG(min: bubbleT.size.width   , max: (size.width) - (bubbleT.size.width))
                bubbleT.position = CGPoint(x: actualX, y: actualY)
            } while (isPositionFilled(node: bubbleT))
            bubbleArray.append(bubbleT)
            //print(bubbleArray)
            addChild(bubbleT)
            let actionSpawn = SKAction.fadeIn(withDuration: 1)
            let actionMove = SKAction.move(to:  CGPoint(x: -bubbleT.size.width/2, y: actualY), duration: Double(levelTimerValue)/5.0)
            //let actionDone = SKAction.removeFromParent()
            bubbleT.run(SKAction.sequence([actionSpawn,actionMove]))
        }
        else{
            gameOver()
            }
        }
    
    func gameOver() {
        let currentViewController:UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!
        let end = currentViewController.storyboard?.instantiateViewController(withIdentifier: "scoreVC") as! ScoreTableViewController
        let currentPlayer = UserDefaults.standard.string(forKey: "currentPlayer")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if currentPlayer != nil{
            appDelegate.setPoints(name: currentPlayer!, score: Int64(point))
        }
        end.navigationController?.setNavigationBarHidden(true, animated: false)
        currentViewController.navigationController?.setNavigationBarHidden(true, animated: false)
        currentViewController.present(end, animated: true, completion: nil)
        removeAction(forKey: "start")
    }
    
    func isPositionFilled(node: SKSpriteNode) -> Bool {
        var result = false
        for p in bubbleArray{
            if(p.intersects(node)){result = true}
        }
        return result
    }
    
    func popDidCollideWithBubble(pop: SKSpriteNode, bubble: SKSpriteNode) {
        print("Hit")
        switch(bubble.name){
        case "Red":
            if(consecBubble == "Red"){
                point += 2
            }
            else{
                point += 1
            }
            consecBubble = "Red"
        case "Pink":
            if(consecBubble == "Pink"){
                point += 3
            }
            else{
                point += 2
            }
            consecBubble = "Pink"
        case "Green":
            if(consecBubble == "Green"){
                point += 8
            }
            else{
                point += 5
            }
            consecBubble = "Green"
        case "Blue":
            if(consecBubble == "Blue"){
                point += 12
            }
            else{
                point += 8
            }
            consecBubble = "Blue"
        case "Black":
            if(consecBubble == "Black"){
                point += 15
            }
            else{
                point += 10
            }
            consecBubble = "Black"
        default: point += 0
        }
        //print(bubble)
        pop.removeFromParent()
        removeBubble(point: bubble)
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
