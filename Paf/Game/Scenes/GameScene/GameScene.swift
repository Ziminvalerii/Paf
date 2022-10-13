//
//  GameScene.swift
//  Paf
//
//  Created by Anastasia Koldunova on 28.09.2022.
//

import SpriteKit
import GameplayKit


protocol GameOverDelegate: AnyObject {
    func gameOver(win:Bool)
}


class GameScene: SKScene {
    
    weak var gameoverDelegate: GameOverDelegate?
    weak var parantVC: UIViewController?
    
    var curCoins = 0 {
        didSet {
            let label = coinsLabel.childNode(withName: "coinLabel") as? SKLabelNode
            label?.text = curCoins.description
        }
    }
    
    private lazy var coinsLabel: SKSpriteNode = {
        let coinTexture = SKTexture(imageNamed: "coinShop")
        let coin = SKSpriteNode(texture: coinTexture, color: .clear, size: CGSize(width: 48, height: 48))
        coin.zPosition = 200
        let label = SKLabelNode()
        label.fontName = "Copperplate"
        label.zPosition = 20
        label.name = "coinLabel"
        label.fontSize = 40
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .right
        label.position = CGPoint(x: -32, y: 0)
        label.text = curCoins.description
        coin.addChild(label)
        let pausePoint = (self.parantVC as? GameViewController)?.pauseButton.center
        let pPoint = CGPoint(x: (pausePoint!.x + 42), y: pausePoint!.y)
        let scenePoint = self.scene?.convertPoint(fromView: pPoint )
        coin.position = CGPoint(x: (self.size.width / 2) - 114, y: scenePoint?.y ?? (self.size.height / 2) - 132)
        return coin
    }()
    
