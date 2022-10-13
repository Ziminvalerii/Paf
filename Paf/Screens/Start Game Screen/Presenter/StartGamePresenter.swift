//
//  StartGamePresenter.swift
//  Paf
//
//  Created by Anastasia Koldunova on 28.09.2022.
//

import UIKit


protocol StartGameView:AnyObject {
    
}

protocol StartGamePresenterProtocol: AnyObject {
    init(view: StartGameView, router: RouterProtocol)
    func goToGameViewController(from vc: UIViewController)
    func goToShopViewController(from vc: UIViewController)
    func goToSettingViewController(from vc: UIViewController)
    func goToInfoVC(from vc: UIViewController)
    func goToBonusVC(from vc: UIViewController)
}

class StartGamePresenter: StartGamePresenterProtocol {
    weak var view: StartGameView?
    private var router: RouterProtocol
    
    required init(view: StartGameView, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func goToBonusVC(from vc: UIViewController) {
        router.presentDailyBonusVC(from: vc)
    }
    
    func goToInfoVC(from vc: UIViewController) {
        router.presentInfoVC(from: vc)
    }
    
    func goToGameViewController(from vc: UIViewController) {
        router.goToGameViewController(from: vc)
    }
    func goToSettingViewController(from vc: UIViewController) {
        router.presentSettingViewController(from: vc)
    }
    func goToShopViewController(from vc: UIViewController) {
        router.presentShopViewController(from: vc)
    }
}
