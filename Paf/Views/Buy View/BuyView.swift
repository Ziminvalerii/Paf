//
//  BuyView.swift
//  Paf
//
//  Created by Anastasia Koldunova on 10.10.2022.
//

import UIKit

protocol BuyViewDelegate: AnyObject {
    func confirmButtonPressed(item: Amplifier)
    func cancelButtonPressed(item: Amplifier)
}

class BuyView: UIView {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    weak var delegate: BuyViewDelegate?
    var amplifier: Amplifier
    var contentView: UIView?
    
    init(frame: CGRect, amplifier: Amplifier) {
        self.amplifier = amplifier
        super.init(frame: frame)
        configureView()
    }
    required init?(coder aDecoder: NSCoder) {
        amplifier = .pill
        super.init(coder: aDecoder)
        configureView()
        
    }
    //MARK: -View Configuration
    private func configureView() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.layer.cornerRadius = 10
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let nibName = String(describing: BuyView.self)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        delegate?.cancelButtonPressed(item: amplifier)
    }
    @IBAction func confirmButtonPressed(_ sender: Any) {
        delegate?.confirmButtonPressed(item: amplifier)
    }
}
