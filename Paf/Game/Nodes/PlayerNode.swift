//
//  PlayerNode.swift
//  Paf
//
//  Created by Anastasia Koldunova on 28.09.2022.
//

import SpriteKit

class PlayerNode: SKSpriteNode {
    
    private(set) var isInvisible = false
    let model = Settings.selectedCharacter
//    Settings.playerArray[1]
    private(set) var isAnimating = false
    private(set) var isFacingRight = true
    private var moveVector:CGVector = .zero
    
    private lazy var speedMultiplier: CGFloat = 2.5
//    CGFloat(model.speed / 200)
    
    init(at position: CGPoint) {
        let texture = SKTexture(image: model.image ?? UIImage())
        super.init(texture: texture, color: .clear, size: texture.size())
        self.position = position
        setUpPhysicBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func dissapearAnimation() {
        guard !isInvisible else { return }
        isInvisible = true
        self.run(SKAction.fadeOut(withDuration: 0.3))
    }
    
    func appearAnimation() {
        guard isInvisible else { return }
        isInvisible = false
        self.run(SKAction.fadeIn(withDuration: 0.3))
    }
    
    func accelerate() {
        let defaultMultiplier = speedMultiplier
        speedMultiplier *= 2
        
//        let particle = createParticle()
//        addChild(particle)
        
//        if !AudioManager.shared.isSilent {
//            run(.playSoundFileNamed("speed", waitForCompletion: true))
//        }
        if let duration = AmplifierManager.accleration {
            run(.wait(forDuration: duration)) { [weak self] in
                self?.speedMultiplier = defaultMultiplier
                
                //            particle.run(.fadeOut(withDuration: 0.35)) {
                //                particle.removeFromParent()
                //            }
            }
        }
    }
    
    func spawnBullet() -> BulletNode{
        let bulletSpeed = AmplifierManager.bulletSpeed ?? 1.35
        let distance = AmplifierManager.bulletDistanse ?? 1
        let bullet = BulletNode(demage: 100, bulletSpeedMiltiplier: bulletSpeed, distance: distance)
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.characterBullet.rawValue
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue | PhysicsCategory.other.rawValue | PhysicsCategory.enemyBullet.rawValue
        bullet.position = CGPoint(x: position.x + (sin(-zRotation) * size.height / 1.5),
                                  y: position.y + (cos(-zRotation) * size.height / 1.5))
        bullet.zRotation = zRotation
        return bullet
    }
    
    
    
    func move(by vector: CGVector, rotation: CGFloat) {
        print("DX: \(vector.dy)")
        self.position.x += (vector.dx * speedMultiplier)
        self.position.y += (vector.dy * speedMultiplier)
        
        self.zRotation = rotation
        self.moveVector = vector
        
        
        if !self.isAnimating {
            animateMoving()
        }
    }
    
    func animateMoving() {
        let clickSound = SKAction.playSoundFileNamed("footsteps.mp3", waitForCompletion: false)
//        clickSound.
//        self.run(clickSound,withKey: "footstepsAc")
        AudioManager.shared.playSound(.footSteps)
        self.run(SKAction.repeatForever(
            SKAction.animate(with: model.textures,
                                     timePerFrame: 0.1,
                                     resize: true,
                                     restore: false)),
                         withKey:"walking")

        isAnimating = true
    }
    
    func animateDeadth(complition: @escaping () -> Void) {
        let textures = [SKTexture(image: model.image ?? UIImage()), SKTexture(image: UIImage(named: "ghost")!)]
        self.run(SKAction.fadeOut(withDuration: 0.1)) {
            self.texture = SKTexture(image: UIImage(named: "ghost")!)
            self.run(SKAction.fadeIn(withDuration: 0.1)) {
                complition()
            }
        }
    }
    
    func stopMoving() {
        AudioManager.shared.gunShotPlayer?.pause()
        isAnimating = false
        if action(forKey: "walking") != nil {
            self.removeAction(forKey: "walking")
        }
        self.texture = SKTexture(image: model.image ?? UIImage())
//        removeAllActions()
//        self.removeAction(forKey: "footstepsAc")
        physicsBody?.velocity = .zero
//        physicsBody?.applyImpulse(CGVector(dx: moveVector.dx * speedMultiplier * 200,
//                                           dy: moveVector.dy * speedMultiplier * 200))
    
    }
    
    func setUpPhysicBody() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = true
        physicsBody?.allowsRotation = false
        physicsBody?.isDynamic = true
        physicsBody?.mass = 8.0
        
        physicsBody?.categoryBitMask = PhysicsCategory.character.rawValue
        physicsBody?.contactTestBitMask = PhysicsCategory.enemyBullet.rawValue | PhysicsCategory.coin.rawValue
        
    }
    
}
