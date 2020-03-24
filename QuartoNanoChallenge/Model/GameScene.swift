//
//  GameScene.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 05/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var gameViewController: GameViewController!
    
    //Gestures
    let tapRec = UITapGestureRecognizer()
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    
    //Variables for control update and control tap permission
    var lastUpdateTime : TimeInterval = 0
    var allowTap: Bool = true
    var wasTapped: Bool = false
    var gameVelocity: Double = 1
    
    //Flags for view controller
    var runnigAnimation : Bool = true
    
    //Score presentation
    var score: Int = 0
    var scoreText: SKLabelNode!
    var scoreBox: SKSpriteNode!
    
    //Coins presentantation
    var coinsCount: Int = 0
    var coinsText: SKLabelNode!
    var coinFigure: SKSpriteNode!
    var coinBackground: SKSpriteNode!
     
    //Game objects and camera
    var spawiningFloors: SpawningFloors!
    var gameObjects = [GameObject]()
    var backgroundSprite = SKSpriteNode(texture: Model.shared.currentBackground)
    var water = Water()
    var floor = Floor()
    var boxes = [Box]()
    var head = Box()
    var disableBoxes = [Box]()
    var cam = CamControl().cam
    
    //Preload for game over view
    var gameOverView: UIStoryboard = UIStoryboard(name: "GameOver", bundle: nil)
    var controller: GameOverViewController!
    var firstTap: Bool = true
    
    //Sounds ans sounds control
    var lastUpdateTimeForSounds: TimeInterval = 0
    var allowSound: Bool = true
    var wasPlayed: Bool = false
    let iceCollision = CustomSound(fileName: "Pig Colision Ice.wav")
    let dirtCollision = CustomSound(fileName: "Pig Colision Dirt.wav")
    let rockCollision = CustomSound(fileName: "Pig Colision Rock.wav")
    let stackUpSound = CustomSound(fileName: "Stack Up Box(3).wav")
    let stackUpDanied = CustomSound(fileName: "Stack Up Box.wav")
    let swipeSound = CustomSound(fileName: "Swipe.wav")
    let waterSplash = CustomSound(fileName: "Water Splash(3).wav")
    let coinCollected = CustomSound(fileName: "Coin Collected.wav")
    
    //Enumerate for identify swipe side
    enum Side {
        case right
        case left
    }
    
    override func didMove(to view: SKView) {
        
        initialSetup()
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
        
        if firstBody.categoryBitMask == BodyMasks.player && secondBody.categoryBitMask ==  BodyMasks.water {
            
            if score > 0 {
                Model.shared.currentScore = score
            } else {
                Model.shared.currentScore = 0
            }
            
            if score > Model.shared.bestScore {
                Model.shared.bestScore = score
            }
            Model.shared.currentCoins = coinsCount
            Model.shared.totalCoins += Model.shared.currentCoins
            waterSplash.play()
            allowSound = false
            showGameOverView()
            
        } else if firstBody.categoryBitMask == BodyMasks.box && secondBody.categoryBitMask == BodyMasks.water {
            // Tenho que excluir a caixa que caiu na agua
            // Tenho dois vetores de caixa: disableBoxes e boxes
            //Tocar um som
        } else if firstBody.categoryBitMask == BodyMasks.player && secondBody.categoryBitMask == BodyMasks.ice && allowSound {
            iceCollision.play()
            wasPlayed = true
        } else if firstBody.categoryBitMask == BodyMasks.player && secondBody.categoryBitMask == BodyMasks.dirt && allowSound {
            dirtCollision.play()
            wasPlayed = true
        } else if firstBody.categoryBitMask == BodyMasks.player && secondBody.categoryBitMask == BodyMasks.rock && allowSound {
            rockCollision.play()
            wasPlayed = true
        } else if firstBody.categoryBitMask == BodyMasks.player && secondBody.categoryBitMask == BodyMasks.reward {
            secondBody.node?.removeFromParent()
            coinCollected.play()
            coinsCount += 1
            Model.shared.currentCoins = coinsCount
        }
    }
    
    func showGameOverView() {
        controller.gameViewController = self.gameViewController
        controller.gameScene = self
        self.gameViewController.present(controller, animated: true, completion: nil)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if runnigAnimation {
            //Posicoes do score
            score = (Int(cam.position.y) - Model.shared.floorStep * 2 - 37) / 5
            scoreBox.position.y = cam.position.y + gameViewController.height/1.35
            scoreText.position.y = cam.position.y + gameViewController.height/1.4
            
            scoreBox.position.x = 0
            scoreText.position.x = 0
            
            //posicoes da contagem de moedas
            coinsText.position.y = cam.position.y + gameViewController.height/1.38
            coinsText.position.x = gameViewController.width/1.25
            coinsText.text = String(coinsCount)
            
            coinFigure.position.y = cam.position.y + gameViewController.height/1.35
            coinFigure.position.x = coinsText.position.x - scoreBox.size.width/5
            
            
            coinBackground.position.y = cam.position.y + gameViewController.height/1.35
            coinBackground.position.x = coinsText.position.x
          
            //Atribuicao dos valores para aparecer na tela
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
                self.lastUpdateTimeForSounds = currentTime
                return
            }
            
            let deltaTime = currentTime - lastUpdateTime
            let deltaTimeForSound = currentTime - lastUpdateTimeForSounds
            
            if deltaTime >=  8 * 0.01666 && !wasTapped {
                allowTap = true
            }
            
            
            if deltaTimeForSound >= 8 * 0.016666 && !wasPlayed{
                allowSound = true
            } else if wasPlayed {
                lastUpdateTimeForSounds = currentTime
                wasPlayed = false
                allowSound = false
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
            if box.box.position.x > (scene?.size.width)!/2 + 2 || box.box.position.x < -(scene?.size.width)!/2 - 2 {
                box.box.position.x = -box.box.position.x
            }
        }
        
        for i in 1..<boxes.count {
            if boxes[i].box.position.x > (scene?.size.width)!/2 + 2 || boxes[i].box.position.x < -(scene?.size.width)!/2 - 2 {
                boxes[i].box.position.x = -boxes[i].box.position.x
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
                horizontalSpace = floor.floor.size.width / 2
                
                if (floor.floor.position.y - head.box.position.y) < verticalSpace && (floor.floor.position.y - head.box.position.y) > 0 {
                    if abs(head.box.position.x - floor.floor.position.x) < horizontalSpace {
                        stackUpDanied.play()
                        return
                    }
                }
            }
            stackUpSound.play()
            createBox()
            if firstTap {
                water.allowGrowUp = true
                firstTap = false
            }
        } else {
            return
        }
    }
    
    @objc func swipedRight() {
        toppleTower(side: .right)
        cleanBoxArray()
        swipeSound.play()
    }
    
    @objc func swipedLeft() {
        toppleTower(side: .left)
        cleanBoxArray()
        swipeSound.play()
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
        firstTap = true
        allowSound = true
        gameVelocity = 1.0
        self.camera = cam
        spawiningFloors = SpawningFloors(node: self, cam: cam)
        gameObjects.append(spawiningFloors)
        
        addScore()
        addCoinsCount()
        createPlayerHead()
        createWater()
        
        backgroundSprite.zPosition = -10
        backgroundSprite.anchorPoint = CGPoint(x: 0, y: 0)
        backgroundSprite.position = self.frame.origin
        self.addChild(backgroundSprite)
    }
    
    func createWater() {
        water.setup(yPosition: Int(-gameViewController.height/1.5))
        water.allowGrowUp = false
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
        box.box.physicsBody!.collisionBitMask = BodyMasks.ice | BodyMasks.dirt | BodyMasks.rock | BodyMasks.box
        
        //Com quem ele tem contato
        box.physicsBody?.contactTestBitMask = BodyMasks.reward | BodyMasks.water | BodyMasks.ice | BodyMasks.dirt | BodyMasks.rock | BodyMasks.box
        
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
        scoreBox = SKSpriteNode(color: .clear, size: CGSize(width: 300, height: 100))
        scoreText.fontSize = 80
        scoreText.fontName = "Baloo Bhaina Regular"
        scoreText.fontColor = .white
        scoreBox.zPosition = 20
        scoreText.zPosition = 21
        scoreBox = SKSpriteNode(imageNamed: "scoreBox")
        scoreBox.alpha = 0.4
        
        addChild(scoreText)
        addChild(scoreBox)
    }
    
    
    func addCoinsCount() {
        coinsText = SKLabelNode()
        coinsText.fontSize = 50
        coinsText.fontName = "Baloo Bhaina Regular"
        coinsText.fontColor = .white
        coinsText.zPosition = 5
        coinsCount = 0
        addChild(coinsText)
        
        coinBackground = SKSpriteNode(imageNamed: "scoreBox")
        coinBackground.zPosition = 4
        coinBackground.size = CGSize(width: 200, height: 100)
        coinBackground.alpha = 0.4
        addChild(coinBackground)
        
        coinFigure = SKSpriteNode(imageNamed: "coin")
        coinFigure.zPosition = 5
        coinFigure.size = CGSize(width: 50, height: 50)
        addChild(coinFigure)
    }
}
