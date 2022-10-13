//
//  BulletNode.swift
//  Paf
//
//  Created by Anastasia Koldunova on 29.09.2022.
//

import SpriteKit

class BulletNode: SKSpriteNode {
    let demage: Int
    let bulletSpeedMiltiplier : CGFloat
    let distance : TimeInterval
    
    init(demage: Int, bulletSpeedMiltiplier: CGFloat, distance: TimeInterval) {
        self.demage = demage
        self.bulletSpeedMiltiplier = bulletSpeedMiltiplier
        self.distance = distance
        let texture = SKTexture(image: UIImage(named: "bullet")!)
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: 8, height: 21))
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = true
        physicsBody?.allowsRotation = false
        physicsBody?.isDynamic = true
        physicsBody?.collisionBitMask = 0
        name = "bullet"
        
        zPosition = 20
    }
    
    func applyImpulse() {
        let vector = CGVector(dx: bulletSpeedMiltiplier * sin(-zRotation),
                              dy: bulletSpeedMiltiplier * cos(-zRotation))
        
        physicsBody?.applyImpulse(vector)
                
        run(.wait(forDuration: distance)) { [weak self] in
            self?.run(.fadeOut(withDuration: 0.15)) {
                self?.removeFromParent()
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
