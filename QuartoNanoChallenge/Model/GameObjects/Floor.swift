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
            floor.physicsBody?.categoryBitMask = BodyMasks.ice
        } else if type == .dirt {
            floor.physicsBody?.friction = 0.5
            floor.texture = SKTexture(imageNamed: "dirt")
            floor.physicsBody?.categoryBitMask = BodyMasks.dirt
        } else {
            floor.physicsBody?.friction = 1.0
            floor.physicsBody?.categoryBitMask = BodyMasks.rock
            floor.texture = SKTexture(imageNamed: "rock")
        }
        
        //Com quem ele tem contato
        floor.physicsBody?.contactTestBitMask = BodyMasks.player | BodyMasks.box
        
        //Com quem colide
        floor.physicsBody!.collisionBitMask = BodyMasks.player | BodyMasks.box
        
        if withCoins {
            let coin = Coins()
            coin.setup()
            floor.addChild(coin.coin)
        }
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
