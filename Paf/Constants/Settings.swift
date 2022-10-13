//
//  Settings.swift
//  Paf
//
//  Created by Anastasia Koldunova on 04.10.2022.
//

import Foundation


struct Settings {
    
    static let playerArray: [PlayerModel] = [
        PlayerModel(index: 0, speed: 300),
        PlayerModel(index: 1, speed: 500)
//        PlayerModel(index: 1, health: 3, damage: 200, speed: 300, schootingDistance: 300, purchId: .simplePLayer),
//        PlayerModel(index: 2, health: 3, damage: 200, speed: 300, schootingDistance: 300, purchId: .simpleUpgratePlayer),
//        PlayerModel(index: 3, health: 3, damage: 200, speed: 300, schootingDistance: 300, purchId: .middlePlayer),
//        PlayerModel(index: 4, health: 3, damage: 200, speed: 300, schootingDistance: 300, purchId: .upgratedMiddlePlayer),
//        PlayerModel(index: 5, health: 3, damage: 200, speed: 300, schootingDistance: 300, purchId: .stongPlayer),
//        PlayerModel(index: 6, health: 3, damage: 200, speed: 300, schootingDistance: 300, purchId: .upgradedStrongPlayer)
    ]
    
    static var coins: Int {
        get {
            UserDefaults.standard.integer(forKey: "current_coins")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "current_coins")
        }
    }
    
    static var curLevel: Int {
        get {
            UserDefaults.standard.integer(forKey: "current_level")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "current_level")
        }
    }
    
    static var selectedIndex: Int {
        get {
            UserDefaults.standard.integer(forKey: "selected_character")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "selected_character")
        }
    }
    
    static var selectedCharacter: PlayerModel {
        return playerArray[selectedIndex]
    }
    
    static let enemyArray:[EnemyModel] = [
    EnemyModel(index: 0, demage: 1),
    EnemyModel(index: 1, demage: 1),
    EnemyModel(index: 2, demage: 1),
    EnemyModel(index: 3, demage: 1),
    EnemyModel(index: 4, demage: 1)]
    
    
}
