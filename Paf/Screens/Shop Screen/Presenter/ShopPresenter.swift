//
//  ShopPresenter.swift
//  Paf
//
//  Created by Anastasia Koldunova on 29.09.2022.
//

import UIKit

protocol ShopView:AnyObject, MessageManager {
    func showBuyView(item: Amplifier)
    func collectionViewReloadData()
    func updateCoinsLabel()
}

protocol ShopPresenterProtocol: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    init(view: ShopView, router: RouterProtocol)
    func dismissVC(_ vc: UIViewController)
    func buyItem(amplifier: Amplifier)
    //    func goToNextPlayer()
    //    func goToPrevIndex()
    //    var playerIndex:Int {get}
}

class ShopPresenter: NSObject, ShopPresenterProtocol {
    weak var view: ShopView?
    private var router: RouterProtocol
    let amplifierArray = Amplifier.allCases
    
    required init(view: ShopView, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func dismissVC(_ vc: UIViewController) {
        router.dismissViewController(vc)
    }
    
    @objc func buyButtonPressed(_ sender: UIButton) {
        let amplifier = amplifierArray[sender.tag]
//        if amplifier == .curCharacter || amplifier == .character {
//            if AmplifierManager.availableAmplifiers.contains(.curCharacter) &&  AmplifierManager.availableAmplifiers.contains(.character){
//                if amplifier == .curCharacter {
//                    Settings.selectedIndex = 0
//                } else if amplifier == .character {
//                    Settings.selectedIndex = 1
//                }
//                view?.collectionViewReloadData()
//            }
//        } else {
        
            view?.showBuyView(item: amplifier)
//        }
    }
    
    func buyItem(amplifier: Amplifier) {
        if Settings.coins < amplifier.price {
            view?.showErrorMessage(title: "Error", message: "You dont have enought money", actionText: nil, isForever: false, action: nil)
            return
        } else {
            Settings.coins -= amplifier.price
            view?.updateCoinsLabel()
            AmplifierManager.availableAmplifiers.append(amplifier)
            view?.collectionViewReloadData()
        }
    }
    
}

extension ShopPresenter: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amplifierArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shop_cell", for: indexPath) as! ShopCollectionViewCell
        let data = amplifierArray[indexPath.row]
        if AmplifierManager.availableAmplifiers.contains(data) {
            cell.priceStackView.isHidden = true
            cell.buyButton.alpha = 0.8
            cell.buyButton.setTitle("Choosen", for: .normal)
            cell.buyButton.isEnabled = false
//            if data == .curCharacter {
//                if Settings.selectedIndex == 0 {
//                    cell.buyButton.setTitle("Choosen", for: .normal)
//                    cell.buyButton.isEnabled = false
//                } else  {
//                    cell.buyButton.setTitle("Choose", for: .normal)
//                    cell.buyButton.isEnabled = true
//                }
//            } else if data == .character {
//                if Settings.selectedIndex == 1 {
//                    cell.buyButton.setTitle("Choosen", for: .normal)
//                    cell.buyButton.isEnabled = false
//                } else  {
//                    cell.buyButton.setTitle("Choose", for: .normal)
//                    cell.buyButton.isEnabled = true
//                }
//            }
            
            
        }
        cell.buyButton.tag = indexPath.row
        cell.buyButton.addTarget(self, action: #selector(buyButtonPressed(_ :)), for: .touchUpInside)
        cell.configure(with: data.title, description: data.decription, price: data.price.description, image: data.image)
        return cell
    }
    
    
}

//extension ShopPresenter: BuyViewDelegate {
//    func confirmButtonPressed() {
//
//    }
//
//    func cancelButtonPressed() {
//        view
//    }
//
//
//}
