//
//  Boxes.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 05/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import SpriteKit

class Box: SKSpriteNode {
    var box = SKSpriteNode(color: .blue, size: Model.shared.boxSize)
    
    func setup(position: CGPoint) {
        box.position = position
        let contactMask = SKPhysicsBody(rectangleOf: Model.shared.boxSize)
        box.physicsBody = contactMask
    }
    
    func addRandomBoxTexture() {
        let sorter = Int.random(in: 0...3)
        if sorter == 0 {
            box.texture = SKTexture(imageNamed: "box_0")
        } else if sorter == 1 {
            box.texture = SKTexture(imageNamed: "box_1")
        } else if sorter == 2 {
            box.texture = SKTexture(imageNamed: "box_2")
        } else {
            box.texture = SKTexture(imageNamed: "box_3")
        }
    }
    
    func addPhysics() {
        box.physicsBody?.affectedByGravity = true
        box.physicsBody?.isDynamic = true
        box.physicsBody?.allowsRotation = true
        box.physicsBody?.mass = Model.shared.boxMass
        box.physicsBody?.linearDamping = 1.0
//        box.physicsBody?.restitution = 0
        
        //Quem é ele na mascara
        box.physicsBody!.categoryBitMask = BodyMasks.player
        
        //Com quem colide
        box.physicsBody!.collisionBitMask = BodyMasks.obstacle | BodyMasks.floor | BodyMasks.player
        
        //Com quem ele tem contato
        box.physicsBody?.contactTestBitMask = BodyMasks.reward
    }
    
    func excludePhysics() {
        box.physicsBody?.affectedByGravity = false
        box.physicsBody?.isDynamic = false
        box.physicsBody?.allowsRotation = false
    }
}
