//
//  GamePresenter.swift
//  Paf
//
//  Created by Anastasia Koldunova on 28.09.2022.
//

import UIKit


protocol GameView:AnyObject {
    
}

protocol GamePresenterProtocol: AnyObject {
    init(view: GameView, router: RouterProtocol)
    func dismiss(_ vc:UIViewController)
}

class GamePresenter: GamePresenterProtocol {
    weak var view: GameView?
    private var router: RouterProtocol
    
    required init(view: GameView, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func dismiss(_ vc:UIViewController) {
        router.dismissViewController(vc)
    }
    
    
}
