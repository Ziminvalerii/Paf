//
//  Builder.swift
//  Paf
//
//  Created by Anastasia Koldunova on 28.09.2022.
//

import Foundation

protocol BuilderProtocol {
    func createStartViewController(router:RouterProtocol) -> StartGameViewController
    func createGameViewController(router:RouterProtocol) -> GameViewController
    func createShopViewController(router:RouterProtocol) -> ShopViewController
    func createSettingsViewController(router:RouterProtocol) -> SettingsViewController
    func createInfoViewController(router: RouterProtocol) -> InfoViewController
    func createDailyBonusViewController(router: RouterProtocol) -> DailyBonusViewController
}

class Builder: BuilderProtocol {
    
    func createDailyBonusViewController(router: RouterProtocol) -> DailyBonusViewController {
        let vc = DailyBonusViewController.instantiateMyViewController()
        vc.presenter = DailyBonusPresenter(view: vc, router: router)
        return vc
    }
    
    func createInfoViewController(router: RouterProtocol) -> InfoViewController {
        let vc = InfoViewController.instantiateMyViewController()
        vc.presenter = InfoPresenter(view: vc, router: router)
        return vc
    }
    
    func createSettingsViewController(router: RouterProtocol) -> SettingsViewController {
        let vc = SettingsViewController.instantiateMyViewController()
        vc.presenter = SettingsPresenter(view: vc, router: router)
        return vc
    }
    
    func createShopViewController(router: RouterProtocol) -> ShopViewController {
        let vc = ShopViewController.instantiateMyViewController()
        vc.presenter = ShopPresenter(view: vc, router: router)
        return vc
    }
    
    
    func createGameViewController(router: RouterProtocol) -> GameViewController {
        let vc = GameViewController.instantiateMyViewController()
        vc.presenter = GamePresenter(view: vc, router: router)
        return vc
    }
    
    func createStartViewController(router: RouterProtocol) -> StartGameViewController {
        let vc = StartGameViewController.instantiateMyViewController()
        vc.presenter = StartGamePresenter(view: vc, router: router)
        return vc
    }
    
    
}
