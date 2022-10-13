//
//  IAPManager.swift
//  Paf
//
//  Created by Anastasia Koldunova on 02.10.2022.
//
import StoreKit

public typealias ProductsRequestCompletionHandler = (_ products: [ProductSub]?) -> Void
public typealias ProductPurchaseCompletionHandler = (_ success: Bool, _ productId : String?) -> Void


class IAPManager: NSObject {
    //MARK: -Properties
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    private var productPurchaseCompletionHandler: ProductPurchaseCompletionHandler?
    private let productsID = Set([
        Subscription.simplePLayer.rawValue,
        Subscription.simpleUpgratePlayer.rawValue,
        Subscription.middlePlayer.rawValue,
        Subscription.upgratedMiddlePlayer.rawValue,
        Subscription.stongPlayer.rawValue,
        Subscription.upgradedStrongPlayer.rawValue
    ])
    
    //MARK: -Initializer
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    //MARK: -RequestProduct
    func requestProducts(_ complition: @escaping ProductsRequestCompletionHandler) {
        productsRequestCompletionHandler = complition
        let request = SKProductsRequest(productIdentifiers: productsID)
        request.delegate = self
        request.start()
    }
    //MARK: -PurchaseProduct
    func buyProduct(_ id: SKProduct, _ complition: @escaping ProductPurchaseCompletionHandler) {
        guard SKPaymentQueue.canMakePayments() else { return }
        productPurchaseCompletionHandler = complition
        let payment = SKPayment(product: id)
        SKPaymentQueue.default().add(payment)
        
    }
}
//MARK: -SKProductsRequestDelegate
extension IAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        productsRequestCompletionHandler?(response.products.map { ProductSub($0)})
        clearRequestAndHandler()
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        if request is SKProductsRequest {
            print("Subscription Options Failed Loading: \(error.localizedDescription)")
        }
        productsRequestCompletionHandler?(nil)
        clearRequestAndHandler()
    }
    private func clearRequestAndHandler() {
        productsRequestCompletionHandler = nil
    }
    
}
//MARK: - Subscription Enum
enum Subscription:String, CaseIterable {
    case simplePLayer = "com.simple.player"
    case simpleUpgratePlayer = "com.upgratedSimple.player"
    case middlePlayer = "com.middlePlayer.player"
    case upgratedMiddlePlayer = "com.upgratedMiddle.player"
    case stongPlayer = "com.strong.player"
    case upgradedStrongPlayer = "com.upgratedStong.player"
    
}
//MARK: -SKPaymentTransactionObserver
extension IAPManager: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
//                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        productPurchaseCompleted(productID: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as NSError?,
           let localizedDescription = transaction.error?.localizedDescription,
           transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }
        
        productPurchaseCompletionHandler?(false, nil)
        SKPaymentQueue.default().finishTransaction(transaction)
        clearHandler()
    }
     
    private func productPurchaseCompleted(productID : String) {
        productPurchaseCompletionHandler?(true, productID)
        clearHandler()
    }
    
    private func clearHandler() {
        productPurchaseCompletionHandler = nil
    }
    
}