    private lazy var enemyCountLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.fontName = "Copperplate"
        label.fontSize = 48
        label.zPosition = 100
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        let pausePoint = (self.parantVC as? GameViewController)?.pauseButton.center
        let pPoint = CGPoint(x: (pausePoint!.x + 42), y: pausePoint!.y)
        let scenePoint = self.scene?.convertPoint(fromView: pPoint )
        label.position = CGPoint(x: 0, y: scenePoint?.y ?? (self.size.height / 2) - 132)
        return label
    }()
    private lazy var shotButton: ShotButton = {
        
        let texture = SKTexture(image: UIImage(named: "shoot")!)
        let button = ShotButton(texture: texture, color: .clear, size: CGSize(width: 150, height: 150), name: .shotButton)
        button.rechargeDuration = 1
        button.zPosition = 100
        if Defaults.invertedControl {
            button.position = CGPoint(x: -(size.width / 2) + 200, y: -(size.height / 2) + 200)
        } else {
            button.position = CGPoint(x: (size.width / 2) - 200, y: -(size.height / 2) + 200)
        }
        return button
    }()
    
    private lazy var accelerateButton: ShotButton = {
        let texture = SKTexture(image: UIImage(named: "accelerateButton")!)
        let button = ShotButton(texture: texture, color: .clear, size: CGSize(width: 150, height: 150), name: .accelerateButton)
        button.rechargeDuration = (AmplifierManager.accleration ?? 3.0) + 3.0
        button.isHidden = AmplifierManager.accleration == nil
        button.zPosition = 100
        if Defaults.invertedControl {
            button.position = CGPoint(x: (-(size.width / 2) + 200) + 150 + 24, y: -(size.height / 2) + 200)
        } else {
            button.position = CGPoint(x: (size.width / 2) - 200 - 150 - 24, y: -(size.height / 2) + 200)
        }
        return button
    }()
    
    private lazy var joystick: Joystick = {
        let joystick = Joystick(diameter: 200.0, colors: nil,
                                images: (substrate: UIImage(named: "substrate"),
                                         stick: UIImage(named: "stick")))
        joystick.zPosition = 100
        if Defaults.invertedControl {
            joystick.position = CGPoint(x: (size.width / 2) - 200,
                                        y: -(size.height / 2) + 200)
        } else {
            joystick.position = CGPoint(x: -(size.width / 2) + 200,
                                        y: -(size.height / 2) + 200)
        }
        joystick.delegate = self
        return joystick
    }()
    
    private lazy var enemy : EnemyNode = {
        let enemy = EnemyNode()
        enemy.zPosition = 5
        enemy.position = CGPoint(x: (size.width / 2) - 200, y: 200)
        return enemy
    }()
    
    private lazy var player: PlayerNode = {
        let point = CGPoint.zero
        let character = PlayerNode(at: point)
        character.zPosition = 5
        return character
    }()
    
    private lazy var health: [HealthNode] = {
        var array = [HealthNode]()
        let pausePoint = (self.parantVC as? GameViewController)?.pauseButton.center
        let pPoint = CGPoint(x: (pausePoint!.x + 42), y: pausePoint!.y)
        let scenePoint = self.scene?.convertPoint(fromView: pPoint )
        let health = AmplifierManager.health ?? 3
        let yPos = scenePoint?.y
        let xPos = scenePoint?.x
        for i in  0 ... health - 1 {
            let pos = CGPoint(x: xPos!  + (60 * CGFloat(i)),
                              y: yPos ?? (self.size.height / 2) - 132)
            //(self.size.height / 2) - 132
            // -(self.size.width / 2) + 114
            let healthNode = HealthNode(at: pos)
            array.append(healthNode)
        }
        return array
    }()
    
    private let cameraNode = Camera()
    
    private var background: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        addChild(player)
        
        //        addChild(enemy)
        // Get label node from scene and store it for use later
        
        background = scene?.childNode(withName: "background") as? SKSpriteNode
        setUpBackgroundPhysics()
        spawnEnemies()
        setupCamera()
        setUpPhysicWorld()
        spawnBrush()
        setUpContact()
        //        enemy.followCharacter(followedNode: player)
        
    }
    
    func setUpPhysicWorld() {
        //        physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        //        physicsBody?.isDynamic = false
        //        physicsBody?.affectedByGravity = false
        //        physicsBody?.allowsRotation = false
        //        physicsBody?.pinned = true
    }
    
    func setUpBackgroundPhysics() {
        background.physicsBody = SKPhysicsBody(edgeLoopFrom: background.frame)
        //        SKPhysicsBody(rectangleOf: background.size)
        //        SKPhysicsBody(edgeLoopFrom: background.frame)
        
        background.physicsBody?.isDynamic = false
        background.physicsBody?.affectedByGravity = false
        background.physicsBody?.allowsRotation = false
        background.physicsBody?.pinned = true
        
    }
    
    func spawnBrush() {
        for i in 0 ... 3 {
            var randomX = CGFloat.random(in: -background.size.width/2 ... background.size.width/2)
            var randomY = CGFloat.random(in: -(background.size.height/2 - 64) ... background.size.height/2)
            let brush = BrushNode()
            var house = scene?.atPoint(CGPoint(x: randomX, y: randomY))
            while house?.name == "house" {
                randomX = CGFloat.random(in: -(background.size.width/2 - 100) ... (background.size.width/2 - 100))
                randomY = CGFloat.random(in: -(background.size.height/2 - 100) ... (background.size.height/2 - 100))
                house = scene?.atPoint(CGPoint(x: randomX, y: randomY))
            }
            brush.position = CGPoint(x: randomX, y: randomY)
            addChild(brush)
        }
    }
    
    func spawnEnemies() {
        let count: Int
        switch Settings.curLevel {
        case 0:
            count = 1
        case 1 ... 4:
            count = Int.random(in: 1 ... 3)
        case 5 ... 8 :
            count = Int.random(in: 2 ... 6)
        case 8 ...  11:
            count = Int.random(in: 4 ... 6)
        case 12 ... 15:
            count = Int.random(in: 5 ... 7)
        case 16 ... 25:
            count = Int.random(in: 6 ... 9)
        case 26 ... 30:
            count = Int.random(in: 8 ... 12)
        case 31 ... 40:
            count = Int.random(in: 9 ... 14)
        default:
            count = Int.random(in: 12 ... 20)
        }
        
        for i in 0 ... count {
            var randomX = CGFloat.random(in: -(background.size.width/2 - 100) ... (background.size.width/2 - 100))
            var randomY = CGFloat.random(in: -(background.size.height/2 - 100) ... (background.size.height/2 - 100))
            let enemy = EnemyNode()
            enemy.zPosition = 5
//            let houseArray = scene?.children.filter({$0.name == "house"}) as! [SKSpriteNode]
            var house = scene?.atPoint(CGPoint(x: randomX, y: randomY))
            
            while house?.name == "house" || ((randomX < 200 && randomX > -200) || (randomY < 200 && randomY > -200)){
                randomX = CGFloat.random(in: -(background.size.width/2 - 100) ... (background.size.width/2 - 100))
                randomY = CGFloat.random(in: -(background.size.height/2 - 100) ... (background.size.height/2 - 100))
                house = scene?.atPoint(CGPoint(x: randomX, y: randomY))
            }
                enemy.position = CGPoint(x: randomX, y: randomY)
            addChild(enemy)
            }
        let c = scene?.children.filter({$0.name == "enemy"}).count
        enemyCountLabel.text = "Enemies remaining: \(c?.description ?? "")"
//        enemyCountLabel.position = CGPoint(x: 0, y: (self.size.height / 2) - 132)
        cameraNode.addChild(enemyCountLabel)
    }
    
    private func setUpContact() {
        let houseArray = scene?.children.filter({$0.name == "house"}) as! [SKSpriteNode]
        houseArray.forEach { item in
            item.physicsBody?.categoryBitMask = PhysicsCategory.other.rawValue
            item.physicsBody?.contactTestBitMask = PhysicsCategory.characterBullet.rawValue | PhysicsCategory.enemyBullet.rawValue
        }
        let woodArray = scene?.children.filter({$0.name == "wood"}) as! [SKSpriteNode]
        woodArray.forEach { item in
            item.physicsBody?.categoryBitMask = PhysicsCategory.other.rawValue
            item.physicsBody?.contactTestBitMask = PhysicsCategory.characterBullet.rawValue | PhysicsCategory.enemyBullet.rawValue
        }
        let carArray = scene?.children.filter({$0.name == "car"}) as! [SKSpriteNode]
        carArray.forEach { item in
            item.physicsBody?.categoryBitMask = PhysicsCategory.other.rawValue
            item.physicsBody?.contactTestBitMask = PhysicsCategory.characterBullet.rawValue | PhysicsCategory.enemyBullet.rawValue
        }
    }
        
    
    private func setupCamera() {
        camera = cameraNode
        
        cameraNode.horizontalRange = -((background.size.width - size.width) / 2)...((background.size.width - size.width) / 2)
        cameraNode.verticalRange = -((background.size.height - size.height) / 2)...(((background.size.height - size.height) / 2) /*+ 100 */)
        cameraNode.leadingNode = player
        
        DispatchQueue.main.async {
            self.addChild(self.cameraNode)
            self.cameraNode.addChild(self.joystick)
            self.cameraNode.addChild(self.shotButton)
            self.cameraNode.addChild(self.accelerateButton)
            self.cameraNode.addChild(self.coinsLabel)
            for i in self.health {
                self.cameraNode.addChild(i)
            }
        }
        
    }
    
    //MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        cameraNode.follow()
        
        //        if
        //        enemy.zRotation = angle
        
        let brushesArray = scene?.children.filter({$0.name == "brush"})
        let filtedArr = brushesArray?.filter({$0.intersects(player)})
        let isPlayerInvisible = !(filtedArr?.isEmpty ?? false) && !(filtedArr?.count == 0)
        if  isPlayerInvisible {
            player.dissapearAnimation()
        } else {
            player.appearAnimation()
        }
        
        let enemies = scene?.children.filter({$0.name == "enemy"}) as! [EnemyNode]
        enemies.forEach { enemy in
            let enInsideBrush = brushesArray?.filter({$0.intersects(enemy)})
            if !(enInsideBrush?.isEmpty ?? false) && !(enInsideBrush?.count == 0) {
                enemy.dissapearAnimation()
            } else {
                enemy.appearAnimation()
            }
            if player.isVisible(for: enemy) && !isPlayerInvisible {
                enemy.followCharacter(followedNode: player)
            } else {
                enemy.stopFollowing()
            }
            let angle = -atan2(self.player.position.x - enemy.position.x,
                               self.player.position.y - enemy.position.y)
            enemy.zRotation = angle
            guard !enemy.isReloading else {
                return
            }
            if !isPlayerInvisible {
                let bullet = enemy.spawnBullet(followedNode: player)
                bullet.zRotation = angle
                addChild(bullet)
                bullet.applyImpulse()
            }
        }
        
    }
    
}

