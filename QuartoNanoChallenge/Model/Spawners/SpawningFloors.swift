//
//  SpawningFloors.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 05/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import SpriteKit
import AVFoundation

class SpawningFloors: GameObject {
    
    var timer: TimeInterval = 0
    var node: SKNode
    var cam : SKCameraNode
    var floorArray: [Floor] = []
    var distance = 500.0 //Distancia entre os blocos
    var initialFloorsCreated: Bool = false
    
    init(node: SKNode, cam: SKCameraNode) {
        self.node = node
        self.cam = cam
    }
    
    func update(deltaTime daltaTime: TimeInterval, velocity: Double) {
        if !initialFloorsCreated {
            createInitialFloors()
        } else {
            spawnNewFloor()
        }
    }

    private func removeUseLessFloors() {
        floorArray[0].floor.removeFromParent()
        floorArray.remove(at: 0)
        
    }
    private func spawnNewFloor() {
        
        if cam.position.y - floorArray[0].floor.position.y >= 800 {
            removeUseLessFloors()
            let newFloor = Floor()
            let xPosition = Int.random(in: -320...320)
            let yPosition = Int((floorArray.last?.floor.position.y)!) + 200
            let position = CGPoint(x: xPosition, y: yPosition)
            let size = CGSize(width: 300, height: 30)
            let sortType = Int.random(in: 0..<3)
            let withCoins = false
            
            var type: floorType
            if sortType == 0 {
                type = .ice
            } else if sortType == 1 {
                type = .dirt
            } else {
                type = .rock
            }
            
            newFloor.sortFloor(position: position, size: size, withCoins: withCoins, type: type)
            floorArray.append(newFloor)
            node.addChild(newFloor.floor)
        }
    }
    
    private func createInitialFloors() {
        initialFloorsCreated = true
        
        for yPositionMultiplier in 0...6 {
            let newFloor = Floor()
            let xPosition = Int.random(in: -320...320)
            let yPosition = yPositionMultiplier * 200
            let position = CGPoint(x: xPosition, y: yPosition)
            let size = CGSize(width: 300, height: 30)
            let sortType = Int.random(in: 0..<3)
            let withCoins = false
            
            var type: floorType
            if sortType == 0 {
                type = .ice
            } else if sortType == 1 {
                type = .dirt
            } else {
                type = .rock
            }
            
//        var withCoins = Bool.random()
            newFloor.sortFloor(position: position, size: size, withCoins: withCoins, type: type)
            floorArray.append(newFloor)
            node.addChild(newFloor.floor)
        }
    }
    
    
}



