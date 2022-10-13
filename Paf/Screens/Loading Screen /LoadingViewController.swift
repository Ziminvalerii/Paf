//
//  LoadingViewController.swift
//  Paf
//
//  Created by Anastasia Koldunova on 11.10.2022.
//

import UIKit

class LoadingViewController: UIViewController {

    private lazy var welcomeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: 300, height: 50)
        imageView.center = view.center
        imageView.center.y -= 32
        imageView.image = UIImage(named: "welcome")
        return imageView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.frame.size = CGSize(width: 250, height: 50)
        progressView.center.x = view.center.x
        progressView.frame.origin.y = view.bounds.height - 50
        
        progressView.progressTintColor = UIColor(red: 29/255, green: 77/255, blue: 21/255, alpha: 1.0)
        
        progressView.trackTintColor = .lightGray.withAlphaComponent(0.5)
        
        progressView.progress = 0
//        progressView.
        
        progressView.transform = CGAffineTransform(scaleX: 1, y: 5)
        
        return progressView
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: "targetShoot")
        backgroundImageView.isUserInteractionEnabled = true
        return backgroundImageView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backgroundImageView)

        view.addSubview(progressView)
        
        view.addSubview(welcomeImageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let randomCount = Int.random(in: 3...6)
        let piece = 1.0 / Float(randomCount)

        for i in 1...randomCount {
            self.progressView.setProgress(Float(i) * piece, animated: true)
            if i == randomCount {
                RunLoop.current.run(until: Date() + Double.random(in: 0.8...1.5))
            }
        }
        
        let progressViewCenter = progressView.center
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.progressView.alpha = 0
        } completion: { _ in
            UIView.animate(withDuration: 1.5) { [weak self] in
                self?.welcomeImageView.center = progressViewCenter
                self?.welcomeImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            } completion: { _ in
                let builder = Builder()
                let router = Router(builder: builder)
//                let menuVC = MenuViewController()
                (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = router.presentStartGameController()
            }
        }
        
    }

}
