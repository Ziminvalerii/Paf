//
//  ShotButton.swift
//  Paf
//
//  Created by Anastasia Koldunova on 09.10.2022.
//

import SpriteKit

class ShotButton: ButtonNode {
    
    var rechargeDuration: TimeInterval?
    
    private var isReady: Bool = true {
        didSet {
            alpha = isReady ? 1 : 0.5
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize, name: ButtonNodesIdentifier) {
        super.init(texture: texture, color: color, size: size, name: name)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isReady else { return }
        
        responder?.buttonTriggered(self)
        
        if let rechargeDuration = rechargeDuration {
            isReady = false
            run(.wait(forDuration: rechargeDuration)) { [weak self] in
                self?.isReady = true
            }
        }
    }
}
