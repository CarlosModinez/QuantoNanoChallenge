//
//  BodyMasks.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 05/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import Foundation

class BodyMasks {
    static let background : UInt32 = 0x1 << 0 // 1
    static let player     : UInt32 = 0x1 << 1 // 2
    static let box        : UInt32 = 0x1 << 2 // 4
    static let water      : UInt32 = 0x1 << 3 // 8
    static let ice        : UInt32 = 0x1 << 4 // 16
    static let dirt       : UInt32 = 0x1 << 5 // 32
    static let rock       : UInt32 = 0x1 << 6 // 64
    static let reward     : UInt32 = 0x1 << 7 // 128
}
