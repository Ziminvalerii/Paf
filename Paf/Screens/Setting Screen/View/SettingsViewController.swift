//
//  SettingsViewController.swift
//  Paf
//
//  Created by Anastasia Koldunova on 29.09.2022.
//

import UIKit

class SettingsViewController: BaseViewController<SettingsPresenterProtocol>, SettingsView {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = presenter
            tableView.delegate = presenter
            tableView.layer.cornerRadius = 10
            tableView.automaticallyAdjustsScrollIndicatorInsets = false
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 0))
            tableView.tableFooterView = nil
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
