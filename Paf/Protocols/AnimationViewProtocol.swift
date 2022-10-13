//
//  AnimationViewProtocol.swift
//  Paf
//
//  Created by Anastasia Koldunova on 10.10.2022.
//

import UIKit

protocol AnimationViewProtocol {
    func animateIn(_ view: UIView, overlay: UIView)
    func animateOut(_ view : UIView, overlay: UIView)
}

extension AnimationViewProtocol {
    func animateIn(_ view: UIView, overlay: UIView) {
        view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        view.alpha = 0
        overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        UIView.animate(withDuration: 0.4) {
            view.alpha = 1
            view.transform = CGAffineTransform.identity
            overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        }
    }
    
    func animateOut(_ view : UIView, overlay: UIView) {
        UIView.animate(withDuration: 0.4) {
            view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            view.alpha = 0
            overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        } completion: { (_) in
            view.removeFromSuperview()
            overlay.removeFromSuperview()
        }
    }
}
