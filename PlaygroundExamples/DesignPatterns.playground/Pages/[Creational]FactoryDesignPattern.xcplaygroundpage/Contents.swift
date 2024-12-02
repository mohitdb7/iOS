//: [Previous](@previous)

import Foundation

//MARK: - Factory design pattern
///In this design pattern, the reference is provided by the facrory depending on some condition
///The object creation is abstract and the caller does not know about how the object is created and provided
///
class FactoryUser {
    let mobile: FactoryMobile
    init(mobile: FactoryMobile) {
        self.mobile = mobile
    }
    
    func logMobile() {
        print("Brand - \(mobile.model), Price - \(mobile.price)")
    }
}

protocol FactoryMobile {
    var model: String { get set }
    var price: Double { get set }
}
class FactorySamsung: FactoryMobile {
    var model: String
    var price: Double
    
    init(model: String, price: Double) {
        self.model = model
        self.price = price
    }
}
class FactoryAppleMobile: FactoryMobile {
    var model: String
    var price: Double
    
    init(model: String, price: Double) {
        self.model = model
        self.price = price
    }
}

enum FactoryMobileBrand {
    case apple
    case samsung
}
class FactoryMobileFactory {
    static func makeMobile(_ type: FactoryMobileBrand) -> FactoryMobile {
        switch type {
            case .apple:
                return FactoryAppleMobile(model: "iPhone 14", price: 800000)
            case .samsung:
                return FactorySamsung(model: "Samsung Note 5", price: 500000)
        }
    }
}


let user = FactoryUser(mobile: FactoryMobileFactory.makeMobile(.apple))
user.logMobile()
