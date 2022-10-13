//
//  DailyBonusViewController.swift
//  Paf
//
//  Created by Anastasia Koldunova on 13.10.2022.
//

import UIKit

class DailyBonusViewController: BaseViewController<DailyBonusPresenterProtocol>, DailyBonusView {

    @IBOutlet weak var bonusLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        Defaults.dailyBonusDate = Date()
        Settings.coins += 100
    }
    

    @IBAction func crossButtonPressed(_ sender: Any) {
        presenter.dissmissVC(self)
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
