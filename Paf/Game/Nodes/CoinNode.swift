//
//  CoinNode.swift
//  Paf
//
//  Created by Anastasia Koldunova on 07.10.2022.
//

import SpriteKit

class CoinNode: SKSpriteNode {

    init(at point: CGPoint) {
        let texture = SKTexture(image: UIImage(named: "coin")!)
        super.init(texture: texture, color: .clear, size: CGSize(width: 32, height: 32))
        zPosition = 4
        position = point
        name = "coin"
        setUpPhysics()
    }
    
    func setUpPhysics() {
        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
//        physicsBody?.affectedByGravity = false
//        physicsBody?.allowsRotation = false
//        physicsBody?.isDynamic = true
//        physicsBody?.mass = 1.0
//        physicsBody?.restitution = 1
//        physicsBody?.friction = 0
//        physicsBody?.usesPreciseCollisionDetection = false
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = PhysicsCategory.character.rawValue
        physicsBody?.categoryBitMask = PhysicsCategory.coin.rawValue
//        physicsBody?.contactTestBitMask = 0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
