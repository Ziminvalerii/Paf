//
//  PlayerModel.swift
//  Paf
//
//  Created by Anastasia Koldunova on 29.09.2022.
//

import UIKit
import SpriteKit


struct PlayerModel {
    
    public let index : Int
    public var image : UIImage? {
        return UIImage(named: "player\(index)")
    }
    public let speed: Int
    public var textures: [SKTexture] {
        return [SKTexture(image: UIImage(named: "player\(index)")!), SKTexture(image: UIImage(named: "player\(index)1")!), SKTexture(image: UIImage(named: "player\(index)2")!), SKTexture(image: UIImage(named: "player\(index)3")!), SKTexture(image: UIImage(named: "player\(index)4")!)]
    }
    
}