extension GameScene: JoysctickDelegate {
    func trakingStarted() {
        
    }
    
    func tracking(data: JoysctickData) {
        guard !self.isPaused else { return }
        self.player.move(by: data.vector, rotation: data.angle)
    }
    
    func trakingStopped() {
        guard !self.isPaused else { return }
        self.player.stopMoving()
    }
    
    
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        let isAlientWasShot: Bool = ((bodyA.categoryBitMask == PhysicsCategory.characterBullet.rawValue) && (bodyB.categoryBitMask == PhysicsCategory.enemy.rawValue)) || ((bodyA.categoryBitMask == PhysicsCategory.enemy.rawValue) && (bodyB.categoryBitMask == PhysicsCategory.characterBullet.rawValue))
        let isPlayerWasShot: Bool = ((bodyA.categoryBitMask == PhysicsCategory.enemyBullet.rawValue) && (bodyB.categoryBitMask == PhysicsCategory.character.rawValue)) || ((bodyA.categoryBitMask == PhysicsCategory.character.rawValue) && (bodyB.categoryBitMask == PhysicsCategory.enemyBullet.rawValue))
        let isCoinWasTaken: Bool = ((bodyA.categoryBitMask == PhysicsCategory.coin.rawValue) && (bodyB.categoryBitMask == PhysicsCategory.character.rawValue) || (bodyA.categoryBitMask == PhysicsCategory.character.rawValue) && (bodyB.categoryBitMask == PhysicsCategory.coin.rawValue))
        let isContactOther: Bool = ((bodyA.categoryBitMask == PhysicsCategory.characterBullet.rawValue || bodyA.categoryBitMask == PhysicsCategory.enemyBullet.rawValue) && (bodyB.categoryBitMask == PhysicsCategory.other.rawValue) || (bodyA.categoryBitMask == PhysicsCategory.other.rawValue) && (bodyB.categoryBitMask == PhysicsCategory.characterBullet.rawValue || bodyB.categoryBitMask == PhysicsCategory.enemyBullet.rawValue))
        let isBulletContact : Bool = ((bodyA.categoryBitMask == PhysicsCategory.characterBullet.rawValue) && (bodyB.categoryBitMask == PhysicsCategory.enemyBullet.rawValue) || (bodyA.categoryBitMask == PhysicsCategory.enemyBullet.rawValue) && (bodyB.categoryBitMask == PhysicsCategory.characterBullet.rawValue))
        if isAlientWasShot {
            alienWasShot(bodyA: bodyA, bodyB: bodyB)
        }
        if isPlayerWasShot {
            playerWasShot(bodyA: bodyA, bodyB: bodyB)
        }
        if isCoinWasTaken {
            coinWasPicked(bodyA: bodyA, bodyB: bodyB)
        }
        if isContactOther || isBulletContact {
            removeBullet(bodyA: bodyA, bodyB: bodyB)
        }
    }
    
    private func removeBullet(bodyA: SKPhysicsBody, bodyB: SKPhysicsBody) {
        (bodyA.node as? BulletNode)?.removeFromParent()
        (bodyB.node as? BulletNode)?.removeFromParent()
    }
    
   private func coinWasPicked(bodyA: SKPhysicsBody, bodyB: SKPhysicsBody) {
       (bodyA.node as? CoinNode)?.removeFromParent()
       (bodyB.node as? CoinNode)?.removeFromParent()
//            collectCoin
       AudioManager.shared.vibrate()
       curCoins += 100
       Settings.coins += 100
       let ouchSound = SKAction.playSoundFileNamed("collectCoin.mp3", waitForCompletion: false)
       run(ouchSound)
    }
    
    private func alienWasShot(bodyA: SKPhysicsBody, bodyB: SKPhysicsBody) {
        print("allien was shoot")
        
        let ouchSound = SKAction.playSoundFileNamed("enemyDistroyed.mp3", waitForCompletion: false)
        run(ouchSound)
        var position = (bodyA.node as? EnemyNode)?.position
        if position == nil {
            position = (bodyB.node as? EnemyNode)?.position
        }
        bodyA.node?.removeFromParent()
        bodyB.node?.removeFromParent()
        if let position = position {
            let coin = CoinNode(at: position)
            addChild(coin)
            coin.run(SKAction.fadeIn(withDuration: 1))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let enemies = self.children.filter({$0.name == "enemy"})
            let count = enemies.count
            self.enemyCountLabel.text = "Enemies remaining: \(count.description)"
            if enemies.count == 0 {
                Settings.curLevel += 1
                self.curCoins += 100
                Settings.coins += 100
                self.gameoverDelegate?.gameOver(win: true)
            }
        }
        
    }
    
   private func playerWasShot(bodyA: SKPhysicsBody, bodyB: SKPhysicsBody) {
        (bodyA.node as? BulletNode)?.removeFromParent()
        (bodyB.node as? BulletNode)?.removeFromParent()
       AudioManager.shared.vibrate()
        let ouchSound = SKAction.playSoundFileNamed("ouch.mp3", waitForCompletion: false)
        run(ouchSound)
        guard !health.isEmpty else {
            return
        }
        health.removeLast().removeFromParent()
        if health.isEmpty {
            AudioManager.shared.gunShotPlayer?.pause()
            player.animateDeadth {
                self.gameoverDelegate?.gameOver(win: false)
            }
        }
        print("The main character was schoot")
    }
}

extension GameScene: ButtonResponder {
    func buttonTriggered(_ node: ButtonNode) {
        let id = node.indentifier
        switch id {
        case .shotButton:
            let bullet = player.spawnBullet()
            addChild(bullet)
            bullet.applyImpulse()
            let clickSound = SKAction.playSoundFileNamed("shootSound.mp3", waitForCompletion: false)
            run(clickSound)
        case .accelerateButton:
            player.accelerate()
        default:
            break;
        }
    }
    
    
}
