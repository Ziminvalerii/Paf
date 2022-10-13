//
//  InfoViewController.swift
//  Paf
//
//  Created by Anastasia Koldunova on 11.10.2022.
//

import UIKit

class InfoViewController: BaseViewController<InfoPresenterProtocol>, InfoView {

    @IBOutlet weak var overlayView: UIView! {
        didSet {
            let ges = UITapGestureRecognizer(target: self, action: #selector(dissmissView))
            overlayView.addGestureRecognizer(ges)
        }
    }
    @IBOutlet weak var tapToShoot: UIImageView! {
        didSet {
            tapToShoot.alpha = 0
        }
    }
    @IBOutlet weak var tapToAccelerateImage: UIImageView! {
        didSet {
            tapToAccelerateImage.alpha = 0
        }
    }
    @IBOutlet weak var tapToMoveImage: UIImageView! {
        didSet {
            tapToMoveImage.alpha = 0
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    @objc func dissmissView() {
        presenter.dissmissVC(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0.25, options: .curveEaseOut) {
            self.tapToMoveImage.alpha = 1
        }completion: { succes in
            if succes {
//                self.tapToMoveImage.doGlowAnimation(withColor: .white, withEffect: .big)
                UIView.animate(withDuration: 0.5, delay: 0.25, options: .curveEaseOut) {
                    self.tapToAccelerateImage.alpha = 1
                } completion: { success in
                    if succes {
//                        self.tapToAccelerateImage.doGlowAnimation(withColor: .white, withEffect: .big)
                        UIView.animate(withDuration: 0.5, delay: 0.25, options: .curveEaseOut) {
                            self.tapToShoot.alpha = 1
                        } completion: { success in
                            if succes {
//                                self.tapToShoot.doGlowAnimation(withColor: .white, withEffect: .big)
                            }
                        }
                    }
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
