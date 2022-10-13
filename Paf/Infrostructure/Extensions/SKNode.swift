//
//  SKNdoe.swift
//  Paf
//
//  Created by Anastasia Koldunova on 04.10.2022.
//

import SpriteKit


extension SKNode {
    func isVisible(for node: SKNode) -> Bool {
        let screen = CGSize(width: UIScreen.main.bounds.width ,
                            height: UIScreen.main.bounds.height )
        
        let xRange = (node.position.x - screen.width / 2)...(node.position.x + screen.width / 2)
        let yRange = (node.position.y - screen.height / 2)...(node.position.y + screen.height / 2)
        
        return (xRange.contains(position.x) && yRange.contains(position.y))
    }
}
