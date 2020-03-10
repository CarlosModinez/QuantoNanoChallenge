//
//  GameObject.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 09/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import Foundation
import SpriteKit

protocol GameObject {
    func update(deltaTime: TimeInterval, velocity: Double)
}
