//
//  SprikeKitHelper.swift
//  Lab5
//
//  Created by James Park on 4/18/25.
//

import Foundation
import SpriteKit

enum Layer:CGFloat {
    case background
    case foreground
    case player
    case collectible
    case ui
}

enum PhysicsCategory {
    static let none:        UInt32 = 0
    static let player:      UInt32 = 1 << 0
    static let collectible: UInt32 = 1 << 1   // pizzas
    static let foreground:  UInt32 = 1 << 2
    static let mudPile:     UInt32 = 1 << 3   // mud
}
