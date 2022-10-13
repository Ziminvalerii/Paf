//
//  EnemyManager.swift
//  Paf
//
//  Created by Anastasia Koldunova on 30.09.2022.
//

import Foundation


struct EnemyManager {
    static let enemyArray:[EnemyModel] = [
    EnemyModel(index: 0, demage: 1),
    EnemyModel(index: 1, demage: 1),
    EnemyModel(index: 2, demage: 1),
    EnemyModel(index: 3, demage: 1),
    EnemyModel(index: 4, demage: 1)]
    
    
    static let randomEnemy = enemyArray[Int.random(in: 0...4)]
}
