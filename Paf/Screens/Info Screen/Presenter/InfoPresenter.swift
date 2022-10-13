//
//  InfoPresenter.swift
//  Paf
//
//  Created by Anastasia Koldunova on 11.10.2022.
//

import UIKit

protocol InfoView:AnyObject {
    
}

protocol InfoPresenterProtocol: AnyObject {
    init(view: InfoView, router: RouterProtocol)
    func dissmissVC(_ vc: UIViewController)
}

class InfoPresenter: InfoPresenterProtocol {
    weak var view: InfoView?
    private var router: RouterProtocol
    
    required init(view: InfoView, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func dissmissVC(_ vc: UIViewController) {
        router.dismissViewController(vc)
    }
    
}
    
    
