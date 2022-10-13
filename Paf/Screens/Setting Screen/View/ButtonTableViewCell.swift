//
//  ButtonTableViewCell.swift
//  Paf
//
//  Created by Anastasia Koldunova on 11.10.2022.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var cellButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
