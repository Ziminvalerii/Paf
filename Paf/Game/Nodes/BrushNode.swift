//
//  BrushNode.swift
//  Paf
//
//  Created by Anastasia Koldunova on 06.10.2022.
//

import SpriteKit

class BrushNode: SKSpriteNode {
    
    init() {
        let texture = SKTexture(image: UIImage(named: "brush")!)
        super.init(texture: texture, color: .clear, size: CGSize(width: 100, height: 100))
        zPosition = 20
        name = "brush"
//        physicsBody = SKPhysicsBody(rectangleOf: size)
//        physicsBody?.affectedByGravity = false
//        physicsBody?.allowsRotation = false
//        physicsBody?.isDynamic = false
//        physicsBody?.pinned = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
