//
//  EnemyModel.swift
//  Paf
//
//  Created by Anastasia Koldunova on 30.09.2022.
//

import UIKit
import SpriteKit


struct EnemyModel {
    public let index:Int
    public let demage: Int
    public var image: UIImage? {
        return UIImage(named: "enemy\(index)")
    }
    
    public var textures: [SKTexture] {
        return [SKTexture(image: image!), SKTexture(image: UIImage(named: "enemy\(index)1")!), SKTexture(image: UIImage(named: "enemy\(index)2")!), SKTexture(image: UIImage(named: "enemy\(index)2")!)]
    }
    
    
}
