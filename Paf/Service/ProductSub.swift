//
//  ProductSub.swift
//  Paf
//
//  Created by Anastasia Koldunova on 02.10.2022.
//

import StoreKit

public struct ProductSub: Hashable {
    let subsctiption: Subscription
    var count: Int
    let title: String
    var price: String?
    let locale: Locale
    let product: SKProduct
    
    lazy var formatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.locale = locale
        return nf
    }()
    
    init(_ product: SKProduct) {
        self.product = product
        self.subsctiption = Subscription.allCases.first(where: {$0.rawValue == product.productIdentifier}) ?? .simplePLayer
        self.title = product.localizedTitle
        self.locale = product.priceLocale
        
        switch subsctiption {
        case .simplePLayer:
            count = 100
        case .simpleUpgratePlayer:
            count = 500
        case .middlePlayer:
            count = 2000
        case .upgratedMiddlePlayer:
            count = 10000
        case .stongPlayer:
            count = 25000
        case .upgradedStrongPlayer:
            count = 100000
        }
        self.price = formatter.string(from: product.price)
    }
    
    
}
