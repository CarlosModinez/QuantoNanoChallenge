//
//  Model.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 05/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import Foundation
import SpriteKit

class Model {
    static var shared = Model()
    
    let boxSize = CGSize(width: 45, height: 45)
    let boxInitialPosition = CGPoint(x: 0, y: 0)
    let boxMass: CGFloat = 100
    let forceApliedInSwipe = 33000
    let floorStep = 270
    var currentPlayerSkin = SKTexture(imageNamed: "Bird")
    var currentBackground = SKTexture(imageNamed: "background_2")
    
    
    
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
        }
        
        totalCoins = UserDefaults.standard.integer(forKey: "totalCoins")
        currentCoins = UserDefaults.standard.integer(forKey: "currentCoins")
        bestScore = UserDefaults.standard.integer(forKey: "bestScore")
        currentScore = UserDefaults.standard.integer(forKey: "currentScore")
    }
    
}
