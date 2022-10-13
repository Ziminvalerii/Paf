//
//  SwitchTableViewCell.swift
//  Paf
//
//  Created by Anastasia Koldunova on 07.10.2022.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
