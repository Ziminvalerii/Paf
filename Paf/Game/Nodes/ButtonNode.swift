//
//  ButtonNode.swift
//  Paf
//
//  Created by Anastasia Koldunova on 29.09.2022.
//

import SpriteKit

protocol ButtonResponder {
    func buttonTriggered(_ node: ButtonNode)
}

enum ButtonNodesIdentifier: String {
    case shotButton = "shotButton"
    case accelerateButton = "accelerateButton"
//    case mixButton = "mixButton"
//    case tip = "tipButton"
//    case playButton = "playButton"
    
}
class ButtonNode: SKSpriteNode {
    var indentifier : ButtonNodesIdentifier?
    var responder: ButtonResponder? {
        guard let responder = scene as? ButtonResponder else {
            return nil
        }
        return responder

    }
    
    //MARK: -Initializer
     init(texture: SKTexture?, color: UIColor, size: CGSize, name: ButtonNodesIdentifier) {
        super.init(texture: texture, color: color, size: size)
         self.name = name.rawValue
         self.indentifier = name
         isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let nodeName = name, let buttonIdentifier = ButtonNodesIdentifier(rawValue: nodeName) else {
            fatalError("Unsupported button name found.")
        }
        self.indentifier = buttonIdentifier
        
        isUserInteractionEnabled = true
    }
    //MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if isUserInteractionEnabled {
            if containsTouches(touches: touches) {
                responder?.buttonTriggered(self)
            }
        }
    }
    
    private func containsTouches(touches: Set<UITouch>) -> Bool {
        guard let scene = scene else { return false }
        
        return touches.contains { touch in
            let touchPoint = touch.location(in: scene)
            let touchedNode = scene.atPoint(touchPoint)
            return touchedNode === self || touchedNode.inParentHierarchy(self)
        }
    }
}
