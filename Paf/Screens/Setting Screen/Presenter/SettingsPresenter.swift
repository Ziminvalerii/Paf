//
//  SettingsPresenter.swift
//  Paf
//
//  Created by Anastasia Koldunova on 29.09.2022.
//

import UIKit


protocol SettingsView:AnyObject {
    
}

protocol SettingsPresenterProtocol: UITableViewDelegate, UITableViewDataSource {
    init(view: SettingsView, router: RouterProtocol)
    func dissmissVC(_ vc: UIViewController)
    func presentShopVC(at vc: UIViewController)
}

class SettingsPresenter: NSObject, SettingsPresenterProtocol {
   
    
    weak var view: SettingsView?
    private var router: RouterProtocol
    
    required init(view: SettingsView, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func presentShopVC(at vc: UIViewController) {
        router.presentShopViewController(from: vc)
    }
    
    func dissmissVC(_ vc: UIViewController) {
        router.dismissViewController(vc)
    }
    
    @objc func sliderValueChanged(_ sender:UISlider) {
        UIScreen.main.brightness = CGFloat(sender.value)
        
    }
    @objc func buyButtonTapped() {
        Settings.curLevel = 0
    }
    @objc func switchViewValueChanged(_ sender:UISwitch) {
        switch sender.tag {
        case 0 :
           AudioManager.shared.isSilent = !sender.isOn
        case 1:
            AudioManager.shared.IsVibrationOn = sender.isOn
        case 2:
            Defaults.invertedControl = sender.isOn
            print("")
        default:
            break
        }
    }
}

extension SettingsPresenter: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "slider_cell", for: indexPath) as! SliderTableViewCell
            cell.sliderCell.addTarget(self, action: #selector(sliderValueChanged(_ :)), for: .valueChanged)
            cell.sliderCell.value = Float(UIScreen.main.brightness)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "switch_cell", for: indexPath) as! SwitchTableViewCell
            switch indexPath.row {
            case 0:
                cell.switchView.isOn = !AudioManager.shared.isSilent
                cell.configure(title: "MUSIC")
            case 1:
                cell.switchView.isOn = AudioManager.shared.IsVibrationOn
                cell.configure(title: "VIBRATION")
            case 2:
                cell.switchView.isOn = Defaults.invertedControl
                cell.configure(title: "IVERTED CONTROLS")
            case 3:
                let buttonCell = tableView.dequeueReusableCell(withIdentifier: "button_cell", for: indexPath) as! ButtonTableViewCell
                buttonCell.cellButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
                return buttonCell
            default:
                break;
            }
            cell.switchView.tag = indexPath.row
            cell.switchView.addTarget(self, action: #selector(switchViewValueChanged(_ :)), for: .valueChanged)
            return cell
        }
    }
}
