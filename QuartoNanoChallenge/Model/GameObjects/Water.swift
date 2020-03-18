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
    var allowGrowUp = false
    func setup(yPosition: Int) {
        water.texture = SKTexture(imageNamed: "waveFullScreen")
        water.position = CGPoint(x: 0, y: yPosition)
        water.physicsBody = SKPhysicsBody(rectangleOf: water.size)
        water.zPosition = 10.0
       
        water.physicsBody?.affectedByGravity = false
        water.physicsBody?.isDynamic = false
        water.physicsBody?.allowsRotation = false
    
        
        //Quem é ele na mascara
        water.physicsBody!.categoryBitMask = BodyMasks.water
        
        //Com quem ele tem contato
        water.physicsBody?.contactTestBitMask = BodyMasks.player | BodyMasks.box
    }
    
    func update(deltaTime: TimeInterval, velocity: Double) {
        if allowGrowUp {
            water.position.y += CGFloat(velocity)
        }
    }
}
