//
//  amplifiersManager.swift
//  Paf
//
//  Created by Anastasia Koldunova on 10.10.2022.
//

import SpriteKit

enum Amplifier: String, CaseIterable {
    case curCharacter = "com.curCharacter.id"
    case wearpon = "com.werapon.id"
    case pill = "com.pill.id"
    case medicine = "com.medicine.id"
    case boots = "com.boots.id"
    case jetpack = "com.jetpack.id"
//    case character = "com.character.id"
    
    
    var title: String {
        switch self {
        case .wearpon:
            return "Wearpon"
        case .pill:
            return "Magic pill"
        case .medicine:
            return "Magic medicine"
        case .boots:
            return "Aceleration boots"
        case .jetpack:
            return "Jetpack"
//        case .character:
//            return "Steven"
        case .curCharacter :
            return "Mike"
        }
    }
    
    var decription: String {
        switch self {
        case .wearpon:
            return "Bullet speed: 0.35\nFlight range: 1 s."
        case .pill:
            return "Increase hearts up to 4"
        case .medicine:
            return "Increase hearts up to 5"
        case .boots:
            return "Acceleration for 3 seconds"
        case .jetpack:
            return "Acceleration for 6 seconds"
//        case .character:
//            return "Character speed insreased"
        case .curCharacter:
            return "Your current character"
        }
    }
    
    var image: UIImage {
        switch self {
        case .wearpon:
            return UIImage(named: "weapon")!
        case .pill:
            return UIImage(named: "pill")!
        case .medicine:
            return UIImage(named: "medicine")!
        case .boots:
            return UIImage(named: "magicBoots")!
        case .jetpack:
            return UIImage(named: "jetpack")!
//        case .character:
//            return UIImage(named: "player2Icon")!
        case .curCharacter:
            return  UIImage(named: "player1Icon")!
        }
    }
    
    var price: Int {
        switch self {
        case .curCharacter:
            return 0
        case .wearpon:
            return 500
        case .pill:
            return 700
        case .medicine:
            return 1000
        case .boots:
            return 1000
        case .jetpack:
            return 1500
//        case .character:
//            return 2000
        }
    }
  
}


class AmplifierManager {
    
    static var availableAmplifiers: [Amplifier] {
            get {
                var availableAmplifiers = [Amplifier]()
                let arr = UserDefaults.standard.object(forKey: "availible_apmlifier") as? [String] ?? []
                if arr.count == 0 {
                    let arr = [Amplifier.curCharacter]
                    availableAmplifiers = arr
                }
                for key in arr {
                    if let character = Amplifier(rawValue: key) {
                        availableAmplifiers.append(character)
                    }
                }
                return availableAmplifiers
            } set {
                var avAmplifiers = [String]()
                for item in newValue {
                    avAmplifiers.append(item.rawValue)
                }
                if avAmplifiers.count == 0 {
                    avAmplifiers.append(Amplifier.curCharacter.rawValue)
                }
                UserDefaults.standard.set(avAmplifiers, forKey: "availible_apmlifier")
            }
        }
    
    static var bulletSpeed:CGFloat? {
        if availableAmplifiers.contains(.wearpon) {
            return 1.5
        } else {
            return nil
        }
    }
    
    static var bulletDistanse:TimeInterval? {
        if availableAmplifiers.contains(.wearpon) {
            return 1.2
        } else {
            return nil
        }
    }
    
    static var health: Int? {
        if availableAmplifiers.contains(.medicine) {
            return 5
        } else if availableAmplifiers.contains(.pill) {
            return 4
        } else {
            return nil
        }
    }
    
    static var accleration: TimeInterval? {
        if availableAmplifiers.contains(.jetpack) {
            return 6
        } else if availableAmplifiers.contains(.boots) {
            return 3
        } else {
            return nil
        }
    }
    
//    static var newCharacter: PlayerModel {
//        if availableAmplifiers.contains(.character) {
//            return Settings.playerArray[1]
//        } else {
//            return Settings.playerArray[0]
//        }
//    }
//    
    
//    static var currentAmplifier: [s]
}
