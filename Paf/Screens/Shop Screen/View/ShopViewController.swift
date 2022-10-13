//
//  ShopViewController.swift
//  Paf
//
//  Created by Anastasia Koldunova on 29.09.2022.
//

import UIKit

class ShopViewController: BaseViewController<ShopPresenterProtocol>, ShopView, AnimationViewProtocol {

    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = presenter
            collectionView.delegate = presenter
            let layout = UPCarouselFlowLayout()
            layout.itemSize = CGSize(width: 200, height: 250)
            layout.scrollDirection = .horizontal
            collectionView.collectionViewLayout = layout
        }
    }
    
    var collectionViewCenterY : NSLayoutConstraint?
    let overlay = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var buyView: BuyView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewCenterY = view.constraints.first(where: {$0.identifier == "collectionViewCenterY"})
//        AmplifierManager.currentAmplifier = array
//        AmplifierManager.availableAmplifiers.append(.character)
//        updatePlayer(Settings.selectedCharacter)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionViewCenterY?.constant = view.bounds.size.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        coinsLabel.text = Settings.coins.description
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut) {
            self.collectionViewCenterY?.constant = 10
            self.view.layoutIfNeeded()
        }
    }

   
    @IBAction func crossButtonTapped(_ sender: Any) {
        presenter.dismissVC(self)
    }
    
    func updateCoinsLabel() {
        coinsLabel.text = Settings.coins.description
    }
    
    func collectionViewReloadData() {
        collectionView.reloadData()
    }
    func showBuyView(item: Amplifier) {
        buyView = BuyView(frame: CGRect(x: 0, y: 0, width: 200, height: 150), amplifier: item)
        view.addSubview(overlay)
        buyView!.center = overlay.center
        self.view.addSubview(buyView!)
        buyView!.delegate = self
        animateIn(buyView!, overlay: overlay)
    }
//
//    func updatePlayer(_ model: PlayerModel) {
//        playerImageView.image = model.image
//        distanceLabel.text = model.schootingDistance.description
//        speedLabel.text = model.speed.description
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ShopViewController: BuyViewDelegate {
    func confirmButtonPressed(item: Amplifier) {
        presenter.buyItem(amplifier: item)
//        collectionView.reloadData()
        animateOut(buyView!, overlay: overlay)
    }
    
    func cancelButtonPressed(item: Amplifier) {
        animateOut(buyView!, overlay: overlay)
    }
    

    
}
