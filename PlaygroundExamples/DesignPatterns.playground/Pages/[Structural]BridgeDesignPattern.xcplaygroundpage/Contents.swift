//: [Previous](@previous)

import Foundation

//MARK: - Bridge design pattern
///In this pattern, instead creating an inheritance chain, we keep the object of the class. This reduces overhead
///when introdution new subClasses
protocol Burger {
    var type: String { get set }
    var side: Side? { get set }
    
}

protocol Side {
    var type: String { get set }
}
class Fries: NSObject, Side {
    var type: String = "Potato Fries"
    override var description: String {
        return "Sides - \(type)"
    }
}
class Chips: NSObject, Side {
    var type: String = "Potato Chips"
    override var description: String {
        return "Sides - \(type)"
    }
}

class ChickenBurger: NSObject, Burger {
    var type: String = "Chicken"
    var side: Side?
    
    init(side: Side? = nil) {
        self.side = side
    }
    
    override var description: String {
        return "Burger - \(type), \(String(describing: side))"
    }
}
class VegBuger: NSObject, Burger {
    var type: String = "Veg Patty"
    var side: Side?
    
    init(side: Side? = nil) {
        self.side = side
    }
    
    override var description: String {
        return "Burger - \(type), \(String(describing: side))"
    }
}

let chickenBurgerWithFries = ChickenBurger(side: Fries())
print(chickenBurgerWithFries)
//: [Next](@next)
