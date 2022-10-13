//
//  DailyBonusPresenter.swift
//  Paf
//
//  Created by Anastasia Koldunova on 13.10.2022.
//

import Foundation


import UIKit

protocol DailyBonusView:AnyObject {
    
}

protocol DailyBonusPresenterProtocol: AnyObject {
    init(view: DailyBonusView, router: RouterProtocol)
    func dissmissVC(_ vc: UIViewController)
}

class DailyBonusPresenter: DailyBonusPresenterProtocol {
    weak var view: DailyBonusView?
    private var router: RouterProtocol
    
    required init(view: DailyBonusView, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func dissmissVC(_ vc: UIViewController) {
        router.dismissViewController(vc)
    }
    
}
    
    
