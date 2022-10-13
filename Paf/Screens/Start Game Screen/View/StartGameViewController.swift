//
//  StartGameViewController.swift
//  Paf
//
//  Created by Anastasia Koldunova on 28.09.2022.
//

import UIKit
import Lottie

class StartGameViewController: BaseViewController<StartGamePresenterProtocol>, StartGameView {

    @IBOutlet weak var bonusButton: UIButton!
    @IBOutlet weak var levelLabel: UILabel!
    var startButtonCenterX : NSLayoutConstraint?
    @IBOutlet weak var animatonView: AnimationView! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(startButtonPressed))
            animatonView.addGestureRecognizer(gesture)
            animatonView.backgroundColor = .clear
            animatonView.contentMode = .scaleAspectFill
            animatonView.loopMode = .repeat(3)
        }
    }
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var detailsButton: UIButton!
//    @IBOutlet weak var shopButton: UIButton!
//    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        startButtonCenterX = view.constraints.first(where: {$0.identifier == "shopButtonCenterX"})
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startButtonCenterX?.constant = -view.bounds.size.width
        animatonView.currentFrame = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        levelLabel.text = "LEVEL: \(Settings.curLevel.description)"
        animatonView.doGlowAnimation(withColor: UIColor.white, withEffect: .normal)
        UIView.animate(withDuration: 0.5, delay: 0.25, options: .curveEaseOut) {
            self.startButtonCenterX?.constant += self.view.bounds.size.width
            self.view.layoutIfNeeded()
        }
        let isBonusEnabled = Defaults.dailyBonusDate == nil || (Date() - (Defaults.dailyBonusDate ?? Date())) > 24*60*60
        bonusButton.isEnabled = isBonusEnabled
        bonusButton.alpha = isBonusEnabled ? 1 : 0.75
    }
    
    private func startAnimation ( animationSpeed : CGFloat, _ animation : AnimationView, complition: @escaping (Bool) -> Void) {
        animation.animationSpeed = animationSpeed
        animation.play(completion: complition)
    }
    
    @objc func startButtonPressed() {
        AudioManager.shared.playSound(.gunShot)
                AudioManager.shared.vibrate()
                startAnimation(animationSpeed: 1, animatonView) { finished in
                    if finished {
                        self.animatonView.removeGlowAnimation()
                        self.presenter.goToGameViewController(from: self)
                    }
                }
    }
    
    @IBAction func bonusButtonPressed(_ sender: Any) {
        if Defaults.dailyBonusDate == nil || (Date() - Defaults.dailyBonusDate!) > 24*60*60 {
            presenter.goToBonusVC(from: self)
        }
    }
    @IBAction func settingsButtonPressed(_ sender: Any) {
        presenter.goToSettingViewController(from: self)
    }
    @IBAction func detailsButtonPressed(_ sender: Any) {
        presenter.goToInfoVC(from: self)
    }
    @IBAction func shopButtonPressed(_ sender: Any) {
        AudioManager.shared.vibrate()
        presenter.goToShopViewController(from: self)
    }
//    @IBAction func startButtonPressed(_ sender: Any) {
//        AudioManager.shared.playSound(.gunShot)
//        AudioManager.shared.vibrate()
//        startAnimation(animationSpeed: 1, animatonView) { finished in
//            if finished {
//                self.animatonView.removeGlowAnimation()
//                self.presenter.goToGameViewController(from: self)
//            }
//        }
//        
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
