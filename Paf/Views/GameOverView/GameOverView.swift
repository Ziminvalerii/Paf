//
//  GameOverView.swift
//  Paf
//
//  Created by Anastasia Koldunova on 30.09.2022.
//

import UIKit
import Lottie

protocol GameViewDelegate: AnyObject {
    func gameSceneButtonPressed()
    
    func goToHomeButtonPressed()
}

class GameOverView: UIView {

    @IBOutlet weak var bloodAnimationView: AnimationView! {
        didSet {
            bloodAnimationView.backgroundColor = .clear
            bloodAnimationView.contentMode = .scaleAspectFill
            bloodAnimationView.loopMode = .playOnce
        }
    }
    @IBOutlet weak var crackImageView: UIImageView!
    @IBOutlet weak var gameSceneButton: UIButton! {
        didSet {
            gameSceneButton.setTitle(isWin ? "Next level" : "Restart", for: .normal)
            
        }
    }
    @IBOutlet weak var statusImage: UIImageView! {
        didSet {
            statusImage.image = isWin ? UIImage(named: "winImage") : UIImage(named: "loseImage")
        }
    }
    @IBOutlet weak var homeButton: UIButton!
    
    weak var delegate: GameViewDelegate?
    var isWin: Bool
    var contentView: UIView?
    
     init(frame: CGRect, isWin: Bool) {
        self.isWin = isWin
        super.init(frame: frame)
        configureView()
    }
    required init?(coder aDecoder: NSCoder) {
        isWin = false
        super.init(coder: aDecoder)
        configureView()
    }
    //MARK: -View Configuration
    private func configureView() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        crackImageView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        crackImageView.alpha = 0
        bloodAnimationView.isHidden = isWin
        addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let nibName = String(describing: GameOverView.self)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func animateImageView() {
        if isWin {
            animateIn(crackImageView)
        } else {
            startAnimation(animationSpeed: 1, bloodAnimationView, complition: { _ in})
        }
    }
    
    private func startAnimation ( animationSpeed : CGFloat, _ animation : AnimationView, complition: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            animation.animationSpeed = animationSpeed
            animation.play(toFrame: 168)
        }
    }
    
    func animateIn(_ view: UIView) {
        UIView.animate(withDuration: 0.4, delay: 0.5) {
            view.alpha = 1
            view.transform = CGAffineTransform.identity
        }completion: { success in
            if success {
                AudioManager.shared.playSound(.glassBreak)
            }
        }
    }
     
    @IBAction func gameSceneButtonPressed(_ sender: Any) {
        AudioManager.shared.vibrate()
        delegate?.gameSceneButtonPressed()
    }
    @IBAction func goToHomeButtonPressed(_ sender: Any) {
        AudioManager.shared.vibrate()
        delegate?.goToHomeButtonPressed()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
