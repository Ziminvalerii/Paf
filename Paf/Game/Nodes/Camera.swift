//
//  Camera.swift
//  Paf
//
//  Created by Anastasia Koldunova on 03.10.2022.
//

import SpriteKit

class Camera: SKCameraNode {
    
    var verticalRange: ClosedRange<CGFloat>!
    var horizontalRange: ClosedRange<CGFloat>!
    
    weak var leadingNode: SKSpriteNode?
    
    func follow() {
        guard let leadingPosition = leadingNode?.position else {
            return
        }
        
        if horizontalRange.contains(leadingPosition.x) {
            position.x = leadingPosition.x
        }
        if verticalRange.contains(leadingPosition.y) {
            position.y = leadingPosition.y
        }

    }
    
}
