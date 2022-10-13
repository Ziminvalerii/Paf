//
//  GameViewController.swift
//  Paf
//
//  Created by Anastasia Koldunova on 28.09.2022.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: BaseViewController<GamePresenterProtocol>, GameView {
    @IBOutlet weak var pauseButton: UIButton!
    var gameOverScene: GameOverView?
    var pausedView: PauseView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                if let scene = scene as? GameScene {
                    scene.parantVC = self
                    scene.gameoverDelegate = self
                }
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
//            view.showsFPS = true
//            view.showsNodeCount = true
        }
    }
    
    func animateIn(_ view: UIView) {
        view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        view.alpha = 0
        UIView.animate(withDuration: 0.4) {
            view.alpha = 1
            view.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut(_ view : UIView, complition: @escaping () -> Void) {
        UIView.animate(withDuration: 0.4) {
            view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            view.alpha = 0
        } completion: { (_) in
            view.removeFromSuperview()
            complition()
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBAction func pauseButtonPressed(_ sender: Any) {
        pausedView = PauseView(frame: view.bounds)
        let gameView = view as! SKView
        gameView.isPaused = true
        pausedView!.delegate = self
        view.addSubview(pausedView!)
        animateIn(pausedView!)
        
    }
}
extension GameViewController: GameOverDelegate {
    func gameOver(win: Bool) {
        gameOverScene = GameOverView(frame: view.bounds, isWin: win)
        let gameView = view as! SKView
        gameView.isPaused = true
        gameOverScene!.delegate = self
        view.addSubview(gameOverScene!)
        animateIn(gameOverScene!)
        gameOverScene!.animateImageView()
    }
    
    
}

extension GameViewController: GameViewDelegate {
    
    func gameSceneButtonPressed() {
        let gameView = view as! SKView
        gameView.isPaused = false
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                if let scene = scene as? GameScene {
                    scene.parantVC = self
                    scene.gameoverDelegate = self
                }
                
                // Present the scene
                view.presentScene(scene)
                animateOut(gameOverScene!, complition: {})
            }
        }
    }
    
    func goToHomeButtonPressed() {
        presenter.dismiss(self)
    }
    
    
}

extension GameViewController:PauseViewDelegate {
    func homeButtonPressed() {
        presenter.dismiss(self)
    }
    
    func resumeButtonPressed() {
        animateOut(pausedView!, complition: {})
        let gameView = view as! SKView
        gameView.isPaused = false
        
    }
    
    
}
