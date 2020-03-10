//
//  Bar.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 05/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import SpriteKit

class Bar: SKSpriteNode {
    var bar = SKSpriteNode(color: .green, size: CGSize(width: 20, height: 20))
    
    func setup(height: Int, xPosition: Int, yPosition: Int) {
        bar.size = CGSize(width: 20, height: height)
        bar.anchorPoint = CGPoint(x: xPosition, y: yPosition)
        bar.position = CGPoint(x: 0, y: yPosition)
        bar.zPosition = 3.0
        bar.physicsBody = SKPhysicsBody(rectangleOf: bar.size)
    }
    
    func excludePhysics() {
        bar.physicsBody?.affectedByGravity = false
        bar.physicsBody?.isDynamic = false
        bar.physicsBody?.allowsRotation = false
    
    }
    
    
    func addPhysics() {
        bar.physicsBody?.affectedByGravity = false
        bar.physicsBody?.isDynamic = true
        bar.physicsBody?.allowsRotation = true

        
        //Quem é ele na mascara
        bar.physicsBody!.categoryBitMask = BodyMasks.obstacle
        
        //Com quem colide
        bar.physicsBody!.collisionBitMask = BodyMasks.player | BodyMasks.floor
    }
}
