//
//  CGFloat.swift
//  Paf
//
//  Created by Anastasia Koldunova on 29.09.2022.
//

import CoreGraphics
import UIKit



public extension CGFloat {
    func degreesToRadians() -> CGFloat {
     
     return CGFloat.pi * self / 180.0
   }
     
     
      func radiansToDegrees() -> CGFloat {
       return self * 180.0 / CGFloat.pi
     }
}
