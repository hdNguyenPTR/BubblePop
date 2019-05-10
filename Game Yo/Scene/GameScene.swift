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
    
    // variable declarations
    var start = true
    let instructLabel = SKLabelNode(text: "Pop the Bubbles")
    var consecBubble:String = ""
    var bubbleArray: [SKSpriteNode] = []
    var pointLabel: SKLabelNode!
    var highLabel: SKLabelNode!
    var gameMessage = SKSpriteNode(imageNamed: "TapToPlay")
    var once = true
    weak var currentViewController: GameViewController?
    var maxBubble:UInt32 = UInt32(UserDefaults.standard.integer(forKey: "maxBubble"))
    var levelTimerLabel: SKLabelNode!
    //Immediately after leveTimerValue variable is set, update label's text
    var levelTimerValue: Int = UserDefaults.standard.integer(forKey: "timeMax") {
        didSet {
            levelTimerLabel.text = "Time left: \(levelTimerValue)"
        }
    }
    var point = 0 {
        didSet{
            pointLabel.text = "Points: \(point)"
        }
    }
    
    //set up initial scene
    override func didMove(to view: SKView) {
        // declare variable to get highscore
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // set physics world
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        //set background
        self.backgroundColor = .white
        //set message and label atributes
        gameMessage.name = "TapToPlay"
        gameMessage.position = CGPoint(x: frame.midX, y: frame.midY)
        gameMessage.zPosition = 4
        gameMessage.setScale(1.0)
        instructLabel.position = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 0.80)
        instructLabel.fontColor = .black
        pointLabel = SKLabelNode()
        pointLabel.text = "Point: 0"
        pointLabel.position = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 0.7)
        pointLabel.fontColor = .black
        highLabel = SKLabelNode()
        highLabel.text = "Highscore: \(appDelegate.fetchMax())"
        highLabel.position = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 0.75)
        highLabel.fontColor = .black
        levelTimerLabel = SKLabelNode()
        levelTimerLabel.text = "Time left: \(levelTimerValue)"
        levelTimerLabel.position = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 0.85)
        levelTimerLabel.fontColor = .black
        // add message and label to scene
        addChild(highLabel)
        addChild(levelTimerLabel)
        addChild(pointLabel)
        addChild(instructLabel)
        addChild(gameMessage)
    }
    
    // touch event
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        // first tap to play
        if start {
            // repeat cycle of spawning bubbles
            run(SKAction.repeatForever(SKAction.sequence([SKAction.run(randomBubble), SKAction.run(timer), SKAction.wait(forDuration: 1), SKAction.run(randomBubbleRemove)])), withKey: "start")
            // remove tap to play label
            self.childNode(withName: "TapToPlay")?.removeFromParent()
            // start countdown
            start = false
        }
        // pop bubble by tapping
        else{
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
            // spawn "pop" object
            let actionPop = SKAction.fadeOut(withDuration: 0.2)
            let actionDone = SKAction.removeFromParent()
            pop.run(SKAction.sequence([actionPop, actionDone]))
        }
    }
    
    // timer function
    func timer() {
        if self.levelTimerValue > 0 {
            self.levelTimerValue -= 1
        }
    }
    
    // random position function
    func randomCG() -> CGFloat {
          return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    // random position function with min max
    func randomCG(min: CGFloat, max: CGFloat) -> CGFloat {
        return (randomCG() * (max - min)) + min
    }
    
    // function to random bubble spawn
    func randomBubble() {
        let bubbleNumber = arc4random_uniform(maxBubble - UInt32(bubbleArray.count) + 1)
        run(SKAction.repeat(SKAction.run(addBubble), count:  Int(bubbleNumber)))
    }
    
    // function to remove random amount of bubbles with time
    func randomBubbleRemove() {
        if(levelTimerValue > 0){
            let bubbleNumber = arc4random_uniform(UInt32(bubbleArray.count))
            run(SKAction.repeat(SKAction.run(bubbleExpire), count:  Int(bubbleNumber)))
        }
    }
    
    // function to select random bubble and remove
    func bubbleExpire() {
        let expiredBubble = bubbleArray.randomElement()
        self.bubbleArray = self.bubbleArray.filter() {$0 != expiredBubble}
        expiredBubble?.run(SKAction.removeFromParent())
    }
    
    // function to remove selecte bubble
    func removeBubble(point: SKSpriteNode){
        self.bubbleArray = self.bubbleArray.filter() {$0 != point}
        // increase in size to symbolize pop
        point.run(SKAction.sequence([SKAction.resize(byWidth: 50, height: 50, duration: 0.1 ), SKAction.removeFromParent()]))
    }
    
    // function to spawn single bubble
    func addBubble() {
        // check if theres time left
        if(levelTimerValue > 0){
            // local variable declaration
            let bubbleBase = Bubbles()
            let bubbleT = bubbleBase.createBubble()
            var actualY:CGFloat
            var actualX:CGFloat
            
            //check for overlap
            repeat{
                actualY = randomCG(min: bubbleT.size.height  , max: size.height * 0.6)
                actualX = randomCG(min: bubbleT.size.width   , max: (size.width) - (bubbleT.size.width))
                bubbleT.position = CGPoint(x: actualX, y: actualY)
            } while (isPositionFilled(node: bubbleT))
            
            // save bubble to bubble array
            bubbleArray.append(bubbleT)
            // add to scene
            addChild(bubbleT)
            
            // animations for bubble, fade in and move away
            let actionSpawn = SKAction.fadeIn(withDuration: 1)
            let actionMove = SKAction.move(to:  CGPoint(x: -bubbleT.size.width*2, y: actualY), duration: Double(levelTimerValue)/10.0)
            bubbleT.run(SKAction.sequence([actionSpawn,actionMove]))
        }
        // run game over
        else{
            gameOver()
            }
        }
    
    // game over function
    func gameOver() {
        // declare local variable
        let currentPlayer = UserDefaults.standard.string(forKey: "currentPlayer")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // save player's score
        if currentPlayer != nil && once{
            appDelegate.setPoints(name: currentPlayer!, score: Int64(point))
            once = false
            // enable navigation bar to return to main menu
            currentViewController?.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        // stop the repeating bubble spawn action
        removeAction(forKey: "start")
    }
    
    // function to check if the bubble overlap before spawn
    func isPositionFilled(node: SKSpriteNode) -> Bool {
        var result = false
        for p in bubbleArray{
            if(p.intersects(node)){result = true}
        }
        return result
    }
    
    // function to pop a bubble
    func popDidCollideWithBubble(pop: SKSpriteNode, bubble: SKSpriteNode) {
        // set different points on pop
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
        //remove the "pop" object and the bubble popped
        pop.removeFromParent()
        removeBubble(point: bubble)
    }
}

// set extension for game physics
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
