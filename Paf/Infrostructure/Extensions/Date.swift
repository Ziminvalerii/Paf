//
//  Date.swift
//  Paf
//
//  Created by Anastasia Koldunova on 13.10.2022.
//

import Foundation

extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
