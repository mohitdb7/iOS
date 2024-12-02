//: [Previous](@previous)

import Foundation
//MARK: - Builder design pattern
///In this design pattern when the initialisation of the object is very complex and huge, we create a builder class
///to change the  values of the properties which in turn will return the instance with modified values. Only the properties we will modify
///will have changed value, rest all properties will have the default values
class Burger: NSObject {
    var toppings: Bool = true
    var sauses: Bool = true
    var onions: Bool = true
    var tomato: Bool = true
    var doublePatty: Bool = false
    var jalepenos: Bool = true
    var pickels: Bool = true
    
    public override var description: String {
        var des: String = "\(type(of: self)) :\n"
        for child in Mirror(reflecting: self).children {
            if let propName = child.label {
                des += "\(propName): \(child.value) \n"
            }
        }
        
        return des
    }
}

class BurgerBuilder {
    private let burger: Burger
    
    init() {
        burger = Burger()
    }
    
    func updateToppings(add flag: Bool) -> BurgerBuilder {
        burger.toppings = flag
        return self
    }
    func updateSauses(add flag: Bool) -> BurgerBuilder {
        burger.sauses = flag
        return self
    }
    func updateOnions(add flag: Bool) -> BurgerBuilder {
        burger.onions = flag
        return self
    }
    func updateTomato(add flag: Bool) -> BurgerBuilder {
        burger.tomato = flag
        return self
    }
    func updateDoublePatty(add flag: Bool) -> BurgerBuilder {
        burger.doublePatty = flag
        return self
    }
    func updateJalepenos(add flag: Bool) -> BurgerBuilder {
        burger.jalepenos = flag
        return self
    }
    func updatePickels(add flag: Bool) -> BurgerBuilder {
        burger.pickels = flag
        return self
    }
    func getBurger() -> Burger {
        return burger
    }
}


let burger = BurgerBuilder()
    .updateDoublePatty(add: true)
    .updateTomato(add: false)
    .getBurger()
print("\(burger)")
