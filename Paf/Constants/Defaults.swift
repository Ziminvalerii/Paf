//
//  Defaults.swift
//  Paf
//
//  Created by Anastasia Koldunova on 29.09.2022.
//

import Foundation


class Defaults {
    
    enum Key {
        static let musicStatus = "music_status"
        static let invertedControl = "inverted_control"
        static let dailyBonusDate = "daily_bonus_date"
    }
    
    static var dailyBonusDate: Date? {
        get {
            UserDefaults.standard.value(forKey: Key.dailyBonusDate) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.dailyBonusDate)
        }
    }
    
    static var invertedControl: Bool {
        get {
            UserDefaults.standard.bool(forKey: Key.invertedControl)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.invertedControl)
        }
    }
    
    static var isMusicOff: Bool {
        get {
            UserDefaults.standard.bool(forKey: Key.musicStatus)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.musicStatus)
        }
    }
}
