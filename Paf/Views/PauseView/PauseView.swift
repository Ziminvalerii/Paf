//
//  PauseView.swift
//  Paf
//
//  Created by Anastasia Koldunova on 01.10.2022.
//

import UIKit

protocol PauseViewDelegate: AnyObject {
    func homeButtonPressed()
    func resumeButtonPressed()
}

class PauseView: UIView {
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    weak var delegate: PauseViewDelegate?
    var contentView: UIView?
    
     override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    //MARK: -View Configuration
    private func configureView() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let nibName = String(describing: PauseView.self)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    @IBAction func homeButtonPressed(_ sender: Any) {
        delegate?.homeButtonPressed()
    }
    @IBAction func resumeButtonPressed(_ sender: Any) {
        delegate?.resumeButtonPressed()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
