//
//  Enemy.swift
//  Paf
//
//  Created by Anastasia Koldunova on 29.09.2022.
//

import SpriteKit

class EnemyNode: SKSpriteNode {
    
    private(set) var isInvisible = false
    private(set) var isFollowing = false
    private(set) var isFacingRight = true
    private(set) var isReloading: Bool = false {
        didSet {
            guard isReloading else {
                return
            }
            run(.wait(forDuration: 1.1)) { [weak self] in
                self?.isReloading = false
            }
        }
    }
    
    let enemyModel = Settings.enemyArray[0]
//    Settings.enemyArray[Int.random(in: 0...4)]
    
    init() {
        let texture = SKTexture(image:enemyModel.image ?? UIImage())
        super .init(texture: texture, color: .clear, size: CGSize(width:80, height: 80))
        name = "enemy"
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = true
        physicsBody?.allowsRotation = false
        physicsBody?.isDynamic = true
        physicsBody?.mass = 8.0
        physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
//        BitMaskCategories.alien
        physicsBody?.contactTestBitMask = PhysicsCategory.characterBullet.rawValue
//        BitMaskCategories.bullet
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func followCharacter(followedNode:SKSpriteNode) {
        
//        let customActionBlock: (SKNode, CGFloat)->Void = { (node, elapsedTime) in
//            guard let scene = self.scene else {return}
//            if let superhero = scene.childNode(withName: "superhero") as? CharacterProtocol {
                print("distance: \(followedNode.position.x -  self.position.x)")
                 let distanseX = followedNode.position.x -  self.position.x
                 let distanseY = followedNode.position.y -  self.position.y
                let xDistanse:CGFloat = distanseX < 0 ? -125 : 125
                let yDistanse:CGFloat = distanseY < 0 ? -125 : 125
                let nodeX = self.position.x + xDistanse /*- scene.size.width/4*/
                let nodeY =  self.position.y + yDistanse /*-  scene.size.height/4*/
                let dx = followedNode.position.x - nodeX
                let dy = followedNode.position.y - nodeY
                print("dx: \(dx)\ndy: \(dy)")
                let angle = atan2(dx,dy)
                self.position.x += angle*1.2
                   self.position.y += cos(angle) * 1.5
        if !isFollowing {
            anEnemy()
        }
//            self.zRotation = angle
//            }
//        }
        
//        let duration = TimeInterval(Int.max) //want the action to run infinitely
//        let followPlayer = SKAction.customAction(withDuration:duration,actionBlock:customActionBlock)
//        self.run(followPlayer ,withKey:"follow")
//        isFollowing = true
    }
    
    func anEnemy() {
        isFollowing = true
        animateTextures()
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
    
    func stopFollowing() {
        isFollowing = false
        removeAction(forKey: "enemy_walking")
    }
    
    func animateTextures() {
        self.run(SKAction.repeatForever(
            SKAction.animate(with: enemyModel.textures,
                                     timePerFrame: 0.1,
                                     resize: false,
                                     restore: true)),
                         withKey:"enemy_walking")

    }
    
//    func removeFollowAction() {
////        self.removeAction(forKey: "enemy_walking")
//        self.removeAction(forKey: "follow")
//        isFollowing = false
//    }
    
    func spawnBullet(followedNode:SKSpriteNode) -> BulletNode {
        let bullet = BulletNode(demage: 100, bulletSpeedMiltiplier: 1.35, distance: 1.0)
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.enemyBullet.rawValue
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.character.rawValue | PhysicsCategory.other.rawValue | PhysicsCategory.characterBullet.rawValue
//        let dx = followedNode.position.x - self.position.x
//        print("dx: \(dx)\n")
        bullet.position = CGPoint(x: position.x + (sin(-zRotation) * size.height / 1.5),
                                  y: position.y + (cos(-zRotation) * size.height / 1.5))
//        bullet.zRotation = CGFloat(isFacingRight ? 270 : 90.0).degreesToRadians()
        isReloading = true
        return bullet
    }
}
