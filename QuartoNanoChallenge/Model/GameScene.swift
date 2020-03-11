//
//  GameScene.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 05/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let tapRec = UITapGestureRecognizer()
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    
    private var lastUpdateTime : TimeInterval = 0
    var allowTap: Bool = true
    var wasTapped: Bool = false
    var gameVelocity: Double = 1
    
    var spawiningFloors: SpawningFloors!
    var gameObjects = [GameObject]()
    
    var backgroundSprite = SKSpriteNode(texture: Model.shared.currentBackground)
    var bar = Bar()
    var floor = Floor()
    var boxes = [Box]()
    var head = Box()
    var disableBoxes = [Box]()
    
    var cam = CamControl().cam
    
    enum Side {
        case right
        case left
    }

    override func didMove(to view: SKView) {
        initialSetup()
        
        backgroundSprite.zPosition = -10
        backgroundSprite.anchorPoint = CGPoint(x: 0, y: 0)
        backgroundSprite.position = self.frame.origin
        self.addChild(backgroundSprite)
        
        tapRec.addTarget(self, action: #selector(GameScene.tappedView(_:) ))
        tapRec.numberOfTouchesRequired = 1
        tapRec.numberOfTapsRequired = 1
        self.view!.addGestureRecognizer(tapRec)
        
        swipeRightRec.addTarget(self, action: #selector(GameScene.swipedRight) )
        swipeRightRec.direction = .right
        self.view!.addGestureRecognizer(swipeRightRec)
        
        swipeLeftRec.addTarget(self, action: #selector(GameScene.swipedLeft) )
        swipeLeftRec.direction = .left
        self.view!.addGestureRecognizer(swipeLeftRec)
        
        self.camera = cam
        
        spawiningFloors = SpawningFloors(node: self, cam: cam)
        gameObjects.append(spawiningFloors)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        cam.position.y = boxes[0].box.position.y
        backgroundSprite.position.y = boxes[0].box.position.y - (view?.frame.size.height)!
        checkInternality()
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
            return
        }
        
        let deltaTime = currentTime - lastUpdateTime
        
        if deltaTime >=  8 * 0.01666 && !wasTapped {
            allowTap = true
        }
        
        if wasTapped {
            lastUpdateTime = currentTime
            wasTapped = false
            allowTap = false
        }
        
        for gameObject in gameObjects {
            gameObject.update(deltaTime: deltaTime, velocity: gameVelocity)
        }
    }
    
    func checkInternality() {
        if head.box.position.x > (scene?.size.width)!/2 || head.box.position.x < -(scene?.size.width)!/2 {
            head.box.position.x = -head.box.position.x
        }
        
        for box in disableBoxes {
            if box.box.position.x > (scene?.size.width)!/2 || box.box.position.x < -(scene?.size.width)!/2 {
                box.box.position.x = -box.box.position.x
            }
        }
    }
    
    @objc func tappedView(_ sender:UITapGestureRecognizer) {
        if allowTap {
            allowTap = false
            wasTapped = true
            var verticalSpace : CGFloat
            var horizontalSpace : CGFloat
            
            for floor in spawiningFloors.floorArray {
                
                verticalSpace = head.box.size.height * 3/2 + floor.floor.size.height/2
                horizontalSpace = floor.floor.size.width / 2 + head.box.size.width/2
                
                if (floor.floor.position.y - head.box.position.y) < verticalSpace && (floor.floor.position.y - head.box.position.y) > 0 {
                    
                    if abs(head.box.position.x - floor.floor.position.x) < horizontalSpace {
                        return
                    }
                }
            }
            createBox()
        } else {
            return
        }
            
    }
    
    
    @objc func swipedRight() {
        toppleTower(side: .right)
        cleanBoxArray()
    }
    
    @objc func swipedLeft() {
        toppleTower(side: .left)
        cleanBoxArray()
    }
    
    
    func toppleTower(side: Side) {
        let towerSize = boxes.count
        let force: Int
        
        if (side == .right) {
            force = Model.shared.forceApliedInSwipe / towerSize
        } else {
            force = -Model.shared.forceApliedInSwipe / towerSize
        }
        
        for i in 0..<boxes.count {
            boxes[i].addPhysics()
            
            if i == 0 {
                boxes[i].box.physicsBody?.applyImpulse(CGVector(dx: force * (boxes.count - 1), dy: 0))
            } else {
                boxes[i].box.physicsBody?.applyImpulse(CGVector(dx: force * (i - 1), dy: 0))
            }
        }
    }
    
    // Remove do vetor de boxes principais e adiciona no vetor de boxes desabilitadas
    func cleanBoxArray() {
        
        let boxesSizeVector = boxes.count
        for i in 0..<boxesSizeVector {
            if i != 0 {
                disableBoxes.append(boxes.last!)
                boxes.removeLast()
            }
        }
    }
    
    func initialSetup() {
        //Adicionar background e player
        createFirstFloor()
        createPlayerHead()
    }
    
    func createPlayerHead() {
        let box = Box()
        box.setup(position: CGPoint(x: 0, y: 500))
        box.addPhysics()
        box.box.texture = Model.shared.currentPlayerSkin
        boxes.append(box)
        head = boxes[0]
        addChild(box.box)
    }
   
    func createBox() {
        let head = boxes[0]
        let box = Box()
        box.setup(position: head.box.position)
        box.addPhysics()
        box.addRandomBoxTexture()
        head.box.position = CGPoint(x: head.box.position.x, y: head.box.position.y + head.box.size.width)
        boxes.append(box)
        addChild(box.box)
    }
    
    func createFirstFloor() {
        floor.createFirstFloor()
        addChild(floor.floor)
    }
}
