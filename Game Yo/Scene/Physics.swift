//
//  Physics.swift
//  Game Yo
//
//  Created by Huu Nguyen on 1/5/19.
//  Copyright © 2019 Huu Nguyen. All rights reserved.
//

import SpriteKit

// set physics category
struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let all       : UInt32 = UInt32.max
    static let bubble   : UInt32 = 0b1       // 1
    static let pop: UInt32 = 0b10      // 2
}
