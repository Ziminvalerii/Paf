//
//  HealthNode.swift
//  Paf
//
//  Created by Anastasia Koldunova on 30.09.2022.
//

import SpriteKit

class HealthNode: SKSpriteNode {

    init(at position: CGPoint) {
        let texture = SKTexture(image: UIImage(named: "heart")!)
        super.init(texture: texture, color: .clear, size: CGSize(width: 56, height: 56))
        self.position = position
        zPosition = 100
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
