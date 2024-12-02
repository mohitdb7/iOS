//: [Previous](@previous)

import Foundation

protocol GearState {
    var bike: Bike? { get }
    func gearUp()
    func gearDown()
}

class FirstGear: GearState {
    private(set) weak var bike: Bike?
    init(bike: Bike?) {
        self.bike = bike
    }
    
    func gearUp() {
        let secondGear = SecondGear(bike: bike)
        bike?.gearState = secondGear
        print("Moved to gear 2")
    }
    func gearDown() {
        print("Already on lowest gear")
    }
}

class SecondGear: GearState {
    private(set) weak var bike: Bike?
    init(bike: Bike?) {
        self.bike = bike
    }
    
    func gearUp() {
        let thirdGear = ThirdGear(bike: bike)
        bike?.gearState = thirdGear
        print("Moved to gear 3")
    }
    func gearDown() {
        let firstGear = FirstGear(bike: bike)
        bike?.gearState = firstGear
        print("Moved to gear 1")
    }
}

class ThirdGear: GearState {
    private(set) weak var bike: Bike?
    init(bike: Bike?) {
        self.bike = bike
    }
    
    func gearUp() {
        let forthGear = ForthGear(bike: bike)
        bike?.gearState = forthGear
        print("Moved to gear 4")
    }
    func gearDown() {
        let secondGear = SecondGear(bike: bike)
        bike?.gearState = secondGear
        print("Moved to gear 2")
    }
}

class ForthGear: GearState {
    private(set) weak var bike: Bike?
    init(bike: Bike?) {
        self.bike = bike
    }
    
    func gearUp() {
        print("Already on top gear")
    }
    func gearDown() {
        let thirdGear = ThirdGear(bike: bike)
        bike?.gearState = thirdGear
        print("Moved to gear 3")
    }
}

class Bike {
    
    lazy var  gearState: GearState = {
        return FirstGear(bike: self)
    }()
    
    init() {}
}

let bike = Bike()
bike.gearState.gearUp()
bike.gearState.gearUp()
bike.gearState.gearUp()
bike.gearState.gearUp()
bike.gearState.gearDown()
bike.gearState.gearDown()
bike.gearState.gearDown()
bike.gearState.gearDown()
//: [Next](@next)
