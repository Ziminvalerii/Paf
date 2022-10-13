//
//  PhysicsCategory.swift
//  Paf
//
//  Created by Anastasia Koldunova on 30.09.2022.
//

import UIKit


enum PhysicsCategory {
    case character
    case enemy
    case characterBullet
    case enemyBullet
    case coin
    case other
    
    var rawValue:UInt32 {
        switch self {
        case .character:
           return 0x1 << 0
        case .enemy:
           return 0x1 << 1
        case .characterBullet:
            return 0x1 << 2
        case .enemyBullet:
            return 0x1 << 3
        case .coin:
            return 0x1 << 4
        case .other:
            return 0x1 << 5
        }
    }
}
