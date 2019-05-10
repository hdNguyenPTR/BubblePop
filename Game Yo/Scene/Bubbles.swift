//
//  Bubbles.swift
//  Game Yo
//
//  Created by Huu Nguyen on 3/5/19.
//  Copyright © 2019 Huu Nguyen. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

// struct to randomize bubble
struct Bubbles {
    
    //function to return random colored bubble
    func createBubble() -> SKSpriteNode {
        //local variable declaration
        let bubble = SKSpriteNode(imageNamed: "Circle White")
        // set size
        bubble.size = CGSize(width: 50, height: 50)
        // randomize color
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
        // set physics for bubble
        bubble.colorBlendFactor = 1
        bubble.physicsBody = SKPhysicsBody(circleOfRadius: bubble.size.height / 2) // 1
        bubble.physicsBody?.isDynamic = true // 2
        bubble.physicsBody?.categoryBitMask = PhysicsCategory.bubble // 3
        bubble.physicsBody?.contactTestBitMask = PhysicsCategory.pop // 4
        bubble.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
        

//            var actualY:CGFloat
//            var actualX:CGFloat
//            //            repeat{
//            actualY = randomCG(min: bubble.size.height  , max: size.height * 0.6)
//            actualX = randomCG(min: bubble.size.width   , max: (size.width) - (bubble.size.width))
//            //            } while (isPositionEmpty(point: CGPoint(x: actualX, y: actualY)))
//
//
//            bubble.position = CGPoint(x: actualX, y: actualY)
//            addChild(bubble)
//            let actionMove = SKAction.fadeIn(withDuration: 1)
//            let actionDone = SKAction.removeFromParent()
//            bubble.run(SKAction.sequence([actionMove,actionDone]))
        return bubble
    }
}
