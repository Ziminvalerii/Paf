//
//  ShopCollectionViewCell.swift
//  Paf
//
//  Created by Anastasia Koldunova on 09.10.2022.
//

import UIKit

class ShopCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var priceStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    
    func configure(with title:String, description: String, price: String, image: UIImage) {
        titleLabel.text = title
        descriptionLabel.text = description
        priceLabel.text = price
        productImageView.image = image
    }
}
