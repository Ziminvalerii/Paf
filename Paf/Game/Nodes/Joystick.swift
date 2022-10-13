//
//  Joystick.swift
//  Paf
//
//  Created by Anastasia Koldunova on 28.09.2022.
//

import SpriteKit

struct JoysctickData: CustomStringConvertible {
    var vector = CGVector.zero,
    angle = CGFloat(0)
        
    mutating func reset() {
        vector = CGVector.zero
//        angular = 0
    }
    
    public var description: String {
        return "AnalogStickData(velocity: \(vector), angular: \(vector))"
    }
}

open class JoystickComponent: SKSpriteNode {
    private var kvoContext = UInt8(1)
    var borderWidth = CGFloat(0) {
        didSet {
            redrawTexture()
        }
    }
    
    var borderColor = UIColor.black {
        didSet {
            redrawTexture()
        }
    }
    
    var image: UIImage? {
        didSet {
            redrawTexture()
        }
    }
    
    var diameter: CGFloat {
        get {
            return max(size.width, size.height)
        }
        
        set(newSize) {
            size = CGSize(width: newSize, height: newSize)
        }
    }
    
    var radius: CGFloat {
        get {
            return diameter * 0.5
        }
        
        set(newRadius) {
            diameter = newRadius * 2
        }
    }
    
    //MARK: - DESIGNATED
    init(diameter: CGFloat, color: UIColor? = nil, image: UIImage? = nil) {
        super.init(texture: nil, color: color ?? UIColor.black, size: CGSize(width: diameter, height: diameter))
        addObserver(self, forKeyPath: "color", options: NSKeyValueObservingOptions.old, context: &kvoContext)
        self.diameter = diameter
        self.image = image
        redrawTexture()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObserver(self, forKeyPath: "color")
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        redrawTexture()
    }
    
    private func redrawTexture() {
        
        guard diameter > 0 else {
            print("Diameter should be more than zero")
            texture = nil
            return
        }
        
        let scale = UIScreen.main.scale
        let needSize = CGSize(width: self.diameter, height: self.diameter)
        UIGraphicsBeginImageContextWithOptions(needSize, false, scale)
        let rectPath = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: needSize))
        rectPath.addClip()
        
        if let img = image {
            img.draw(in: CGRect(origin: CGPoint.zero, size: needSize), blendMode: .normal, alpha: 1)
        } else {
            color.set()
            rectPath.fill()
        }
        
        let needImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        texture = SKTexture(image: needImage)
    }
}


class Joystick: SKNode {
    weak var delegate: JoysctickDelegate?
    var substrate: JoystickComponent!
    var stick: JoystickComponent!
    var traking = false
    
    private(set) var data = JoysctickData()
    var tracking = false
    var disabled: Bool {
        get {
            return !isUserInteractionEnabled
        }
        set {
            isUserInteractionEnabled = !newValue
        }
    }
    
    

    init(substrate: JoystickComponent, stick: JoystickComponent) {
        super.init()
        self.substrate = substrate
        substrate.zPosition = 0
        addChild(substrate)
        self.stick = stick
        stick.zPosition = substrate.zPosition + 1
        addChild(stick)
        disabled = false
        let velocityLoop = CADisplayLink(target: self, selector: #selector(listen))
        velocityLoop.add(to: RunLoop.current, forMode: RunLoop.Mode(rawValue: RunLoop.Mode.common.rawValue))
    }
    
    convenience init(diamenters : (substrate: CGFloat, stick: CGFloat?), colors: (substrate: UIColor?, stick: UIColor?)? = nil, images: (substrate: UIImage?, stick: UIImage?)? = nil) {
        let stickDiameter = diamenters.stick ?? diamenters.substrate * 0.5
        let substrate = JoystickComponent(diameter: diamenters.substrate, color: colors?.substrate, image: images?.substrate)
        let stick = JoystickComponent(diameter: stickDiameter,color: colors?.stick, image: images?.stick)
        self.init(substrate: substrate, stick: stick)
    }
    
    convenience init(diameter: CGFloat, colors: (substrate: UIColor?, stick: UIColor?)? = nil, images: (substrate: UIImage?, stick: UIImage?)? = nil) {
        self.init(diamenters: (substrate: diameter, stick: nil), colors: colors, images: images)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func listen() {
        if tracking {
            delegate?.tracking(data: data)
        }
    }
    
    //MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, stick == atPoint(touch.location(in: self)) {
            tracking = true
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            guard tracking else {
                return
            }
            
            let maxDistantion = substrate.radius,
            realDistantion = sqrt(pow(location.x, 2) + pow(location.y, 2)),
            needPosition = realDistantion <= maxDistantion ? CGPoint(x: location.x, y: location.y) : CGPoint(x: location.x / realDistantion * maxDistantion, y: location.y / realDistantion * maxDistantion)
            stick.position = needPosition

            let angle = -atan2(needPosition.x, needPosition.y)
            
            let dx = cos(angle + .pi / 2)
            let dy = sin(angle + .pi / 2)
//            print("DX = \(dx)\n DY = \(dy)")
            data = JoysctickData(vector: CGVector(dx: dx, dy: dy), angle: angle)
//            JoysctickData(vector: CGVector(dx: stick.position.x, dy: stick.position.y), angle: angle)
//            JoysctickData(vector: CGVector(dx: dx, dy: dy), angle: angle)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetStick()
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetStick()
    }
    
    func resetStick() {
        tracking = false
        let moveToBack = SKAction.move(to: CGPoint.zero, duration: 0.1)
        moveToBack.timingMode = .easeOut
        stick.run(moveToBack)
        data.reset()
        delegate?.trakingStopped()
    }
    
}


protocol JoysctickDelegate: AnyObject {
    func trakingStarted()
    func tracking(data: JoysctickData)
    func trakingStopped ()
}
