//
//  Character.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 28/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import Foundation
import UIKit

class Character {
    var image: UIImage
    var characterName: String
    var able: Bool
    var price: Int
    
    init (imageName: String, characterName: String, able: Bool, price: Int) {
        self.image = UIImage(named: imageName)!
        self.characterName = characterName
        self.able = able
        self.price = price
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
