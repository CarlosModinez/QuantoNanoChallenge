//
//  Floor.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 05/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import SpriteKit

class Floor: SKSpriteNode, GameObject {
    var floor = SKSpriteNode(color: .red, size: CGSize(width: 600, height: 100))

    func createFirstFloor() {
        floor.position = CGPoint(x: 0, y: -500)
        floor.zPosition = 3.0
        
        let contactMask = SKPhysicsBody(rectangleOf: floor.size)
        floor.physicsBody = contactMask
        floor.physicsBody?.affectedByGravity = false
        floor.physicsBody?.isDynamic = false
        floor.physicsBody?.allowsRotation = false
        floor.physicsBody?.friction = 1.0
        floor.physicsBody?.linearDamping = 1.0
       
        //Quem é ele na mascara
        floor.physicsBody!.categoryBitMask = BodyMasks.floor
       
        //Com quem colide
        floor.physicsBody!.collisionBitMask = BodyMasks.player
    }
    
    func sortFloor(position: CGPoint, size: CGSize, withCoins: Bool, type: floorType){
        
        floor.size = size
        let contactMask = SKPhysicsBody(rectangleOf: floor.size)
        floor.physicsBody = contactMask
        
        floor.position = position
        floor.zPosition = 3.0
        floor.physicsBody?.affectedByGravity = false
        floor.physicsBody?.isDynamic = false
        floor.physicsBody?.allowsRotation = false
        floor.physicsBody?.linearDamping = 1.0
//        floor.physicsBody?.restitution = 0
        floor.physicsBody?.pinned = true
        
        
        //Muda o atrito de acordo com o tipo de chao sorteado
        if type == .ice {
            floor.physicsBody?.friction = 0.08
            floor.texture = SKTexture(imageNamed: "ice")
        } else if type == .dirt {
            floor.physicsBody?.friction = 0.5
            floor.texture = SKTexture(imageNamed: "dirt")
        } else {
            floor.physicsBody?.friction = 1.0
            floor.texture = SKTexture(imageNamed: "rock")
        }
            
        //Quem é ele na mascara
        floor.physicsBody!.categoryBitMask = BodyMasks.floor
        
        //Com quem colide
        floor.physicsBody!.collisionBitMask = BodyMasks.player | BodyMasks.box
    }
    
    func update(deltaTime daltaTime: TimeInterval, velocity: Double) {
        // Nao faz nada nao
    }
}

enum floorType {
    case ice
    case dirt
    case rock
}
