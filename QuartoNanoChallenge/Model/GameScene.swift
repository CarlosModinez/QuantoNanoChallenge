//
//  GameScene.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 05/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var gameViewController: GameViewController!
    
    let tapRec = UITapGestureRecognizer()
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    
    var lastUpdateTime : TimeInterval = 0
    var allowTap: Bool = true
    var wasTapped: Bool = false
    var gameVelocity: Double = 1
    
    //Flags for view controller
    var initialScreenWasShowed: Bool = false
    var runnigAnimation : Bool = false
    
    var score: Int = 0
    var scoreText: SKLabelNode!
    var scoreBox: SKSpriteNode!
    
    var spawiningFloors: SpawningFloors!
    var gameObjects = [GameObject]()
    
    var backgroundSprite = SKSpriteNode(texture: Model.shared.currentBackground)
    var water = Water()
    var floor = Floor()
    var boxes = [Box]()
    var head = Box()
    var disableBoxes = [Box]()
    var cam = CamControl().cam
    
    var gameOverView: UIStoryboard = UIStoryboard(name: "GameOver", bundle: nil     )
    var controller: GameOverViewController!
    
    enum Side {
        case right
        case left
    }

    override func didMove(to view: SKView) {
        
        gameOverView = UIStoryboard(name: "GameOver", bundle: nil)
        controller = gameOverView.instantiateViewController(withIdentifier: "GameOver") as? GameOverViewController
        controller.gameScene = self
        
        physicsWorld.contactDelegate = self
        
        
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
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.contactTestBitMask == 0 && secondBody.contactTestBitMask ==  6 {
            
            if score > 0 {
                Model.shared.currentScore = score
            } else {
                Model.shared.currentScore = 0
            }

            if score > Model.shared.bestScore {
                Model.shared.bestScore = score
            }
            showGameOverView()
            runnigAnimation = false
            
            
        } else if firstBody.contactTestBitMask == 40 && secondBody.contactTestBitMask ==  6 {
            
            // Tenho que excluir a caixa que caiu na agua
            // Tenho dois vetores de caixa: disableBoxes e boxes
            //Tocar um som
        } 
    }
    
    func showGameOverView() {
        self.gameViewController.present(controller, animated: true, completion: nil)
        controller.updateScore()
    }
    
    private func showInitialScreen() {
        let  firstGameView: UIStoryboard = UIStoryboard(name: "InitialScreen", bundle: nil)
        let controller = firstGameView.instantiateViewController(withIdentifier: "InitialScreen") as! InitialScreenViewController
        
        controller.gameScene = self
        self.gameViewController.present(controller, animated: true, completion: nil)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if initialScreenWasShowed && runnigAnimation {
            
            score = (Int(cam.position.y) - Model.shared.floorStep * 2 - 37) / 5
            scoreBox.position.y = cam.position.y + 500
            scoreText.position.y = cam.position.y + 500
            scoreBox.position.x = 250
            scoreText.position.x = 250
            if score > 0 {
                scoreText.text = String(score)
            } else {
                scoreText.text = String(0)
            }
            cam.position.y = boxes[0].box.position.y
            backgroundSprite.position.y = boxes[0].box.position.y - (view?.frame.size.height)!
            checkInternality()
            
            //Exclui os objetos que a agua passou
            excludeBoxesCauseWater()
            if gameVelocity < 2 {
                gameVelocity += 0.001
            }
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
        } else {
            showInitialScreen()
        }
    }
    
    func excludeBoxesCauseWater() {

        var positionForExclude  = [Int]()
        let disableBoxesSize = disableBoxes.count
        let boxesSize = boxes.count
        
        for i in 0..<disableBoxesSize {
            if disableBoxes[i].box.position.y <= water.water.position.y {
                disableBoxes[i].box.removeFromParent()
                positionForExclude.append(i)
            }
        }
        
//        if positionForExclude.count > 0 {
//            for j in 0..<positionForExclude.count - 1 {
//                disableBoxes.remove(at: positionForExclude[j])
//            }
//        }
        
        positionForExclude.removeAll()
        for i in 0..<boxesSize {
            if boxes[i].box.position.y <= water.water.position.y {
                boxes[i].box.removeFromParent()
                positionForExclude.append(i)
            }
        }
    }
    
    func checkInternality() {
        if head.box.position.x > (scene?.size.width)!/2 + 2 || head.box.position.x < -(scene?.size.width)!/2 - 2{
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
        boxes[0].box.physicsBody?.contactTestBitMask = 0
    }
    
    @objc func swipedLeft() {
        toppleTower(side: .left)
        cleanBoxArray()
        boxes[0].box.physicsBody?.contactTestBitMask = 0
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
        
        gameVelocity = 1.0
        self.camera = cam
        spawiningFloors = SpawningFloors(node: self, cam: cam)
        gameObjects.append(spawiningFloors)
        
        addScore()
        createFirstFloor()
        createPlayerHead()
        createWater()
        
        backgroundSprite.zPosition = -10
        backgroundSprite.anchorPoint = CGPoint(x: 0, y: 0)
        backgroundSprite.position = self.frame.origin
        self.addChild(backgroundSprite)
    }
    
    func createWater() {
        water.setup()
        addChild(water.water)
        gameObjects.append(water)
    }
    
    func createPlayerHead() {
        let box = Box()
        box.setup(position: CGPoint(x: 0, y: Model.shared.floorStep * 2 + Model.shared.floorStep/3))
        box.box.physicsBody?.affectedByGravity = true
        box.box.physicsBody?.isDynamic = true
        box.box.physicsBody?.allowsRotation = true
        box.box.physicsBody?.mass = Model.shared.boxMass
        box.box.physicsBody?.linearDamping = 1.0
                
        //Quem é ele na mascara
        box.box.physicsBody!.categoryBitMask = BodyMasks.player
                
        //Com quem colide
        box.box.physicsBody!.collisionBitMask = BodyMasks.floor | BodyMasks.player | BodyMasks.box
                
        //Com quem ele tem contato
        box.physicsBody?.contactTestBitMask = BodyMasks.reward | BodyMasks.water
        
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
    
    func addScore() {
        scoreText = SKLabelNode()
        scoreBox = SKSpriteNode(color: .white, size: CGSize(width: 100, height: 50))
        scoreText.fontSize = 30
        scoreText.fontColor = .black
        scoreBox.color = .white
        scoreBox.zPosition = 5
        scoreText.zPosition = 6
        addChild(scoreText)
        addChild(scoreBox)
    }
    func createFirstFloor() {
        floor.createFirstFloor()
        addChild(floor.floor)
    }
}
