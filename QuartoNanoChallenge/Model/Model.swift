//
//  Model.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 05/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import Foundation
import SpriteKit
import GoogleMobileAds

class Model {
    static var shared = Model()
    
    let boxSize = CGSize(width: 45, height: 45)
    let boxInitialPosition = CGPoint(x: 0, y: 0)
    let boxMass: CGFloat = 100
    let forceApliedInSwipe = 33000
    let floorStep = 270
    
    let pig = SKTexture(imageNamed: "Pig")
    let bird = SKTexture(imageNamed: "Bird")
    let elephant = SKTexture(imageNamed: "Elephant")
    let giraffe = SKTexture(imageNamed: "Giraffe")
    let hippo = SKTexture(imageNamed: "Hippo")
    let monkey = SKTexture(imageNamed: "Monkey")
    let panda = SKTexture(imageNamed: "Panda")
    let penguin = SKTexture(imageNamed: "Penguin")
    let rabbit = SKTexture(imageNamed: "Rabbit")
    let snake = SKTexture(imageNamed: "Snake")
    
    let pigEar = SKTexture(imageNamed: "Pig ear")
    let birdEar: SKTexture? = SKTexture(imageNamed: "Bird ear")
    let elephantEar = SKTexture(imageNamed: "Elephant ear")
    let giraffeEar = SKTexture(imageNamed: "Giraffe ear")
    let hippoEar = SKTexture(imageNamed: "Hippo ear")
    let monkeyEar = SKTexture(imageNamed: "Monkey ear")
    let pandaEar = SKTexture(imageNamed: "Panda ear")
    let penguinEar: SKTexture? = SKTexture(imageNamed: "Penguin ear")
    let rabbitEar = SKTexture(imageNamed: "Rabbit ear")
    let snakeEar = SKTexture(imageNamed: "Snake ear")
    
    var currentPlayerSkin: SKTexture!
    var currentEars: SKTexture?
    var currentBackground = SKTexture(imageNamed: "background_2")
    
    var rewardedAd: GADRewardedAd? = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
    
        // ID LOJA
        //"ca-app-pub-3143840922595951/3310571075")
        // ID TESTE
        //"ca-app-pub-3940256099942544/1712485313")
    
    
    var character: Int {
        didSet {
            UserDefaults.standard.set(self.currentScore, forKey: "character")
        }
    }
    
    var bestScore: Int {
        didSet {
            UserDefaults.standard.set(self.bestScore, forKey: "bestScore")
            GameCenter.shared.updateScore(with: self.bestScore)
        }
    }

    var currentScore: Int {
        didSet {
            UserDefaults.standard.set(self.currentScore, forKey: "currentScore")
        }
    }
    
    var totalCoins: Int {
        didSet {
            UserDefaults.standard.set(self.bestScore, forKey: " totalCoins")
        }
    }
    
    var currentCoins: Int {
        didSet {
            UserDefaults.standard.set(self.bestScore, forKey: " currentCoins")
        }
    }
    
    private init() {
        rewardedAd?.load(GADRequest()) { error in
            if let error = error {
                // Handle ad failed to load case.
                print("NAO")
                print(error)
            } else {
                // Ad successfully loaded.
                print("BOA")
            }
        }
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore
        {
            print("Not first launch.")
        }
            
        else
        {
            UserDefaults.standard.set(0, forKey: "bestScore")
            UserDefaults.standard.set(0, forKey: "totalCoins")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            UserDefaults.standard.set(0, forKey: "character")
        }
        
        totalCoins = UserDefaults.standard.integer(forKey: "totalCoins")
        currentCoins = UserDefaults.standard.integer(forKey: "currentCoins")
        bestScore = UserDefaults.standard.integer(forKey: "bestScore")
        currentScore = UserDefaults.standard.integer(forKey: "currentScore")
//        character = UserDefaults.standard.integer(forKey: "character")
        character = 10
        switch character {
        case 1:
            currentPlayerSkin = bird
            currentEars = birdEar
        case 2:
            currentPlayerSkin = elephant
            currentEars = elephantEar
        case 3:
            currentPlayerSkin = giraffe
            currentEars = giraffeEar
        case 4:
            currentPlayerSkin = hippo
            currentEars = hippoEar
        case 5:
            currentPlayerSkin = monkey
            currentEars = monkeyEar
        case 6:
            currentPlayerSkin = panda
            currentEars = pandaEar
        case 7:
            currentPlayerSkin = penguin
            currentEars = penguinEar
        case 8:
            currentPlayerSkin = rabbit
            currentEars = rabbitEar
        case 9:
            currentPlayerSkin = snake
            currentEars = snakeEar
        default:
            currentPlayerSkin = pig
            currentEars = pigEar
        }
    }
}

