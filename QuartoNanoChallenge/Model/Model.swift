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
    let boxSize = CGSize(width: 40, height: 40)
    let boxInitialPosition = CGPoint(x: 0, y: 0)
    
    let boxMass: CGFloat = 100
    let forceApliedInSwipe = 30000
    
    init() {
        
    }
}
