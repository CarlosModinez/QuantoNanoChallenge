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
    var arrayPosition: Int = 0
    var distance =  Model.shared.floorStep//Distancia entre os blocos
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
    
    private func spawnNewFloor() {

        if abs(cam.position.y  - (floorArray.last!.floor.position.y)) <= 800 {

            let newFloor = Floor()
            
            var xPosition: Int
            if floorArray.count > 1  {
                repeat {
                    xPosition = Int.random(in: -320...320)
                } while abs(xPosition - Int(floorArray[arrayPosition - 1].floor.position.x)) < Int(Model.shared.boxSize.width)
            } else {
                xPosition = Int.random(in: -320...320)
            }
            arrayPosition += 1
            
            let yPosition = Int((floorArray.last?.floor.position.y)!) + distance
            let position = CGPoint(x: xPosition, y: yPosition)
            let size = CGSize(width: 300, height: 30)
            let sortType = Int.random(in: 0..<3)
            let withCoins = Bool.random()
            
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
            let withCoins = false
            var xPosition: Int
            arrayPosition += 1
            if yPositionMultiplier == 2 {
                xPosition = 0
            } else if yPositionMultiplier == 3{
                xPosition = -200
            } else if yPositionMultiplier == 4{
                xPosition = 200
            } else {
                xPosition = Int.random(in: -320...320)
            }
            let yPosition = yPositionMultiplier * distance
            let position = CGPoint(x: xPosition, y: yPosition)
            let size = CGSize(width: 300, height: 30)
            let sortType = Int.random(in: 0..<3)
            
            
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
    
    
}



