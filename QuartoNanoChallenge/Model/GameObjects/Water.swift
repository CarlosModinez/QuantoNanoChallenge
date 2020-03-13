//
//  Water.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 12/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import Foundation
import SpriteKit

class Water: SKSpriteNode, GameObject {
    var water = SKSpriteNode(color: .blue, size: CGSize(width: 900, height: 1000))
    var dieCounter: Double = 1.0
    func setup() {
        water.texture = SKTexture(imageNamed: "waveFullScreen")
        water.position = CGPoint(x: 0, y: -800)
        water.physicsBody = SKPhysicsBody(rectangleOf: water.size)
        water.zPosition = 5.0
       
        water.physicsBody?.affectedByGravity = false
        water.physicsBody?.isDynamic = false
        water.physicsBody?.allowsRotation = false
    
        
        //Quem é ele na mascara
        water.physicsBody!.categoryBitMask = BodyMasks.water
        
        //Com quem ele tem contato
        water.physicsBody?.contactTestBitMask = BodyMasks.player | BodyMasks.box
    }
    
    func update(deltaTime: TimeInterval, velocity: Double) {
        water.position.y += CGFloat(velocity/dieCounter)
    }
}
