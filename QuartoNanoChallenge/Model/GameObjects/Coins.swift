//
//  Coins.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 09/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import SpriteKit

class Coins: SKSpriteNode, GameObject{
    
    var coin = SKSpriteNode(color: .yellow, size: CGSize(width: 30, height: 30))
    
    func setup() {
        coin.position = CGPoint(x: 0, y: 40)
        coin.physicsBody = SKPhysicsBody(rectangleOf: coin.size)
        coin.texture = SKTexture(imageNamed: "coin")
        
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.allowsRotation = false
        coin.physicsBody?.isDynamic = false
    
        coin.physicsBody?.categoryBitMask = BodyMasks.reward
        coin.physicsBody?.contactTestBitMask = BodyMasks.player
        
        coin.zPosition = 4
    }
    
    func update(deltaTime: TimeInterval, velocity: Double) {
        print("coins update")
    }
}
