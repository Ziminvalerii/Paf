//
//  Router.swift
//  Paf
//
//  Created by Anastasia Koldunova on 28.09.2022.
//

import UIKit


protocol RouterProtocol {
    //MARK: - Properties
    var builder: BuilderProtocol {get set}
    //MARK: - Methonds
    func presentStartGameController() -> StartGameViewController
    func goToGameViewController(from vc: UIViewController)
    func presentShopViewController(from vc: UIViewController)
    func presentSettingViewController(from vc:UIViewController)
    func dismissViewController(_ vc: UIViewController)
    func presentInfoVC(from vc: UIViewController)
    func presentDailyBonusVC(from vc: UIViewController)
}

class Router: RouterProtocol {
   
    var builder: BuilderProtocol
    
    init(builder: BuilderProtocol) {
        self.builder = builder
    }
    
    func presentInfoVC(from vc: UIViewController) {
        let goToVC = builder.createInfoViewController(router: self)
        goToVC.modalTransitionStyle = .crossDissolve
        goToVC.modalPresentationStyle = .fullScreen
        vc.present(goToVC, animated: true)
    }
    
    func presentStartGameController() -> StartGameViewController {
        return builder.createStartViewController(router: self)
    }
    
    func goToGameViewController(from vc: UIViewController) {
        let goToVC = builder.createGameViewController(router: self)
        goToVC.modalTransitionStyle = .crossDissolve
        goToVC.modalPresentationStyle = .fullScreen
        vc.present(goToVC, animated: true)
    }
    func presentShopViewController(from vc: UIViewController) {
        let goToVC = builder.createShopViewController(router: self)
        goToVC.modalTransitionStyle = .crossDissolve
        goToVC.modalPresentationStyle = .fullScreen
        vc.present(goToVC, animated: true)
    }
    
    func presentSettingViewController(from vc:UIViewController) {
        let goToVC = builder.createSettingsViewController(router: self)
        goToVC.modalTransitionStyle = .crossDissolve
        goToVC.modalPresentationStyle = .fullScreen
        vc.present(goToVC, animated: true)
    }
    
    func presentDailyBonusVC(from vc: UIViewController) {
        let goToVc = builder.createDailyBonusViewController(router: self)
        goToVc.modalTransitionStyle = .crossDissolve
        goToVc.modalPresentationStyle = .fullScreen
        vc.present(goToVc, animated: true)
    }
    
    func dismissViewController(_ vc: UIViewController) {
        vc.dismiss(animated: true)
    }
    
}
